import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/config/config_app.dart';
import '../brouillon_onboarding.dart';
import '../onboarding_controller.dart';
import '../widgets/gabarit_etape.dart';

class EtapeNombreBiens extends ConsumerWidget {
  const EtapeNombreBiens({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  static const _largeurCompteur = 120.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controleur = ref.read(onboardingControllerProvider.notifier);
    final nombre = brouillon.nombreBiens;
    final t = context.textes;
    final unite = nombre > 1 ? 'biens' : 'bien';

    return GabaritEtape(
      titre: 'Combien de biens louez-vous ?',
      onRetour: controleur.precedent,
      libelleAction: 'Continuer',
      onAction: controleur.suivant,
      contenu: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sectionLarge,
                horizontal: AppSpacing.carte,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BoutonRond(
                    icone: AppIcons.retirer,
                    description: 'Retirer un bien',
                    onPressed: nombre > ConfigApp.nombreBiensMin
                        ? () => controleur.definirNombreBiens(nombre - 1)
                        : null,
                  ),
                  Semantics(
                    liveRegion: true,
                    label: '$nombre $unite',
                    excludeSemantics: true,
                    child: SizedBox(
                      width: _largeurCompteur,
                      child: Column(
                        children: [
                          Text(
                            '$nombre',
                            style: t.displayLarge.copyWith(
                              color: context.couleurs.primary,
                            ),
                          ),
                          Text(unite, style: t.secondary),
                        ],
                      ),
                    ),
                  ),
                  _BoutonRond(
                    icone: AppIcons.ajouter,
                    description: 'Ajouter un bien',
                    onPressed: nombre < ConfigApp.nombreBiensMax
                        ? () => controleur.definirNombreBiens(nombre + 1)
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          const Note(texte: 'Vous pourrez en ajouter ou en retirer plus tard.'),
        ],
      ),
    );
  }
}

/// Bouton + / − : 56 × 56, tuile bleu canard pâle.
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
  Widget build(BuildContext context) {
    final c = context.couleurs;
    return IconButton(
      onPressed: onPressed,
      tooltip: description,
      icon: Icon(icone),
      style: IconButton.styleFrom(
        fixedSize: const Size.square(AppSizes.boutonPrincipal),
        backgroundColor: c.primarySoft,
        foregroundColor: c.primary,
        disabledBackgroundColor: c.divider,
        disabledForegroundColor: c.dotInactive,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.bouton),
        ),
      ),
    );
  }
}
