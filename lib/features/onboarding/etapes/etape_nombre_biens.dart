import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/config_app.dart';
import '../brouillon_onboarding.dart';
import '../onboarding_controller.dart';
import '../widgets/gabarit_etape.dart';

class EtapeNombreBiens extends ConsumerWidget {
  const EtapeNombreBiens({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controleur = ref.read(onboardingControllerProvider.notifier);
    final nombre = brouillon.nombreBiens;
    final theme = Theme.of(context);

    return GabaritEtape(
      titre: 'Combien de biens louez-vous ?',
      onRetour: controleur.precedent,
      libelleAction: 'Continuer',
      onAction: controleur.suivant,
      contenu: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BoutonRond(
                icone: Icons.remove,
                description: 'Retirer un bien',
                onPressed: nombre > ConfigApp.nombreBiensMin
                    ? () => controleur.definirNombreBiens(nombre - 1)
                    : null,
              ),
              Semantics(
                liveRegion: true,
                label: '$nombre ${nombre > 1 ? 'biens' : 'bien'}',
                excludeSemantics: true,
                child: SizedBox(
                  width: 120,
                  child: Column(
                    children: [
                      Text(
                        '$nombre',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        nombre > 1 ? 'biens' : 'bien',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              _BoutonRond(
                icone: Icons.add,
                description: 'Ajouter un bien',
                onPressed: nombre < ConfigApp.nombreBiensMax
                    ? () => controleur.definirNombreBiens(nombre + 1)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Explication(
            texte: 'Vous pourrez en ajouter ou en retirer plus tard.',
          ),
        ],
      ),
    );
  }
}

class _BoutonRond extends StatelessWidget {
  const _BoutonRond({
    required this.icone,
    required this.description,
    required this.onPressed,
  });

  final IconData icone;
  final String description;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    onPressed: onPressed,
    tooltip: description,
    iconSize: 32,
    style: IconButton.styleFrom(minimumSize: const Size(64, 64)),
    icon: Icon(icone),
  );
}
