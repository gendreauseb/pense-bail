import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/calculateur_revision.dart';
import 'gestion_echeances.dart';

/// Confirmation d'une révision de loyer.
class ReviserLoyer {
  ReviserLoyer({
    required this.transactions,
    required this.biens,
    required this.baux,
    required this.revisions,
    required this.echeances,
    required this.gestionEcheances,
  });

  final Transactions transactions;
  final BienRepository biens;
  final BailRepository baux;
  final RevisionRepository revisions;
  final EcheanceRepository echeances;
  final GestionEcheances gestionEcheances;

  /// Met à jour le loyer du bien et l'IRL de référence du bail (le nouvel
  /// indice sert d'ancien indice l'an prochain), enregistre la révision dans
  /// l'historique et passe l'échéance de révision à l'année suivante.
  Future<RevisionLoyer> confirmer({
    required Bien bien,
    required Bail bail,
    required ResultatRevision resultat,
    DateTime? maintenant,
  }) {
    final t = maintenant ?? DateTime.now();
    final cycle = resultat.cycle;
    final revision = RevisionLoyer(
      id: Identifiants.nouveau(),
      bienId: bien.id,
      bailId: bail.id,
      datePrevue: cycle.datePrevue,
      dateEffet: cycle.dateEffet,
      ancienLoyerCentimes: resultat.ancienLoyerCentimes,
      nouveauLoyerCentimes: resultat.nouveauLoyerCentimes,
      ancienIrlTrimestre: resultat.ancien.trimestre,
      ancienIrlAnnee: resultat.ancien.annee,
      ancienIrlValeur: resultat.ancien.valeur,
      nouvelIrlTrimestre: resultat.nouveau.trimestre,
      nouvelIrlAnnee: resultat.nouveau.annee,
      nouvelIrlValeur: resultat.nouveau.valeur,
      creeLe: t,
    );

    return transactions.executer(() async {
      await revisions.enregistrer(revision);
      await biens.enregistrer(
        bien.copyWith(
          loyerHcCentimes: resultat.nouveauLoyerCentimes,
          modifieLe: t,
        ),
      );
      await baux.enregistrer(
        bail.copyWith(
          irlTrimestre: resultat.nouveau.trimestre,
          irlAnnee: resultat.nouveau.annee,
          irlValeur: resultat.nouveau.valeur,
          modifieLe: t,
        ),
      );

      // L'échéance de cette année (et d'éventuelles années oubliées, dont la
      // révision est perdue) est marquée comme faite ; la suivante est créée
      // à la même date l'an prochain. Une révision en retard laisse intacte
      // l'échéance déjà passée à l'année suivante.
      var echeance = (await echeances.aFaire())
          .where(
            (e) => e.bienId == bien.id && e.type == TypeEcheance.revisionLoyer,
          )
          .firstOrNull;
      while (echeance != null &&
          !Dates.jour(
            echeance.dateInitiale ?? echeance.date,
          ).isAfter(cycle.datePrevue)) {
        echeance = await gestionEcheances.marquerFaite(echeance, maintenant: t);
      }
      return revision;
    });
  }
}
