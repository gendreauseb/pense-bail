// Réglages produit de l'application (PAS des règles légales : celles-ci sont
// dans regles_legales.dart).

abstract final class ConfigApp {
  /// Rappels par défaut d'une échéance, en jours avant la date.
  static const List<int> rappelsParDefautJours = [30, 7, 1];

  /// Nombre de biens proposé pendant l'onboarding.
  static const int nombreBiensMin = 1;
  static const int nombreBiensMax = 20;

  /// La date de début de bail saisie à l'onboarding ne peut pas dépasser
  /// aujourd'hui + ce nombre de mois.
  static const int debutBailMaxMoisDansLeFutur = 3;

  /// Code couleur des échéances (en jours restants).
  /// < seuilUrgent (ou dépassée) : rouge ; < seuilProche : orange ; sinon vert.
  static const int seuilUrgentJours = 7;
  static const int seuilProcheJours = 30;

  /// Horizon d'affichage des échéances sur le tableau de bord.
  static const int horizonTableauDeBordMois = 18;

  /// Adresse du fichier distant contenant la table des indices IRL.
  /// À définir avant la publication (voir assets/irl/LISEZMOI.md).
  static const String? urlIndicesIrl = null;
}
