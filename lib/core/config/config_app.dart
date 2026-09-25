// Réglages produit de l'application (PAS des règles légales : celles-ci sont
// dans regles_legales.dart).

abstract final class ConfigApp {
  /// Rappels par défaut d'une échéance, en jours avant la date.
  static const List<int> rappelsParDefautJours = [30, 7, 1];

  /// Rappels proposés dans le formulaire d'une échéance (0 = le jour même).
  static const List<int> rappelsProposesJours = [30, 15, 7, 3, 1, 0];

  /// Heure d'envoi des notifications de rappel (heure locale).
  static const int heureRappel = 9;

  /// iOS n'accepte que 64 notifications programmées : on programme les plus
  /// proches, et la liste est recalculée à chaque ouverture de l'app.
  static const int maxRappelsProgrammes = 60;

  /// Nombre d'échéances affichées sur l'accueil avant « Afficher tout ».
  static const int echeancesAccueil = 5;

  /// Nombre de biens proposé pendant l'onboarding.
  static const int nombreBiensMin = 1;
  static const int nombreBiensMax = 20;

  /// La date de début de bail saisie à l'onboarding ne peut pas dépasser
  /// aujourd'hui + ce nombre de mois.
  static const int debutBailMaxMoisDansLeFutur = 3;

  /// Statut des échéances selon les jours restants (UI.md §2, règle stricte) :
  /// urgent si dépassée ou ≤ 7 j ; bientôt de 8 à 30 j ; à venir de 31 à
  /// 90 j ; lointain au-delà.
  static const int seuilUrgentJours = 7;
  static const int seuilBientotJours = 30;
  static const int seuilAVenirJours = 90;

  /// Au-delà, la pastille affiche l'année plutôt qu'un nombre de mois.
  static const int pastilleAnneeAuDelaDeMois = 18;

  /// Adresse du fichier distant contenant la table des indices IRL.
  /// À définir avant la publication (voir assets/irl/LISEZMOI.md).
  static const String? urlIndicesIrl = null;
}
