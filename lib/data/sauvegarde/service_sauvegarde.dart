import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../local/database.dart';

/// Fichier illisible, d'une autre application ou d'une version plus récente.
class SauvegardeInvalide implements Exception {
  const SauvegardeInvalide(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Contenu d'une sauvegarde, vérifié, prêt à être restauré.
class Sauvegarde {
  const Sauvegarde._({
    required this.creeLe,
    required this.tables,
    required this.photos,
  });

  final DateTime creeLe;
  final Map<String, List<Map<String, Object?>>> tables;

  /// Chemin relatif → contenu.
  final Map<String, Uint8List> photos;

  int get nombreBiens => tables['biens']?.length ?? 0;
}

/// Sauvegarde de toutes les données dans un seul fichier JSON (tables et
/// photos), restauration et effacement complet.
///
/// Le fichier reprend les lignes SQLite telles quelles : une sauvegarde
/// d'une version antérieure du schéma se restaure dans la version actuelle
/// (les colonnes ajoutées depuis prennent leur valeur par défaut).
class ServiceSauvegarde {
  ServiceSauvegarde({
    required this._db,
    required this._documents,
    DateTime Function()? horloge,
  }) : _horloge = horloge ?? DateTime.now;

  final AppDatabase _db;
  final Directory _documents;
  final DateTime Function() _horloge;

  static const application = 'Pense-Bail';

  /// Version du format de fichier (pas du schéma de la base).
  static const format = 1;

  static const _dossierPhotos = 'photos';

  String nomFichier() {
    final d = _horloge();
    String deux(int n) => n.toString().padLeft(2, '0');
    return 'pense-bail-sauvegarde-${d.year}-${deux(d.month)}-${deux(d.day)}.json';
  }

  Future<Uint8List> exporter() async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final table in _db.allTables) {
      final lignes = await _db
          .customSelect('SELECT * FROM "${table.actualTableName}"')
          .get();
      tables[table.actualTableName] = [for (final l in lignes) l.data];
    }

    final photos = <String, String>{};
    for (final bien in tables['biens'] ?? const <Map<String, Object?>>[]) {
      final chemin = bien['photo_chemin'];
      if (chemin is! String) continue;
      final fichier = File(p.join(_documents.path, chemin));
      if (await fichier.exists()) {
        photos[_normaliser(chemin)] = base64Encode(await fichier.readAsBytes());
      }
    }

    return utf8.encode(
      jsonEncode({
        'application': application,
        'format': format,
        'schema': _db.schemaVersion,
        'creeLe': _horloge().toIso8601String(),
        'tables': tables,
        'photos': photos,
      }),
    );
  }

