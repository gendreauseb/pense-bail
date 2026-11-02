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
import '../../core/widgets/verrou.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/proximite.dart';
import '../../domain/services/tableau_de_bord.dart';
import '../premium/premium_page.dart';

/// Onglet « Biens » : tous les biens, et ajout d'un bien.
class BiensPage extends ConsumerWidget {
  const BiensPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final enCours = [
      for (final b in biens)
        if (!b.vendu) b,
    ];
    final vendus = [
      for (final b in biens)
        if (b.vendu) b,
    ];
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
            if (enCours.isNotEmpty)
              CarteListe(
                enfants: [
                  for (final bien in enCours)
                    _LigneBien(
                      bien: bien,
                      prochaine: prochaines[bien.id],
                      aujourdhui: aujourdhui,
                      mention: MentionLectureSeule.pour(
                        bien,
                        verrouille: ref.watch(bienVerrouilleProvider(bien.id)),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: AppSpacing.bloc),
            BoutonPointille(
              libelle: 'Ajouter un bien',
              onPressed: () => ouvrirAjoutBien(context, ref),
            ),
            if (vendus.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.section),
              _BiensVendus(
                enfants: [
                  for (final bien in vendus)
                    _LigneBien(
                      bien: bien,
                      prochaine: prochaines[bien.id],
                      aujourdhui: aujourdhui,
                      mention: 'Vendu le ${Formats.date(bien.venduLe!)}',
                    ),
                ],
              ),
            ],
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
    required this.mention,
  });

  final Bien bien;
  final Echeance? prochaine;
  final DateTime aujourdhui;

  /// « Lecture seule », « Vendu le … »… ; `null` si le bien est modifiable.
  final String? mention;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final prochaine = this.prochaine;
    final mention = this.mention;
    void ouvrir() => context.push(Routes.ficheBien(bien.id));
    return SemantiqueLigne(
      libelle: [
        bien.nom,
        '${bien.typeLogement.libelle}, '
            '${bien.typeLocation.libelle.toLowerCase()}',
        if (!bien.vendu) Formats.parMois(bien.loyerHcCentimes),
        if (mention != null) mention.toLowerCase(),
        if (prochaine != null)
          '${prochaine.titre} : ${textePastille(prochaine.date, aujourdhui: aujourdhui, dense: false)}',
      ].join(', '),
      onTap: ouvrir,
      child: InkWell(
        onTap: ouvrir,
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
                    if (!bien.vendu)
                      Text(
                        Formats.parMois(bien.loyerHcCentimes),
                        style: t.secondary,
                      ),
                    if (mention != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      MentionLectureSeule(libelle: mention),
                    ],
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
      ),
    );
  }
}

/// Biens vendus : section repliée sous la liste, ouverte à la demande.
class _BiensVendus extends StatefulWidget {
  const _BiensVendus({required this.enfants});
  final List<Widget> enfants;

  @override
  State<_BiensVendus> createState() => _BiensVendusState();
}

class _BiensVendusState extends State<_BiensVendus> {
  bool _ouvert = false;

  @override
  Widget build(BuildContext context) {
    final titre = 'Biens vendus (${widget.enfants.length})';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _ouvert,
          label: titre,
          excludeSemantics: true,
          child: InkWell(
            onTap: () => setState(() => _ouvert = !_ouvert),
            borderRadius: AppRadius.arrondi(AppRadius.bouton),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.zoneTactile,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(titre, style: context.textes.title)),
                  Icon(
                    _ouvert ? AppIcons.replier : AppIcons.deplier,
                    color: context.couleurs.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_ouvert) ...[
          const SizedBox(height: AppSpacing.s),
          CarteListe(enfants: widget.enfants),
        ],
      ],
    );
  }
}
