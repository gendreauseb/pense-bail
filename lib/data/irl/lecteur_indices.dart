import 'dart:convert';

import '../../core/config/regles_legales.dart';
import '../../domain/entities/entities.dart';

/// Format invalide ou série inattendue.
class FormatIndicesInvalide implements Exception {
  const FormatIndicesInvalide(this.raison);
  final String raison;

  @override
  String toString() => 'FormatIndicesInvalide: $raison';
}

/// Lecture des tables d'indices IRL. Toute valeur illisible fait échouer la
/// lecture entière : mieux vaut ne rien importer qu'une table douteuse.
abstract final class LecteurIndices {
  /// Table embarquée (assets/irl/irl.json).
  static ({String version, List<IndiceIrl> indices}) depuisJson(
    String contenu,
  ) {
    final Object? racine;
    try {
      racine = jsonDecode(contenu);
    } on FormatException catch (e) {
      throw FormatIndicesInvalide('JSON illisible : ${e.message}');
    }
    if (racine is! Map<String, Object?>) {
      throw const FormatIndicesInvalide('Objet JSON attendu.');
    }
    final version = racine['miseAJour'];
    final liste = racine['indices'];
    if (version is! String || liste is! List<Object?>) {
      throw const FormatIndicesInvalide('Champs « miseAJour » ou « indices ».');
    }
    return (
      version: version,
      indices: [
        for (final e in liste)
          switch (e) {
            {
              'annee': final int annee,
              'trimestre': final int trimestre,
              'valeur': final num valeur,
            } =>
              _indice(
                annee: annee,
                trimestre: trimestre,
                valeur: valeur.toDouble(),
                publication: e['datePublicationJo'],
              ),
            _ => throw FormatIndicesInvalide('Indice illisible : $e'),
          },
      ],
    );
  }

  static final _serie = RegExp(r'<Series\s([^>]*)>');
  static final _observation = RegExp(r'<Obs\s([^>]*?)/?>');
  static final _periode = RegExp(r'^(\d{4})-Q([1-4])$');

  /// Réponse SDMX de la banque de données macro-économiques de l'INSEE.
  static List<IndiceIrl> depuisSdmxInsee(String xml) {
    final serie = _serie.firstMatch(xml);
    if (serie == null) {
      throw const FormatIndicesInvalide('Série absente.');
    }
    final idbank = _attribut(serie.group(1)!, 'IDBANK');
    if (idbank != ReglesLegales.idbankInseeIrl) {
      throw FormatIndicesInvalide('Série inattendue : $idbank');
    }
    final indices = <IndiceIrl>[];
    for (final obs in _observation.allMatches(xml)) {
      final attributs = obs.group(1)!;
      final periode = _periode.firstMatch(
        _attribut(attributs, 'TIME_PERIOD') ?? '',
      );
      final valeur = double.tryParse(_attribut(attributs, 'OBS_VALUE') ?? '');
      if (periode == null || valeur == null) {
        throw FormatIndicesInvalide('Observation illisible : $attributs');
      }
      indices.add(
        _indice(
          annee: int.parse(periode.group(1)!),
          trimestre: int.parse(periode.group(2)!),
          valeur: valeur,
          publication: _attribut(attributs, 'DATE_JO'),
        ),
      );
    }
    if (indices.isEmpty) {
      throw const FormatIndicesInvalide('Aucun indice.');
    }
    return indices;
  }

  static String? _attribut(String attributs, String nom) =>
      RegExp('(?:^|\\s)$nom="([^"]*)"').firstMatch(attributs)?.group(1);

  static IndiceIrl _indice({
    required int annee,
    required int trimestre,
    required double valeur,
    required Object? publication,
  }) {
    if (trimestre < 1 || trimestre > 4 || valeur <= 0) {
      throw FormatIndicesInvalide('Valeur incohérente : T$trimestre $annee');
    }
    return IndiceIrl(
      annee: annee,
      trimestre: trimestre,
      valeur: valeur,
      datePublication: publication is String
          ? DateTime.tryParse(publication)
          : null,
      source: SourceIndice.insee,
    );
  }
}
