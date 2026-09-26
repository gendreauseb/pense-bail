import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../app/routes.dart';
import '../../core/format/formats.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/listes.dart';
import '../../core/widgets/photo_bien.dart';
import '../../core/widgets/statut_echeance.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/proximite.dart';
import '../../domain/services/tableau_de_bord.dart';

/// Onglet « Biens » : tous les biens, et ajout d'un bien.
class BiensPage extends ConsumerWidget {
  const BiensPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final echeances = ref.watch(echeancesAFaireFluxProvider).value ?? const [];
    final prochaines = TableauDeBord.prochaineParBien(echeances);
    final aujourdhui = ref.watch(aujourdhuiProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.ecran,
            AppSpacing.section,
            AppSpacing.ecran,
            AppSpacing.tresGrand + AppSizes.boutonCentralSurelevation,
          ),
          children: [
            Semantics(
              header: true,
              child: Text('Mes biens', style: context.textes.headline),
            ),
            const SizedBox(height: AppSpacing.section),
            if (biens.isNotEmpty)
              CarteListe(
                enfants: [
                  for (final bien in biens)
                    _LigneBien(
                      bien: bien,
                      prochaine: prochaines[bien.id],
                      aujourdhui: aujourdhui,
                    ),
                ],
              ),
            const SizedBox(height: AppSpacing.bloc),
            BoutonPointille(
              libelle: 'Ajouter un bien',
              onPressed: () => context.push(Routes.nouveauBien),
            ),
          ],
        ),
      ),
    );
  }
}

class _LigneBien extends StatelessWidget {
  const _LigneBien({
    required this.bien,
    required this.prochaine,
    required this.aujourdhui,
  });

  final Bien bien;
  final Echeance? prochaine;
  final DateTime aujourdhui;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final prochaine = this.prochaine;
    return InkWell(
      onTap: () => context.push(Routes.ficheBien(bien.id)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.ligne),
        child: Row(
          children: [
            SizedBox.square(
              dimension: AppSizes.vignette,
              child: PhotoBien(
                chemin: bien.photoChemin,
                typeLogement: bien.typeLogement,
                rayon: AppRadius.tuile,
                tailleIcone: AppSizes.pictogrammePetit,
              ),
            ),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bien.nom, style: t.rowTitle),
                  Text(
                    '${bien.typeLogement.libelle}, '
                    '${bien.typeLocation.libelle.toLowerCase()}',
                    style: t.secondary,
                  ),
                  Text(
                    Formats.parMois(bien.loyerHcCentimes),
                    style: t.secondary,
                  ),
                  if (prochaine != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.s,
                      runSpacing: AppSpacing.xxs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(prochaine.titre, style: t.caption),
                        PastilleStatut(
                          texte: textePastille(
                            prochaine.date,
                            aujourdhui: aujourdhui,
                            dense: false,
                          ),
                          proximite: Proximite.depuisDate(
                            prochaine.date,
                            aujourdhui: aujourdhui,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(AppIcons.suivant, color: context.couleurs.textSecondary),
          ],
        ),
      ),
    );
  }
}
