/// Clés de la table des réglages (clé / valeur).
abstract final class ClesReglages {
  /// 'true' une fois l'onboarding terminé.
  static const onboardingTermine = 'onboarding.termine';

  /// Brouillon JSON de l'onboarding en cours (supprimé à la fin).
  static const brouillonOnboarding = 'onboarding.brouillon';

  /// 'true' une fois l'autorisation des notifications demandée.
  static const notificationsDemandees = 'notifications.demandees';
}
