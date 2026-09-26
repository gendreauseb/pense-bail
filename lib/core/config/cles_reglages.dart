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
}
