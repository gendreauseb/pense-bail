import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'brouillon_onboarding.dart';
import 'etapes/etape_bien.dart';
import 'etapes/etape_bienvenue.dart';
import 'etapes/etape_identite.dart';
import 'etapes/etape_nombre_biens.dart';
import 'etapes/etape_photo.dart';
import 'etapes/etape_recapitulatif.dart';
import 'onboarding_controller.dart';

/// Onboarding (premier lancement uniquement). L'étape affichée provient du
/// brouillon sauvegardé : l'utilisateur reprend là où il s'était arrêté.
class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brouillon = ref.watch(onboardingControllerProvider);
    return brouillon.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (erreur, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Impossible de charger votre saisie.\n$erreur',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (b) => PopScope(
        // Le bouton « retour » du téléphone ramène à l'étape précédente.
        canPop: b.etape == EtapeOnboarding.bienvenue,
        onPopInvokedWithResult: (aQuitte, _) {
          if (!aQuitte) {
            ref.read(onboardingControllerProvider.notifier).precedent();
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            // Nouvel écran (et nouveaux champs) à chaque étape ou bien.
            key: ValueKey('${b.etape.name}-${b.indexBien}'),
            child: switch (b.etape) {
              EtapeOnboarding.bienvenue => const EtapeBienvenue(),
              EtapeOnboarding.identite => EtapeIdentite(brouillon: b),
              EtapeOnboarding.nombreBiens => EtapeNombreBiens(brouillon: b),
              EtapeOnboarding.bien => EtapeBien(brouillon: b),
              EtapeOnboarding.photoBien => EtapePhoto(brouillon: b),
              EtapeOnboarding.recapitulatif => EtapeRecapitulatif(brouillon: b),
            },
          ),
        ),
      ),
    );
  }
}

/// « Bien 2 sur 3 » + barre de progression.
class ProgressionBien extends StatelessWidget {
  const ProgressionBien({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  @override
  Widget build(BuildContext context) {
    final numero = brouillon.indexBien + 1;
    final total = brouillon.nombreBiens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bien $numero sur $total',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        // Le texte ci-dessus est déjà lu par les lecteurs d'écran.
        ExcludeSemantics(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: numero / total, minHeight: 6),
          ),
        ),
      ],
    );
  }
}
