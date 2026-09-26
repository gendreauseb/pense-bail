import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/config/cles_reglages.dart';
import '../../core/config/config_app.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'lecteur_indices.dart';

/// Échec de la mise à jour, avec un message affichable.
class MiseAJourIrlImpossible implements Exception {
  const MiseAJourIrlImpossible(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Table des indices IRL : table embarquée, mise à jour depuis l'INSEE,
/// saisie manuelle en secours. Aucune valeur n'est jamais calculée ou
/// extrapolée.
class ServiceIndicesIrl {
  ServiceIndicesIrl({
    required this._indices,
    required this._reglages,
    required this._lireTableEmbarquee,
    required this._client,
    DateTime Function()? horloge,
  }) : _horloge = horloge ?? DateTime.now;

  final IndiceIrlRepository _indices;
  final ReglagesRepository _reglages;
  final Future<String> Function() _lireTableEmbarquee;
  final http.Client _client;
  final DateTime Function() _horloge;

  Future<void>? _import;

  /// Importe la table embarquée si cette version ne l'a pas encore été.
  /// Les appels simultanés partagent le même import.
  Future<void> importerTableEmbarquee() => _import ??= _importer();

  Future<void> _importer() async {
    final table = LecteurIndices.depuisJson(await _lireTableEmbarquee());
    final dejaImportee = await _reglages.lire(ClesReglages.irlTableEmbarquee);
    if (dejaImportee == table.version) return;
    await _indices.enregistrerTout(table.indices);
    await _reglages.ecrire(ClesReglages.irlTableEmbarquee, table.version);
  }

  Future<DateTime?> derniereMiseAJour() async {
    final valeur = await _reglages.lire(ClesReglages.irlDerniereMiseAJour);
    return valeur == null ? null : DateTime.tryParse(valeur);
  }

  /// Vrai si la dernière vérification auprès de l'INSEE date de plus de
  /// [ConfigApp.intervalleMiseAJourIrl].
  Future<bool> miseAJourConseillee() async {
    final derniere = await derniereMiseAJour();
    return derniere == null ||
        _horloge().difference(derniere) > ConfigApp.intervalleMiseAJourIrl;
  }

  /// Télécharge la série IRL de l'INSEE. Retourne le nombre d'indices
  /// nouveaux (absents de la table ou saisis à la main).
  Future<int> mettreAJour() async {
    await importerTableEmbarquee();
    final http.Response reponse;
    try {
      reponse = await _client
          .get(Uri.parse(ConfigApp.urlIndicesIrl))
          .timeout(ConfigApp.delaiReseau);
    } on TimeoutException {
      throw const MiseAJourIrlImpossible(
        'Le site de l\'INSEE ne répond pas. Réessayez plus tard.',
      );
    } on SocketException {
      throw const MiseAJourIrlImpossible(
        'Pas de connexion internet. Réessayez une fois connecté.',
      );
    } on http.ClientException {
      throw const MiseAJourIrlImpossible(
        'Pas de connexion internet. Réessayez une fois connecté.',
      );
    }
    if (reponse.statusCode != HttpStatus.ok) {
      throw MiseAJourIrlImpossible(
        'Le site de l\'INSEE est indisponible (erreur '
        '${reponse.statusCode}). Réessayez plus tard.',
      );
    }

    final List<IndiceIrl> recus;
    try {
      recus = LecteurIndices.depuisSdmxInsee(reponse.body);
    } on FormatIndicesInvalide {
      throw const MiseAJourIrlImpossible(
        'Les indices reçus de l\'INSEE sont illisibles. Vous pouvez saisir '
        'l\'indice vous-même.',
      );
    }

    final avant = {
      for (final i in await _indices.tous())
        if (i.source == SourceIndice.insee) (i.annee, i.trimestre),
    };
    await _indices.enregistrerTout(recus);
    await _reglages.ecrire(
      ClesReglages.irlDerniereMiseAJour,
      _horloge().toIso8601String(),
    );
    return recus.where((i) => !avant.contains((i.annee, i.trimestre))).length;
  }

  /// Saisie manuelle en secours, recopiée depuis insee.fr par l'utilisateur.
  /// Une valeur INSEE déjà connue n'est jamais remplacée.
  Future<void> saisir({
    required int annee,
    required int trimestre,
    required double valeur,
  }) => _indices.enregistrerTout([
    IndiceIrl(
      annee: annee,
      trimestre: trimestre,
      valeur: valeur,
      source: SourceIndice.manuel,
    ),
  ]);
}
