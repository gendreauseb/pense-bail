import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/services/contact.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../core/widgets/verrou.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../premium/premium_page.dart';

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
    final disponible = ref.watch(
      fonctionnaliteDisponibleProvider(Fonctionnalite.artisans),
    );
    final modifiable =
        disponible && !ref.watch(bienVerrouilleProvider(bien.id));

    // Version gratuite : bandeau seul s'il n'y a rien à consulter.
    if (!disponible && interventions.isEmpty) {
      return BandeauVerrou(
        texte:
            "Le carnet d'artisans et le suivi des interventions sont inclus "
            'dans Pense-Bail Premium.',
        onDecouvrir: () => ouvrirPremium(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!disponible) ...[
          BandeauVerrou(
            texte:
                "Le carnet d'artisans et le suivi des interventions sont "
                'inclus dans Pense-Bail Premium. Les interventions déjà '
                'enregistrées restent consultables.',
            onDecouvrir: () => ouvrirPremium(context),
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
        ],
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
                  modifiable: modifiable,
                ),
            ],
          ),
        if (modifiable) ...[
          const SizedBox(height: AppSpacing.bloc),
          BoutonPointille(
            libelle: 'Ajouter une intervention',
            onPressed: () => context.push(Routes.intervention(bien.id)),
          ),
        ],
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
  const _LigneIntervention({
    required this.intervention,
    required this.artisan,
    required this.modifiable,
  });
  final Intervention intervention;
  final Artisan? artisan;

  /// Faux : la ligne n'ouvre pas le formulaire.
  final bool modifiable;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final i = intervention;
    final artisan = this.artisan;
    final telephone = artisan?.telephone;
    final cout = i.coutCentimes;
    final onTap = modifiable
        ? () => context.push(
            Routes.avec(Routes.intervention(i.bienId), {'intervention': i.id}),
          )
        : null;
    final details = [
      Formats.date(i.date),
      ?artisan?.nom,
      if (cout != null) Formats.montant(cout),
    ].join(', ');
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ligne,
          AppSpacing.ligne,
          AppSpacing.xs,
          AppSpacing.ligne,
        ),
        child: Row(
          children: [
            Expanded(
              // Appeler reste accessible séparément.
              child: SemantiqueLigne(
                libelle: '${i.description}, $details',
                onTap: onTap,
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
                          Text(details, style: t.secondary),
                        ],
                      ),
                    ),
                  ],
                ),
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
