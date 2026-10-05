import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import 'verrou_biens.dart';

/// Actions sur une échéance : marquer comme faite, reporter, enregistrer.
///
/// Sur un bien en lecture seule (version gratuite), une échéance peut
/// toujours être marquée faite ou reportée, sinon ses rappels continueraient
/// sans fin ; la créer, la modifier ou la supprimer est refusé.
class GestionEcheances {
  GestionEcheances({
    required this.transactions,
    required this.echeances,
    required this.verrou,
  });

  final Transactions transactions;
  final EcheanceRepository echeances;
  final VerrouBiens verrou;

  /// Marque l'échéance comme faite. Si elle est récurrente, crée l'occurrence
  /// suivante (mêmes rappels) et la retourne.
  ///
  /// L'occurrence suivante est calculée depuis la date prévue à l'origine :
  /// une révision prévue le 01/09 et reportée au 15/09 revient le 01/09.
  ///
  /// [aujourdhui] (date du jour de l'application) donne « Faite le » ; à
  /// défaut, le jour de [maintenant].
  Future<Echeance?> marquerFaite(
    Echeance echeance, {
    DateTime? aujourdhui,
    DateTime? maintenant,
  }) {
    final t = maintenant ?? DateTime.now();
    final intervalle = echeance.intervalleMois;
    final suivante = intervalle == null
        ? null
        : Echeance(
            id: Identifiants.nouveau(),
            bienId: echeance.bienId,
            type: echeance.type,
            titre: echeance.titre,
            date: Dates.ajouterMois(
              echeance.dateInitiale ?? echeance.date,
              intervalle,
            ),
            statut: StatutEcheance.aFaire,
            notes: echeance.notes,
            intervalleMois: intervalle,
            typeDiagnostic: echeance.typeDiagnostic,
            automatique: echeance.automatique,
            creeLe: t,
            modifieLe: t,
          );

    return transactions.executer(() async {
      final rappels = await echeances.rappels(echeance.id);
      await echeances.enregistrer(
        echeance.copyWith(
          statut: StatutEcheance.faite,
          faiteLe: Dates.jour(aujourdhui ?? t),
          modifieLe: t,
        ),
      );
      if (suivante != null) {
        await echeances.enregistrer(suivante);
        await echeances.definirRappels(suivante.id, [
          for (final r in rappels) r.joursAvant,
        ]);
      }
      return suivante;
    });
  }

  /// Annule « Marquer comme faite » : restaure l'échéance d'origine et
  /// supprime l'occurrence suivante créée.
  Future<void> annulerFaite({
    required Echeance originale,
    required Echeance? suivante,
  }) => transactions.executer(() async {
    await echeances.enregistrer(originale);
    if (suivante != null) await echeances.supprimer(suivante.id);
  });

  /// Reporte l'échéance. La date prévue à l'origine est conservée.
  Future<Echeance> reporter(Echeance echeance, DateTime nouvelleDate) async {
    final reportee = echeance.copyWith(
      date: Dates.jour(nouvelleDate),
      dateInitiale: echeance.dateInitiale ?? echeance.date,
    );
    await echeances.enregistrer(reportee);
    return reportee;
  }

  /// Crée ou modifie une échéance et ses rappels (jours avant la date).
  ///
  /// Lève [BienVerrouille] si l'échéance est (ou était) rattachée à un bien
  /// en lecture seule.
  Future<void> enregistrer(Echeance echeance, List<int> rappelsJours) async {
    final existante = await echeances.parId(echeance.id);
    await verrou.verifierModifiable(existante?.bienId);
    await verrou.verifierModifiable(echeance.bienId);
    return transactions.executer(() async {
      await echeances.enregistrer(echeance);
      await echeances.definirRappels(echeance.id, rappelsJours);
    });
  }

  /// Lève [BienVerrouille] si l'échéance est rattachée à un bien en lecture
  /// seule.
  Future<void> supprimer(String id) async {
    await verrou.verifierModifiable((await echeances.parId(id))?.bienId);
    await echeances.supprimer(id);
  }
}
