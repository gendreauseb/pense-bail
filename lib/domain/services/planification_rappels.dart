import '../../core/config/config_app.dart';
import '../../core/format/formats.dart';
import '../../core/utils/dates.dart';
import '../entities/echeance.dart';

/// Notification à programmer sur le téléphone.
class RappelAProgrammer {
  const RappelAProgrammer({
    required this.id,
    required this.echeanceId,
    required this.quand,
    required this.titre,
    required this.corps,
  });

  /// Identifiant du rappel, réutilisé comme identifiant de notification.
  final int id;
  final String echeanceId;

  /// Date et heure locales d'envoi.
  final DateTime quand;
  final String titre;
  final String corps;
}

/// Calcule les notifications à programmer (fonction pure, testable).
abstract final class PlanificationRappels {
  /// [nomsBiens] : nom de chaque bien par identifiant.
  static List<RappelAProgrammer> planifier({
    required List<Echeance> echeances,
    required List<Rappel> rappels,
    required Map<String, String> nomsBiens,
    required DateTime maintenant,
    int maximum = ConfigApp.maxRappelsProgrammes,
  }) {
    final parId = {for (final e in echeances) e.id: e};
    final resultat = <RappelAProgrammer>[];

    for (final rappel in rappels) {
      final echeance = parId[rappel.echeanceId];
      if (echeance == null || echeance.estFaite) continue;

      final jour = Dates.ajouterJours(echeance.date, -rappel.joursAvant);
      final quand = DateTime(
        jour.year,
        jour.month,
        jour.day,
        ConfigApp.heureRappel,
      );
      if (!quand.isAfter(maintenant)) continue;

      final bienId = echeance.bienId;
      final lieu = bienId == null
          ? 'Tous vos biens'
          : (nomsBiens[bienId] ?? 'Votre bien');
      resultat.add(
        RappelAProgrammer(
          id: rappel.id,
          echeanceId: echeance.id,
          quand: quand,
          titre: '${_quand(rappel.joursAvant)} : ${echeance.titre}',
          corps: '$lieu, le ${Formats.date(echeance.date)}',
        ),
      );
    }

    resultat.sort((a, b) => a.quand.compareTo(b.quand));
    return resultat.take(maximum).toList();
  }

  static String _quand(int joursAvant) => switch (joursAvant) {
    0 => 'Aujourd\'hui',
    1 => 'Demain',
    _ => 'Dans $joursAvant jours',
  };
}
