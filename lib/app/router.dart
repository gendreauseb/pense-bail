import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/accueil/accueil_page.dart';
import '../features/artisans/artisans_page.dart';
import '../features/biens/biens_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/reglages/reglages_page.dart';
import 'etat_app.dart';
import 'shell.dart';

abstract final class Routes {
  static const onboarding = '/bienvenue';
  static const accueil = '/accueil';
  static const biens = '/biens';
  static const artisans = '/artisans';
  static const reglages = '/reglages';
  // Étape 4 : fiche bien ; étape 5 : révision.
}

final routeurProvider = Provider<GoRouter>((ref) {
  // Tant que l'onboarding n'est pas terminé, toute navigation y ramène.
  final termine = ValueNotifier(ref.read(onboardingTermineProvider));
  ref.listen(onboardingTermineProvider, (_, valeur) => termine.value = valeur);

  final routeur = GoRouter(
    initialLocation: termine.value ? Routes.accueil : Routes.onboarding,
    refreshListenable: termine,
    redirect: (context, state) {
      final surOnboarding = state.matchedLocation == Routes.onboarding;
      if (!termine.value && !surOnboarding) return Routes.onboarding;
      if (termine.value && surOnboarding) return Routes.accueil;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellApp(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.accueil,
                builder: (context, state) => const AccueilPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.biens,
                builder: (context, state) => const BiensPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.artisans,
                builder: (context, state) => const ArtisansPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reglages,
                builder: (context, state) => const ReglagesPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page introuvable'))),
  );

  ref.onDispose(() {
    routeur.dispose();
    termine.dispose();
  });
  return routeur;
});
