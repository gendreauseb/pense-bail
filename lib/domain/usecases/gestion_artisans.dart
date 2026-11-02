import '../entities/entities.dart';
import '../repositories/repositories.dart';
import 'verrou_biens.dart';

/// Écritures du carnet d'artisans et des interventions (Premium).
///
/// En version gratuite, le carnet et les interventions déjà saisis restent
/// consultables mais chaque écriture lève FonctionnaliteReservee (ou
/// BienVerrouille pour une intervention sur un bien en lecture seule).
class GestionArtisans {
  GestionArtisans({
    required this.transactions,
    required this.artisans,
    required this.verrou,
  });

  final Transactions transactions;
  final ArtisanRepository artisans;
  final VerrouBiens verrou;

  /// Contrôle des droits (et du bien concerné, s'il y en a un) puis
  /// écriture, dans une même transaction.
  Future<void> _ecrire(Future<void> Function() ecriture, {String? bienId}) =>
      transactions.executer(() async {
        await verrou.verifierFonctionnalite(Fonctionnalite.artisans);
        await verrou.verifierModifiable(bienId);
        await ecriture();
      });

  Future<void> enregistrer(Artisan artisan) =>
      _ecrire(() => artisans.enregistrer(artisan));

  Future<void> supprimer(String artisanId) =>
      _ecrire(() => artisans.supprimer(artisanId));

  /// Le coût éventuel alimente le journal du bien (voir
  /// ArtisanRepository.enregistrerIntervention).
  Future<void> enregistrerIntervention(Intervention intervention) => _ecrire(
    () => artisans.enregistrerIntervention(intervention),
    bienId: intervention.bienId,
  );

  Future<void> supprimerIntervention(Intervention intervention) => _ecrire(
    () => artisans.supprimerIntervention(intervention.id),
    bienId: intervention.bienId,
  );
}
