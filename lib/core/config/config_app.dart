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

  /// Statut des échéances selon les jours restants (design-system.md §2, règle
  /// stricte) : urgent si dépassée ou ≤ 7 j ; bientôt de 8 à 30 j ; à venir de
  /// 31 à 90 j ; lointain au-delà.
  static const int seuilUrgentJours = 7;
  static const int seuilBientotJours = 30;
  static const int seuilAVenirJours = 90;

  /// Au-delà, la pastille affiche l'année plutôt qu'un nombre de mois.
  static const int pastilleAnneeAuDelaDeMois = 18;

  /// Série IRL publiée par l'INSEE (format SDMX, accès libre, sans compte).
  /// Seul appel réseau de l'application : rien n'est envoyé.
  static const String urlIndicesIrl =
      'https://bdm.insee.fr/series/sdmx/data/SERIES_BDM/001515333';

  /// Délai maximal d'attente de l'INSEE.
  static const Duration delaiReseau = Duration(seconds: 20);

  /// Vérification automatique de nouveaux indices à l'ouverture de l'outil
  /// de révision, au plus une fois par période.
  static const Duration intervalleMiseAJourIrl = Duration(days: 7);

  /// Éditeur de l'application, affiché dans les mentions légales.
  /// À renseigner avant publication (nom ou raison sociale, et adresse).
  static const String? editeur = null;

  /// Moyen de contact de l'éditeur (email), affiché dans les mentions
  /// légales. À renseigner avant publication.
  static const String? contactEditeur = null;
}
