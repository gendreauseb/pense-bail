import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/routes.dart';
import '../../core/format/formats.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/feuille.dart';
import '../../core/widgets/listes.dart';
import '../../core/widgets/photo_bien.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/calculateur_revision.dart';

/// Choix du bien à réviser : seuls les biens en location longue durée sont
/// proposés, les autres apparaissent grisés avec l'explication.
Future<void> ouvrirChoixBienRevision(BuildContext context) =>
    ouvrirFeuille<void>(context, builder: (_) => const _ChoixBien());

class _ChoixBien extends ConsumerWidget {
  const _ChoixBien();

  static const _opaciteIndisponible = 0.5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final t = context.textes;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ecran,
        0,
        AppSpacing.ecran,
        AppSpacing.ecran,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitreSection('Réviser un loyer'),
          Text('Choisissez le bien concerné.', style: t.secondary),
          const SizedBox(height: AppSpacing.bloc),
          CarteListe(
            enfants: [
              for (final bien in biens)
                _LigneBien(
                  bien: bien,
                  opaciteIndisponible: _opaciteIndisponible,
                  onTap: bien.typeLocation.revisionDisponible
                      ? () {
                          final routeur = GoRouter.of(context);
                          Navigator.of(context).pop();
                          routeur.push(Routes.revision(bien.id));
                        }
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LigneBien extends StatelessWidget {
  const _LigneBien({
    required this.bien,
    required this.onTap,
    required this.opaciteIndisponible,
  });

  final Bien bien;
  final VoidCallback? onTap;
  final double opaciteIndisponible;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final c = context.couleurs;
    final disponible = onTap != null;
    return Semantics(
      button: disponible,
      enabled: disponible,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: disponible ? 1 : opaciteIndisponible,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.ligne),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: AppSizes.tuileIcone,
                  child: PhotoBien(
                    chemin: bien.photoChemin,
                    typeLogement: bien.typeLogement,
                    rayon: AppRadius.tuile,
                    tailleIcone: AppSizes.iconePetite,
                  ),
                ),
                const SizedBox(width: AppSpacing.bloc),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bien.nom, style: t.rowTitle),
                      Text(
                        disponible
                            ? '${bien.typeLocation.libelle}, '
                                  '${Formats.parMois(bien.loyerHcCentimes)}'
                            : BlocageRevision.pasLongueDuree.message,
                        style: t.secondary,
                      ),
                    ],
                  ),
                ),
                Icon(
                  disponible ? AppIcons.suivant : AppIcons.verrou,
                  color: c.textSecondary,
                  size: AppSizes.iconePetite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
