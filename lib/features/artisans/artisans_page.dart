import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/routes.dart';
import '../../core/services/contact.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/listes.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';

/// Onglet « Artisans » : carnet commun à tous les biens.
class ArtisansPage extends ConsumerWidget {
  const ArtisansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artisans = ref.watch(artisansFluxProvider).value ?? const <Artisan>[];
    final t = context.textes;
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
            Semantics(header: true, child: Text('Artisans', style: t.headline)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Vos artisans de confiance, pour tous vos biens.',
              style: t.body.copyWith(color: context.couleurs.textMuted),
            ),
            const SizedBox(height: AppSpacing.section),
            if (artisans.isEmpty)
              const EtatVide(
                icone: AppIcons.artisans,
                texte:
                    'Aucun artisan pour le moment. Ajoutez ceux que vous '
                    'appelez en cas de souci : plombier, électricien…',
              )
            else
              CarteListe(
                enfants: [for (final a in artisans) _LigneArtisan(artisan: a)],
              ),
            const SizedBox(height: AppSpacing.bloc),
            BoutonPointille(
              libelle: 'Ajouter un artisan',
              onPressed: () => context.push(Routes.artisan),
            ),
          ],
        ),
      ),
    );
  }
}

class _LigneArtisan extends StatelessWidget {
  const _LigneArtisan({required this.artisan});
  final Artisan artisan;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final a = artisan;
    final telephone = a.telephone;
    final email = a.email;
    return InkWell(
      onTap: () => context.push(Routes.avec(Routes.artisan, {'artisan': a.id})),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ligne,
          AppSpacing.ligne,
          AppSpacing.xs,
          AppSpacing.ligne,
        ),
        child: Row(
          children: [
            TuileIcone(icone: AppIcons.metier(a.metier)),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.nom, style: t.rowTitle),
                  Text(
                    [a.metier.libelle, ?a.entreprise].join(', '),
                    style: t.secondary,
                  ),
                ],
              ),
            ),
            if (telephone != null)
              IconButton(
                icon: const Icon(AppIcons.appeler),
                tooltip: 'Appeler ${a.nom}',
                color: context.couleurs.primary,
                onPressed: () => Contact.appeler(context, telephone),
              ),
            if (email != null)
              IconButton(
                icon: const Icon(AppIcons.ecrire),
                tooltip: 'Écrire à ${a.nom}',
                color: context.couleurs.primary,
                onPressed: () => Contact.ecrire(context, email),
              ),
          ],
        ),
      ),
    );
  }
}
