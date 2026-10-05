import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/routes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/listes.dart';
import '../../data/providers.dart';

/// Ouvre la présentation de Pense-Bail Premium.
void ouvrirPremium(BuildContext context) => context.push(Routes.premium);

/// Ajout d'un bien : le formulaire si les droits le permettent, sinon la
/// présentation de Premium.
void ouvrirAjoutBien(BuildContext context, WidgetRef ref) =>
    ref.read(peutAjouterBienProvider)
    ? context.push(Routes.nouveauBien)
    : ouvrirPremium(context);

/// Présentation de Pense-Bail Premium. Aucun achat pour l'instant ; en
/// version bêta, un bouton active le mode Premium simulé.
class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final estPremium = ref.watch(droitsProvider).value?.estPremium ?? false;
    final estBeta = ref.watch(estBetaProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        // Marge du bas : au-dessus de la barre de navigation du système.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          AppSpacing.s,
          AppSpacing.ecran,
          AppSpacing.ecran + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Semantics(
            header: true,
            child: Text('Pense-Bail Premium', style: t.headline),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Pour suivre tous vos biens au même endroit, du bail à la '
            'rentabilité.',
            style: t.body.copyWith(color: context.couleurs.textMuted),
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
          const TitreSection('Inclus dans Premium'),
          const CarteListe(
            enfants: [
              _Inclus(
                icone: AppIcons.biens,
                titre: 'Tous vos biens',
                detail: 'Gérez autant de logements que vous voulez.',
              ),
              _Inclus(
                icone: AppIcons.courrier,
                titre: 'Courrier de révision du loyer',
                detail:
                    'La lettre au locataire, prête à imprimer ou à envoyer.',
              ),
              _Inclus(
                icone: AppIcons.argent,
                titre: 'Rentabilité',
                detail:
                    'Rendement, journal des dépenses, loyers reçus et '
                    "récapitulatif de l'année.",
              ),
              _Inclus(
                icone: AppIcons.artisans,
                titre: "Carnet d'artisans",
                detail: 'Vos artisans et les interventions sur chaque bien.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
          const TitreSection('Toujours gratuit'),
          Text(
            'Un bien avec son bail et ses locataires, toutes ses échéances '
            "et leurs rappels, l'alerte DPE et le calcul de la révision du "
            'loyer.',
            style: t.body,
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
          if (estPremium)
            const Note(
              icone: AppIcons.selectionne,
              texte: 'Pense-Bail Premium est activé sur ce téléphone.',
            )
          else ...[
            const Note(
              texte:
                  "L'abonnement sera bientôt disponible. Vos données restent "
                  'sur votre téléphone, quelle que soit la version.',
            ),
            if (estBeta) ...[
              const SizedBox(height: AppSpacing.section),
              FilledButton(
                onPressed: () => _activerBeta(context, ref),
                child: const Text('Activer Premium (version bêta)'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _activerBeta(BuildContext context, WidgetRef ref) async {
    final navigateur = Navigator.of(context);
    final messager = ScaffoldMessenger.of(context);
    await ref.read(droitsBetaProvider).definirPremium(true);
    navigateur.pop();
    messager.showSnackBar(
      const SnackBar(content: Text('Pense-Bail Premium est activé (bêta).')),
    );
  }
}

/// Ligne d'une fonctionnalité incluse (non cliquable).
class _Inclus extends StatelessWidget {
  const _Inclus({
    required this.icone,
    required this.titre,
    required this.detail,
  });

  final IconData icone;
  final String titre;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    return Semantics(
      container: true,
      label: '$titre. $detail',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.ligne),
        child: Row(
          children: [
            TuileIcone(icone: icone),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre, style: t.rowTitle),
                  Text(detail, style: t.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
