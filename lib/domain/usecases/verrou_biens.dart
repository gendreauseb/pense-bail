import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/acces_biens.dart';

/// Vérifie, avant une écriture, que les droits la permettent : bien actif
/// (modifiable), fonctionnalité Premium disponible. Les écrans masquent déjà
/// les actions interdites ; ce contrôle garantit la règle quel que soit le
/// chemin. La limite d'ajout est vérifiée par GestionBiens.creer.
class VerrouBiens {
  VerrouBiens({required this.biens, required this.droits});

  final BienRepository biens;

  /// Droits actuels.
  final Future<Droits> Function() droits;

  /// Lève [BienHorsLocation] si le bien est vendu ou n'est plus loué,
  /// [BienVerrouille] s'il est en lecture seule dans la version gratuite.
  /// Une échéance commune à tous les biens ([bienId] nul) est toujours
  /// modifiable.
  Future<void> verifierModifiable(String? bienId) async {
    if (bienId == null) return;
    final tous = await biens.tous();
    final bien = tous.where((b) => b.id == bienId).firstOrNull;
    if (bien != null && !bien.enLocation) {
      throw BienHorsLocation(vendu: bien.vendu);
    }
    final actifs = AccesBiens.actifs(tous, await droits());
    if (!actifs.contains(bienId)) throw const BienVerrouille();
  }

  /// La fonctionnalité est-elle disponible ?
  Future<bool> autorise(Fonctionnalite fonctionnalite) async =>
      (await droits()).autorise(fonctionnalite);

  /// Lève [FonctionnaliteReservee] si la fonctionnalité n'est pas
  /// disponible.
  Future<void> verifierFonctionnalite(Fonctionnalite fonctionnalite) async {
    if (!await autorise(fonctionnalite)) {
      throw FonctionnaliteReservee(fonctionnalite);
    }
  }
}
