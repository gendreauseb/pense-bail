import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/listes.dart';
import '../../../core/widgets/photo_bien.dart';
import '../../../core/widgets/statut_echeance.dart';
import '../../../core/widgets/verrou.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/proximite.dart';

/// « Mes biens » : cartes de 164 de large, défilement horizontal.
class CartesBiens extends ConsumerWidget {
  const CartesBiens({
    super.key,
    required this.biens,
    required this.prochaineParBien,
  });

  final List<Bien> biens;
  final Map<String, Echeance> prochaineParBien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, bien) in biens.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpacing.bloc),
              _CarteBien(
                bien: bien,
                prochaine: prochaineParBien[bien.id],
                aujourdhui: aujourdhui,
                mention: MentionLectureSeule.pour(
                  bien,
                  verrouille: ref.watch(bienVerrouilleProvider(bien.id)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CarteBien extends StatelessWidget {
  const _CarteBien({
    required this.bien,
    required this.prochaine,
    required this.aujourdhui,
    required this.mention,
  });

  final Bien bien;
  final Echeance? prochaine;
  final DateTime aujourdhui;

  /// « Lecture seule » ou « Plus en location » ; nul si modifiable.
  final String? mention;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final prochaine = this.prochaine;
    final mention = this.mention;
    void ouvrir() => context.push(Routes.ficheBien(bien.id));
    return SizedBox(
      width: AppSizes.carteBienLargeur,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SemantiqueLigne(
          libelle: [
            bien.nom,
            bien.typeLogement.libelle,
            Formats.parMois(bien.loyerHcCentimes),
            if (mention != null) mention.toLowerCase(),
            if (prochaine != null)
              '${prochaine.titre} : ${textePastille(prochaine.date, aujourdhui: aujourdhui, dense: false)}',
          ].join(', '),
          onTap: ouvrir,
          child: InkWell(
            onTap: ouvrir,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: AppSizes.carteBienIllustration,
                  child: PhotoBien(
                    chemin: bien.photoChemin,
                    typeLogement: bien.typeLogement,
                    rayon: 0,
                    tailleIcone: AppSizes.pictogrammeMoyen,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.bloc),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bien.nom,
                        style: t.rowTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(bien.typeLogement.libelle, style: t.secondary),
                      Text(
                        Formats.parMois(bien.loyerHcCentimes),
                        style: t.secondary,
                      ),
                      if (mention != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        MentionLectureSeule(libelle: mention),
                      ],
                      if (prochaine != null) ...[
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          prochaine.titre,
                          style: t.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
