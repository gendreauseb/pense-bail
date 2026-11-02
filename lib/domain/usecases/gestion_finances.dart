import '../entities/entities.dart';
import '../repositories/repositories.dart';
import 'verrou_biens.dart';

/// Écritures de la rentabilité (Premium) : chiffres d'investissement,
/// journal des mouvements, cases « Loyer reçu ».
///
/// En version gratuite, ce qui est déjà saisi reste consultable mais
/// chaque écriture lève FonctionnaliteReservee (ou BienVerrouille pour un
/// bien en lecture seule).
class GestionFinances {
  GestionFinances({
    required this.transactions,
    required this.biens,
    required this.finances,
    required this.verrou,
  });

  final Transactions transactions;
  final BienRepository biens;
  final FinanceRepository finances;
  final VerrouBiens verrou;

  /// Contrôle des droits puis écriture, dans une même transaction.
  Future<void> _ecrire(String bienId, Future<void> Function() ecriture) =>
      transactions.executer(() async {
        await verrou.verifierFonctionnalite(Fonctionnalite.rentabilite);
        await verrou.verifierModifiable(bienId);
        await ecriture();
      });

  /// Enregistre les chiffres d'investissement et les charges annuelles du
  /// bien (aucune échéance n'en dépend).
  Future<void> enregistrerInvestissement(Bien bien) =>
      _ecrire(bien.id, () => biens.enregistrer(bien));

  Future<void> enregistrerMouvement(MouvementFinancier mouvement) =>
      _ecrire(mouvement.bienId, () => finances.enregistrerMouvement(mouvement));

  Future<void> supprimerMouvement(MouvementFinancier mouvement) => _ecrire(
    mouvement.bienId,
    () => finances.supprimerMouvement(mouvement.id),
  );

  Future<void> definirEncaissement(EncaissementLoyer encaissement) => _ecrire(
    encaissement.bienId,
    () => finances.definirEncaissement(encaissement),
  );
}
