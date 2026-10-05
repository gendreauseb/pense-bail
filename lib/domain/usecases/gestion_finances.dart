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
    required this.biens,
    required this.finances,
    required this.verrou,
  });

  final BienRepository biens;
  final FinanceRepository finances;
  final VerrouBiens verrou;

  Future<void> _verifier(String bienId) async {
    await verrou.verifierFonctionnalite(Fonctionnalite.rentabilite);
    await verrou.verifierModifiable(bienId);
  }

  /// Enregistre les chiffres d'investissement et les charges annuelles du
  /// bien (aucune échéance n'en dépend).
  Future<void> enregistrerInvestissement(Bien bien) async {
    await _verifier(bien.id);
    await biens.enregistrer(bien);
  }

  Future<void> enregistrerMouvement(MouvementFinancier mouvement) async {
    await _verifier(mouvement.bienId);
    await finances.enregistrerMouvement(mouvement);
  }

  Future<void> supprimerMouvement(MouvementFinancier mouvement) async {
    await _verifier(mouvement.bienId);
    await finances.supprimerMouvement(mouvement.id);
  }

  Future<void> definirEncaissement(EncaissementLoyer encaissement) async {
    await _verifier(encaissement.bienId);
    await finances.definirEncaissement(encaissement);
  }
}
