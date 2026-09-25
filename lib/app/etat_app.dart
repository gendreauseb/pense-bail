import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}
