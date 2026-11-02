import '../entities/entities.dart';

/// Biens actifs (modifiables) selon les droits.
///
/// En version gratuite, le bien actif est toujours le plus ancien : date de
/// création, puis ordre, puis identifiant (les biens créés à l'onboarding
/// ont la même date de création). Jamais l'ordre d'affichage seul, qui est
/// modifiable. Les autres biens restent consultables, en lecture seule ;
/// aucune donnée n'est supprimée ni modifiée par un changement de droits.
///
/// Un bien vendu ou retiré de la location n'est jamais actif, quels que
/// soient les droits, et ne compte pas dans la limite.
abstract final class AccesBiens {
  /// Identifiants des biens actifs.
  static Set<String> actifs(List<Bien> biens, Droits droits) {
    final enLocation = [
      for (final b in biens)
        if (b.enLocation) b,
    ];
    final max = droits.maxBiensActifs;
    if (max == null) return {for (final b in enLocation) b.id};
    final tries = enLocation..sort(_parAnciennete);
    return {for (final b in tries.take(max)) b.id};
  }

  /// Biens loués au-delà de la limite (en lecture seule du fait des droits) :
  /// leurs échéances ne sont pas notifiées. Les échéances restantes d'un
  /// bien vendu ou retiré, et celles communes à tous les biens, le sont
  /// toujours.
  static Set<String> sansRappel(List<Bien> biens, Droits droits) {
    final actifs = AccesBiens.actifs(biens, droits);
    return {
      for (final b in biens)
        if (b.enLocation && !actifs.contains(b.id)) b.id,
    };
  }

  /// Un nouveau bien peut-il être ajouté ?
  static bool peutAjouter(List<Bien> biens, Droits droits) {
    final max = droits.maxBiensActifs;
    return max == null || biens.where((b) => b.enLocation).length < max;
  }

  /// Biens actifs aujourd'hui qui passeraient en lecture seule si [bien]
  /// était remis en location (version gratuite : il est plus ancien).
  static List<Bien> perdraientAcces(
    List<Bien> biens,
    Bien bien,
    Droits droits,
  ) {
    final avant = actifs(biens, droits);
    final remis = bien.copyWith(venduLe: null, retireLe: null);
    final apres = actifs([
      for (final b in biens) b.id == bien.id ? remis : b,
    ], droits);
    return [
      for (final b in biens)
        if (avant.contains(b.id) && !apres.contains(b.id)) b,
    ];
  }

  static int _parAnciennete(Bien a, Bien b) {
    final date = a.creeLe.compareTo(b.creeLe);
    if (date != 0) return date;
    final ordre = a.ordre.compareTo(b.ordre);
    if (ordre != 0) return ordre;
    return a.id.compareTo(b.id);
  }
}

/// Action refusée par les droits de la version gratuite. Le [message] est
/// prêt à être affiché.
sealed class AccesRefuse implements Exception {
  const AccesRefuse();
  String get message;

  @override
  String toString() => message;
}

/// Ajout d'un bien refusé : la limite de la version gratuite est atteinte.
class LimiteBiensAtteinte extends AccesRefuse {
  const LimiteBiensAtteinte(this.maxBiensActifs);

  final int maxBiensActifs;

  @override
  String get message {
    final limite = maxBiensActifs == 1
        ? 'un seul bien'
        : '$maxBiensActifs biens';
    return 'La version gratuite permet de gérer $limite. '
        "Pense-Bail Premium permet d'en ajouter d'autres.";
  }
}

/// Modification refusée : le bien est en lecture seule (version gratuite).
class BienVerrouille extends AccesRefuse {
  const BienVerrouille();

  @override
  String get message =>
      'Ce bien est en lecture seule dans la version gratuite. '
      'Pense-Bail Premium permet de le modifier.';
}

/// Modification refusée : le bien est vendu ou n'est plus loué (dans toutes
/// les versions).
class BienHorsLocation extends AccesRefuse {
  const BienHorsLocation({required this.vendu});

  final bool vendu;

  @override
  String get message => vendu
      ? 'Ce bien est vendu : il reste consultable mais ne se modifie plus. '
            'Annulez la vente pour le modifier.'
      : "Ce bien n'est plus en location : il reste consultable mais ne se "
            'modifie plus. Remettez-le en location pour le modifier.';
}

/// Action refusée : la fonctionnalité est réservée à Pense-Bail Premium.
class FonctionnaliteReservee extends AccesRefuse {
  const FonctionnaliteReservee(this.fonctionnalite);

  final Fonctionnalite fonctionnalite;

  @override
  String get message => switch (fonctionnalite) {
    Fonctionnalite.biensIllimites =>
      "Pense-Bail Premium permet d'ajouter d'autres biens.",
    Fonctionnalite.courrierRevision =>
      'Le courrier de révision est inclus dans Pense-Bail Premium.',
    Fonctionnalite.rentabilite =>
      'Le suivi de la rentabilité est inclus dans Pense-Bail Premium. '
          'Ce qui est déjà saisi reste consultable.',
    Fonctionnalite.artisans =>
      "Le carnet d'artisans est inclus dans Pense-Bail Premium. "
          'Ce qui est déjà saisi reste consultable.',
  };
}
