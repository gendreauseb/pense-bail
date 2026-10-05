import '../entities/entities.dart';
import '../repositories/repositories.dart';
import 'verrou_biens.dart';

/// Écritures du carnet d'artisans et des interventions (Premium).
///
/// En version gratuite, le carnet et les interventions déjà saisis restent
/// consultables mais chaque écriture lève FonctionnaliteReservee (ou
/// BienVerrouille pour une intervention sur un bien en lecture seule).
class GestionArtisans {
  GestionArtisans({required this.artisans, required this.verrou});

  final ArtisanRepository artisans;
  final VerrouBiens verrou;

  Future<void> _verifier() =>
      verrou.verifierFonctionnalite(Fonctionnalite.artisans);

  Future<void> enregistrer(Artisan artisan) async {
    await _verifier();
    await artisans.enregistrer(artisan);
  }

  Future<void> supprimer(String artisanId) async {
    await _verifier();
    await artisans.supprimer(artisanId);
  }

  /// Le coût éventuel alimente le journal du bien (voir
  /// ArtisanRepository.enregistrerIntervention).
  Future<void> enregistrerIntervention(Intervention intervention) async {
    await _verifier();
    await verrou.verifierModifiable(intervention.bienId);
    await artisans.enregistrerIntervention(intervention);
  }

  Future<void> supprimerIntervention(Intervention intervention) async {
    await _verifier();
    await verrou.verifierModifiable(intervention.bienId);
    await artisans.supprimerIntervention(intervention.id);
  }
}
