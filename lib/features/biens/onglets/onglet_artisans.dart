import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/services/contact.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';

/// Interventions sur le bien et accès rapide aux artisans concernés.
class OngletArtisans extends ConsumerWidget {
  const OngletArtisans({super.key, required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interventions =
        ref.watch(interventionsFluxProvider(bien.id)).value ?? const [];
    final artisans = {
      for (final a in ref.watch(artisansFluxProvider).value ?? const [])
        a.id: a,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EnTeteSection(titre: 'Interventions'),
        if (interventions.isEmpty)
          const EtatVide(
            icone: AppIcons.intervention,
            texte:
                'Aucune intervention enregistrée. Leur coût s\'ajoute '
                'automatiquement aux dépenses du bien.',
          )
        else
          CarteListe(
            enfants: [
              for (final i in interventions)
                _LigneIntervention(
                  intervention: i,
                  artisan: artisans[i.artisanId],
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.bloc),
        BoutonPointille(
          libelle: 'Ajouter une intervention',
          onPressed: () => context.push(Routes.intervention(bien.id)),
        ),
        const SizedBox(height: AppSpacing.sectionLarge),
        CarteAction(
          icone: AppIcons.artisans,
          titre: 'Carnet d\'artisans',
          sousTitre: artisans.isEmpty
              ? 'Ajoutez vos artisans de confiance'
              : '${artisans.length} artisan${artisans.length > 1 ? 's' : ''}, '
                    'communs à tous vos biens',
          onTap: () => context.go(Routes.artisans),
        ),
      ],
    );
  }
}

class _LigneIntervention extends StatelessWidget {
  const _LigneIntervention({required this.intervention, required this.artisan});
  final Intervention intervention;
  final Artisan? artisan;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final i = intervention;
    final artisan = this.artisan;
    final telephone = artisan?.telephone;
    final cout = i.coutCentimes;
    return InkWell(
      onTap: () => context.push(
        Routes.avec(Routes.intervention(i.bienId), {'intervention': i.id}),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ligne,
          AppSpacing.ligne,
          AppSpacing.xs,
          AppSpacing.ligne,
        ),
        child: Row(
          children: [
            TuileIcone(
              icone: artisan == null
                  ? AppIcons.intervention
                  : AppIcons.metier(artisan.metier),
            ),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(i.description, style: t.rowTitle),
                  Text(
                    [
                      Formats.date(i.date),
                      ?artisan?.nom,
                      if (cout != null) Formats.montant(cout),
                    ].join(', '),
                    style: t.secondary,
                  ),
                ],
              ),
            ),
            if (telephone != null)
              IconButton(
                icon: const Icon(AppIcons.appeler),
                tooltip: 'Appeler ${artisan!.nom}',
                color: context.couleurs.primary,
                onPressed: () => Contact.appeler(context, telephone),
              ),
          ],
        ),
      ),
    );
  }
}
