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

  /// Lève [BienVerrouille] si le bien est en lecture seule. Une échéance
  /// commune à tous les biens ([bienId] nul) est toujours modifiable.
  Future<void> verifierModifiable(String? bienId) async {
    if (bienId == null) return;
    final actifs = AccesBiens.actifs(await biens.tous(), await droits());
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