  /// Vérifie le fichier sans rien modifier.
  Sauvegarde lire(Uint8List contenu) {
    final Object? racine;
    try {
      racine = jsonDecode(utf8.decode(contenu));
    } on FormatException {
      throw const SauvegardeInvalide(
        'Ce fichier n\'est pas une sauvegarde Pense-Bail.',
      );
    }
    if (racine is! Map<String, Object?> ||
        racine['application'] != application) {
      throw const SauvegardeInvalide(
        'Ce fichier n\'est pas une sauvegarde Pense-Bail.',
      );
    }
    final versionFormat = racine['format'];
    final schema = racine['schema'];
    if (versionFormat is! int ||
        schema is! int ||
        versionFormat > format ||
        schema > _db.schemaVersion) {
      throw const SauvegardeInvalide(
        'Cette sauvegarde vient d\'une version plus récente de Pense-Bail. '
        'Mettez l\'application à jour, puis réessayez.',
      );
    }

    final creeLe = DateTime.tryParse('${racine['creeLe']}');
    final tablesJson = racine['tables'];
    final photosJson = racine['photos'] ?? const <String, Object?>{};
    if (creeLe == null ||
        tablesJson is! Map<String, Object?> ||
        photosJson is! Map<String, Object?>) {
      throw const SauvegardeInvalide('Cette sauvegarde est incomplète.');
    }

    // Seules les tables et colonnes connues sont acceptées.
    final connues = {
      for (final t in _db.allTables)
        t.actualTableName: {for (final c in t.$columns) c.name},
    };
    final tables = <String, List<Map<String, Object?>>>{};
    for (final MapEntry(key: nom, value: lignes) in tablesJson.entries) {
      final colonnes = connues[nom];
      if (colonnes == null || lignes is! List) {
        throw SauvegardeInvalide(
          'Contenu inattendu dans la sauvegarde : $nom.',
        );
      }
      tables[nom] = [
        for (final ligne in lignes)
          if (ligne is Map<String, Object?> &&
              ligne.keys.every(colonnes.contains) &&
              ligne.values.every(_valeurSimple))
            ligne
          else
            throw SauvegardeInvalide(
              'Contenu inattendu dans la sauvegarde : $nom.',
            ),
      ];
    }

    final photos = <String, Uint8List>{};
    for (final MapEntry(key: chemin, value: donnees) in photosJson.entries) {
      final normalise = _normaliser(chemin);
      if (!_cheminPhotoSur(normalise) || donnees is! String) {
        throw const SauvegardeInvalide('Photo inattendue dans la sauvegarde.');
      }
      try {
        photos[normalise] = base64Decode(donnees);
      } on FormatException {
        throw const SauvegardeInvalide(
          'Une photo de la sauvegarde est abîmée.',
        );
      }
    }
    return Sauvegarde._(creeLe: creeLe, tables: tables, photos: photos);
  }

  /// Remplace toutes les données actuelles par celles de la [sauvegarde].
  Future<void> restaurer(Sauvegarde sauvegarde) async {
    await _db.transaction(() async {
      await _viderTables();
      // Ordre de déclaration : les tables parentes avant leurs dépendances.
      for (final table in _db.allTables) {
        for (final ligne in sauvegarde.tables[table.actualTableName] ?? []) {
          if (ligne.isEmpty) continue;
          final colonnes = ligne.keys.map((c) => '"$c"').join(', ');
          final marques = List.filled(ligne.length, '?').join(', ');
          await _db.customInsert(
            'INSERT INTO "${table.actualTableName}" ($colonnes) '
            'VALUES ($marques)',
            variables: [for (final v in ligne.values) Variable<Object>(v)],
            updates: {table},
          );
        }
      }
    });
    await _supprimerPhotos();
    for (final MapEntry(key: chemin, value: octets)
        in sauvegarde.photos.entries) {
      final fichier = File(p.joinAll([_documents.path, ...chemin.split('/')]));
      await fichier.parent.create(recursive: true);
      await fichier.writeAsBytes(octets);
    }
  }

  /// Supprime toutes les données et les photos.
  Future<void> effacerTout() async {
    await _db.transaction(_viderTables);
    await _supprimerPhotos();
  }

  Future<void> _viderTables() async {
    // Tables dépendantes d'abord (les suppressions en cascade feraient de
    // toute façon le reste).
    for (final table in _db.allTables.toList().reversed) {
      await _db.delete(table).go();
    }
  }

  Future<void> _supprimerPhotos() async {
    final dossier = Directory(p.join(_documents.path, _dossierPhotos));
    if (await dossier.exists()) await dossier.delete(recursive: true);
  }

  static String _normaliser(String chemin) => chemin.replaceAll(r'\', '/');

  static bool _cheminPhotoSur(String chemin) {
    final parties = chemin.split('/');
    return parties.length == 2 &&
        parties.first == _dossierPhotos &&
        RegExp(r'^[\w-]+\.[a-z0-9]{2,5}$').hasMatch(parties.last);
  }

  static bool _valeurSimple(Object? v) =>
      v == null || v is String || v is num || v is bool;
}
