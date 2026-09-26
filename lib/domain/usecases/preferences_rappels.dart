import 'dart:convert';

import '../../core/config/cles_reglages.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Lecture et modification des préférences de rappel.
class GestionPreferencesRappels {
  GestionPreferencesRappels({
    required this.transactions,
    required this.reglages,
    required this.echeances,
  });

  final Transactions transactions;
  final ReglagesRepository reglages;
  final EcheanceRepository echeances;

  Future<PreferencesRappels> lire() async =>
      _decoder(await reglages.lire(ClesReglages.preferencesRappels));

  Stream<PreferencesRappels> surveiller() =>
      reglages.surveiller(ClesReglages.preferencesRappels).map(_decoder);

  Future<void> enregistrer(PreferencesRappels preferences) => reglages.ecrire(
    ClesReglages.preferencesRappels,
    jsonEncode(preferences.versJson()),
  );

  /// Remplace les rappels de toutes les échéances à faire par [delais].
  /// Retourne le nombre d'échéances modifiées.
  Future<int> appliquerAuxEcheancesAFaire(List<int> delais) =>
      transactions.executer(() async {
        final aFaire = await echeances.aFaire();
        for (final e in aFaire) {
          await echeances.definirRappels(e.id, delais);
        }
        return aFaire.length;
      });

  static PreferencesRappels _decoder(String? valeur) {
    if (valeur == null) return const PreferencesRappels();
    try {
      final json = jsonDecode(valeur);
      return json is Map<String, Object?>
          ? PreferencesRappels.depuisJson(json)
          : const PreferencesRappels();
    } on FormatException {
      return const PreferencesRappels();
    }
  }
}
