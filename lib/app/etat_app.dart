import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/dates.dart';

/// Valeur lue en base au démarrage (voir main.dart).
final onboardingTermineAuDemarrageProvider = Provider<bool>(
  (ref) => throw UnimplementedError('À fournir au démarrage.'),
);

/// L'onboarding est-il terminé ? Pilote la redirection de la navigation.
final onboardingTermineProvider = NotifierProvider<OnboardingTermine, bool>(
  OnboardingTermine.new,
);

class OnboardingTermine extends Notifier<bool> {
  @override
  bool build() => ref.read(onboardingTermineAuDemarrageProvider);

  void marquerTermine() => state = true;

  /// Après « Tout effacer » ou la restauration d'une sauvegarde incomplète :
  /// retour à l'accueil de l'onboarding.
  void reinitialiser() => state = false;
}

/// Date du jour (sans heure). Recalculée au retour dans l'app (voir
/// AccueilPage) ; surchargée dans les tests pour des dates fixes.
final aujourdhuiProvider = NotifierProvider<Aujourdhui, DateTime>(
  Aujourdhui.new,
);

class Aujourdhui extends Notifier<DateTime> {
  @override
  DateTime build() => Dates.aujourdhui();

  void actualiser() {
    final jour = Dates.aujourdhui();
    if (jour != state) state = jour;
  }
}

/// Échéance à ouvrir suite au toucher d'une notification.
final echeanceAOuvrirProvider = NotifierProvider<EcheanceAOuvrir, String?>(
  EcheanceAOuvrir.new,
);

class EcheanceAOuvrir extends Notifier<String?> {
  @override
  String? build() => null;

  void ouvrir(String echeanceId) => state = echeanceId;
  void effacer() => state = null;
}
