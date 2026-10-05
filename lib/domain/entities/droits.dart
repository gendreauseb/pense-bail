import '../../core/config/config_app.dart';

/// Fonctionnalités réservées à la version Premium.
enum Fonctionnalite {
  /// Plus d'un bien actif (modifiable).
  biensIllimites,

  /// Génération du courrier de révision de loyer (le calcul reste gratuit).
  courrierRevision,

  /// Onglet rentabilité, journal, cases « Loyer reçu », récapitulatif.
  rentabilite,

  /// Carnet d'artisans et interventions.
  artisans,
}

/// Ce que la version de l'application permet.
///
/// Les écrans demandent si une fonctionnalité est disponible
/// ([autorise]), jamais si l'utilisateur a payé : seule la source des
/// droits (SourceDroits) sait d'où vient le statut.
class Droits {
  const Droits({required this.estPremium, required this.maxBiensActifs});

  static const gratuit = Droits(
    estPremium: false,
    maxBiensActifs: ConfigApp.maxBiensGratuit,
  );

  static const premium = Droits(estPremium: true, maxBiensActifs: null);

  final bool estPremium;

  /// Nombre de biens modifiables ; `null` : illimité.
  final int? maxBiensActifs;

  bool autorise(Fonctionnalite fonctionnalite) => switch (fonctionnalite) {
    Fonctionnalite.biensIllimites => maxBiensActifs == null,
    Fonctionnalite.courrierRevision ||
    Fonctionnalite.rentabilite ||
    Fonctionnalite.artisans => estPremium,
  };

  @override
  bool operator ==(Object other) =>
      other is Droits &&
      other.estPremium == estPremium &&
      other.maxBiensActifs == maxBiensActifs;

  @override
  int get hashCode => Object.hash(estPremium, maxBiensActifs);

  @override
  String toString() => estPremium ? 'Droits.premium' : 'Droits.gratuit';
}
