/// Clés de la table des réglages (clé / valeur).
abstract final class ClesReglages {
  /// 'true' une fois l'onboarding terminé.
  static const onboardingTermine = 'onboarding.termine';

  /// Brouillon JSON de l'onboarding en cours (supprimé à la fin).
  static const brouillonOnboarding = 'onboarding.brouillon';

  /// 'true' une fois l'autorisation des notifications demandée.
  static const notificationsDemandees = 'notifications.demandees';

  /// Version (« miseAJour ») de la table IRL embarquée déjà importée.
  static const irlTableEmbarquee = 'irl.table_embarquee';

  /// Date (ISO) de la dernière mise à jour réussie depuis l'INSEE.
  static const irlDerniereMiseAJour = 'irl.derniere_mise_a_jour';

  /// Préférences de rappel (JSON, voir PreferencesRappels).
  static const preferencesRappels = 'rappels.preferences';

  /// Mode simulé de la version bêta : 'premium' ou 'gratuit' (voir
  /// DroitsBeta). Absent : ConfigApp.betaPremiumParDefaut.
  static const modePremiumBeta = 'beta.mode_premium';

  /// Réglages propres au téléphone, jamais exportés dans une sauvegarde,
  /// ignorés dans un fichier restauré et conservés par « Tout effacer » :
  /// un statut d'abonnement ne voyage pas avec les données.
  static const propresAuTelephone = {modePremiumBeta, finAbonnementAAnnoncer};

  /// Présent quand la fin de l'abonnement Premium doit être annoncée sur
  /// l'accueil ; supprimé une fois le message affiché (une seule fois).
  static const finAbonnementAAnnoncer = 'premium.fin_a_annoncer';
}
