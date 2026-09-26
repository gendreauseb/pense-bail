import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/accueil/accueil_page.dart';
import '../features/artisans/artisans_page.dart';
import '../features/artisans/edition_artisan_page.dart';
import '../features/artisans/edition_intervention_page.dart';
import '../features/biens/biens_page.dart';
import '../features/biens/edition_bail_page.dart';
import '../features/biens/edition_bien_page.dart';
import '../features/biens/fiche_bien_page.dart';
import '../features/biens/formulaires/edition_investissement_page.dart';
import '../features/biens/formulaires/edition_locataire_page.dart';
import '../features/biens/formulaires/edition_mouvement_page.dart';
import '../features/echeances/edition_echeance_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/reglages/edition_profil_page.dart';
import '../features/reglages/mentions_legales_page.dart';
import '../features/reglages/rappels_page.dart';
import '../features/reglages/reglages_page.dart';
import '../features/biens/rentabilite/recapitulatif_page.dart';
import '../features/revision/courrier/courrier_revision_page.dart';
import '../features/revision/revision_page.dart';
import 'etat_app.dart';
import 'routes.dart';
import 'shell.dart';

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
      // Écrans plein écran, au-dessus de la barre de navigation.
      GoRoute(
        path: Routes.nouvelleEcheance,
        builder: (context, state) => EditionEcheancePage(
          preremplissage: Preremplissage.depuisParametres(
            state.uri.queryParameters,
          ),
        ),
      ),
      GoRoute(
        path: Routes.nouveauBien,
        builder: (context, state) => const EditionBienPage(),
      ),
      GoRoute(
        path: Routes.artisan,
        builder: (context, state) =>
            EditionArtisanPage(artisanId: state.uri.queryParameters['artisan']),
      ),
      GoRoute(
        path: Routes.profil,
        builder: (context, state) => const EditionProfilPage(),
      ),
      GoRoute(
        path: Routes.reglagesRappels,
        builder: (context, state) => const RappelsPage(),
      ),
      GoRoute(
        path: Routes.mentionsLegales,
        builder: (context, state) => const MentionsLegalesPage(),
      ),
      GoRoute(
        path: Routes.modifierEcheance(':id'),
        builder: (context, state) =>
            EditionEcheancePage(echeanceId: state.pathParameters['id']),
      ),
      GoRoute(
        path: Routes.revision(':bienId'),
        builder: (context, state) =>
            RevisionPage(bienId: state.pathParameters['bienId']!),
      ),
      GoRoute(
        path: Routes.courrierRevision(':id'),
        builder: (context, state) =>
            CourrierRevisionPage(revisionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.ficheBien(':id'),
        builder: (context, state) =>
            FicheBienPage(bienId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'modifier',
            builder: (context, state) =>
                EditionBienPage(bienId: state.pathParameters['id']),
          ),
          GoRoute(
            path: 'bail',
            builder: (context, state) =>
                EditionBailPage(bienId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'locataire',
            builder: (context, state) => EditionLocatairePage(
              bienId: state.pathParameters['id']!,
              locataireId: state.uri.queryParameters['locataire'],
            ),
          ),
          GoRoute(
            path: 'investissement',
            builder: (context, state) =>
                EditionInvestissementPage(bienId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'mouvement',
            builder: (context, state) => EditionMouvementPage(
              bienId: state.pathParameters['id']!,
              mouvementId: state.uri.queryParameters['mouvement'],
            ),
          ),
          GoRoute(
            path: 'recapitulatif/:annee',
            builder: (context, state) => RecapitulatifPage(
              bienId: state.pathParameters['id']!,
              annee: int.parse(state.pathParameters['annee']!),
            ),
          ),
          GoRoute(
            path: 'intervention',
            builder: (context, state) => EditionInterventionPage(
              bienId: state.pathParameters['id']!,
              interventionId: state.uri.queryParameters['intervention'],
            ),
          ),
        ],
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
