import '../entities/entities.dart';

/// Biens actifs (modifiables) selon les droits.
///
/// En version gratuite, le bien actif est toujours le plus ancien : date de
/// création, puis ordre, puis identifiant (les biens créés à l'onboarding
/// ont la même date de création). Jamais l'ordre d'affichage seul, qui est
/// modifiable. Les autres biens restent consultables, en lecture seule ;
/// aucune donnée n'est supprimée ni modifiée par un changement de droits.
abstract final class AccesBiens {
  /// Identifiants des biens actifs.
  static Set<String> actifs(List<Bien> biens, Droits droits) {
    final max = droits.maxBiensActifs;
    if (max == null) return {for (final b in biens) b.id};
    final tries = [...biens]..sort(_parAnciennete);
    return {for (final b in tries.take(max)) b.id};
  }

  /// Un nouveau bien peut-il être ajouté ?
  static bool peutAjouter(List<Bien> biens, Droits droits) {
    final max = droits.maxBiensActifs;
    return max == null || biens.length < max;
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
