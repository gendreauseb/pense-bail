import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/rentabilite.dart';

class OngletRentabilite extends ConsumerStatefulWidget {
  const OngletRentabilite({super.key, required this.bien});
  final Bien bien;

  @override
  ConsumerState<OngletRentabilite> createState() => _OngletRentabiliteState();
}

class _OngletRentabiliteState extends ConsumerState<OngletRentabilite> {
  late int _annee = ref.read(aujourdhuiProvider).year;

  @override
  Widget build(BuildContext context) {
    final bien = widget.bien;
    final t = context.textes;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final cle = (bien.id, _annee);
    final encaissements =
        ref.watch(encaissementsFluxProvider(cle)).value ?? const [];
    final mouvements = ref.watch(mouvementsFluxProvider(cle)).value ?? const [];
    final bail = ref.watch(bailActifFluxProvider(bien.id)).value;
    final revisions =
        ref.watch(historiqueRevisionsFluxProvider(bien.id)).value ?? const [];
    final indicateurs = Rentabilite.indicateurs(bien);
    final bilan = Rentabilite.bilan(
      bien: bien,
      annee: _annee,
      encaissements: encaissements,
      mouvements: mouvements,
      revisions: revisions,
    );
    final retard = Rentabilite.moisEnRetard(
      annee: _annee,
      encaissements: encaissements,
      aujourdhui: aujourdhui,
      debutBail: bail?.dateDebut,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EnTeteSection(
          titre: 'Ce que le bien rapporte',
          action: 'Compléter',
          onAction: () => context.push(Routes.investissement(bien.id)),
        ),
        _Indicateurs(indicateurs: indicateurs),
        const SizedBox(height: AppSpacing.sectionLarge),
        _SelecteurAnnee(
          annee: _annee,
          max: aujourdhui.year,
          onChanged: (a) => setState(() => _annee = a),
        ),
        const SizedBox(height: AppSpacing.bloc),
        const EnTeteSection(titre: 'Loyers reçus'),
        Text(
          retard.isEmpty
              ? 'Touchez un mois quand le loyer est arrivé.'
              : '${retard.length} ${retard.length > 1 ? 'mois' : 'mois'} '
                    'sans loyer indiqué comme reçu.',
          style: retard.isEmpty
              ? t.secondary
              : t.secondary.copyWith(
                  color: context.couleurs.erreur,
                  fontWeight: FontWeight.w700,
                ),
        ),
        const SizedBox(height: AppSpacing.bloc),
        _GrilleMois(
          bienId: bien.id,
          annee: _annee,
          encaissements: encaissements,
          retard: retard,
          aujourdhui: aujourdhui,
        ),
        const SizedBox(height: AppSpacing.sectionLarge),
        EnTeteSection(titre: 'Bilan $_annee'),
        CarteListe(
          enfants: [
            LigneInfo(
              libelle: 'Loyers perçus (${bilan.moisRecus} mois)',
              valeur: Formats.montant(bilan.loyersPercus),
            ),
            LigneInfo(
              libelle: 'Autres recettes',
              valeur: Formats.montant(bilan.autresRecettes),
            ),
            LigneInfo(
              libelle: 'Dépenses',
              valeur: Formats.montant(bilan.depenses),
            ),
            LigneInfo(
              libelle: 'Résultat',
              valeur: Formats.montant(bilan.resultat),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Loyers des mois cochés, au montant en vigueur chaque mois.',
          style: t.caption,
        ),
        const SizedBox(height: AppSpacing.bloc),
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.recapitulatif(bien.id, _annee)),
          icon: const Icon(AppIcons.document),
          label: Text('Exporter le récapitulatif $_annee (PDF)'),
        ),
        const SizedBox(height: AppSpacing.sectionLarge),
        EnTeteSection(titre: 'Journal $_annee'),
        if (mouvements.isNotEmpty) ...[
          CarteListe(
            enfants: [
              for (final m in mouvements) _LigneMouvement(mouvement: m),
            ],
          ),
          const SizedBox(height: AppSpacing.bloc),
        ],
        BoutonPointille(
          libelle: 'Ajouter une dépense ou une recette',
          onPressed: () => context.push(Routes.mouvement(bien.id)),
        ),
      ],
    );
  }
}

class _Indicateurs extends StatelessWidget {
  const _Indicateurs({required this.indicateurs});
  final IndicateursRentabilite indicateurs;

  @override
  Widget build(BuildContext context) {
    final i = indicateurs;
    final brut = i.rendementBrut;
    final net = i.rendementNet;
    return CarteListe(
      enfants: [
        LigneInfo(
          libelle: 'Cash-flow mensuel',
          valeur: Formats.montant(i.cashFlowMensuel),
        ),
        LigneInfo(
          libelle: 'Cash-flow annuel',
          valeur: Formats.montant(i.cashFlowAnnuel),
        ),
        LigneInfo(
          libelle: 'Rendement brut',
          valeur: brut == null
              ? 'Prix d\'achat à renseigner'
              : Formats.pourcentage(brut),
        ),
        LigneInfo(
          libelle: 'Rendement net de charges',
          valeur: net == null
              ? 'Prix d\'achat à renseigner'
              : Formats.pourcentage(net),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.ligne),
          child: Text(
            'Cash-flow : loyer hors charges, moins la mensualité de crédit '
            'et vos charges annuelles. Rendement : loyers de l\'année '
            'divisés par le coût d\'achat (prix, notaire, travaux).',
            style: context.textes.caption,
          ),
        ),
      ],
    );
  }
}

class _SelecteurAnnee extends StatelessWidget {
  const _SelecteurAnnee({
    required this.annee,
    required this.max,
    required this.onChanged,
  });

  final int annee;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        icon: const Icon(AppIcons.precedent),
        tooltip: 'Année ${annee - 1}',
        onPressed: () => onChanged(annee - 1),
      ),
      Expanded(
        child: Semantics(
          liveRegion: true,
          child: Text(
            'Année $annee',
            textAlign: TextAlign.center,
            style: context.textes.title,
          ),
        ),
      ),
      IconButton(
        icon: const Icon(AppIcons.suivant),
        tooltip: 'Année ${annee + 1}',
        onPressed: annee < max ? () => onChanged(annee + 1) : null,
      ),
    ],
  );
}

/// 12 mois : reçu (coché), en retard, à venir.
class _GrilleMois extends ConsumerWidget {
  const _GrilleMois({
    required this.bienId,
    required this.annee,
    required this.encaissements,
    required this.retard,
    required this.aujourdhui,
  });

  final String bienId;
  final int annee;
  final List<EncaissementLoyer> encaissements;
  final List<int> retard;
  final DateTime aujourdhui;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recus = {
      for (final e in encaissements)
        if (e.recu) e.mois,
    };
    return LayoutBuilder(
      builder: (context, contraintes) {
        const colonnes = 3;
        const espace = AppSpacing.s;
        final largeur =
            (contraintes.maxWidth - espace * (colonnes - 1)) / colonnes;
        return Wrap(
          spacing: espace,
          runSpacing: espace,
          children: [
            for (var mois = 1; mois <= 12; mois++)
              SizedBox(
                width: largeur,
                child: _CaseMois(
                  mois: DateTime(annee, mois),
                  recu: recus.contains(mois),
                  enRetard: retard.contains(mois),
                  futur:
                      annee > aujourdhui.year ||
                      (annee == aujourdhui.year && mois > aujourdhui.month),
                  onTap: () => ref
                      .read(financeRepositoryProvider)
                      .definirEncaissement(
                        EncaissementLoyer(
                          bienId: bienId,
                          annee: annee,
                          mois: mois,
                          recu: !recus.contains(mois),
                          recuLe: recus.contains(mois) ? null : aujourdhui,
                        ),
                      ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CaseMois extends StatelessWidget {
  const _CaseMois({
    required this.mois,
    required this.recu,
    required this.enRetard,
    required this.futur,
    required this.onTap,
  });

  final DateTime mois;
  final bool recu;
  final bool enRetard;
  final bool futur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final t = context.textes;
    final statut = recu
        ? c.aVenir
        : enRetard
        ? c.urgent
        : c.lointain;
    final etat = recu
        ? 'Reçu'
        : enRetard
        ? 'En retard'
        : futur
        ? 'À venir'
        : 'Non reçu';
    final nomMois = Formats.dateLongue(mois).split(' ')[1];

    return Semantics(
      button: !futur,
      checked: recu,
      label: '$nomMois ${mois.year} : $etat',
      excludeSemantics: true,
      child: Material(
        color: futur ? c.surface : statut.fond,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.tuile),
          side: futur ? BorderSide(color: c.border) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: futur ? null : onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: AppSizes.tuileDate.height),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (recu) ...[
                        Icon(
                          AppIcons.selectionne,
                          size: AppSizes.iconePetite,
                          color: statut.texte,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                      ],
                      Text(
                        Formats.moisAbrege(mois),
                        style: t.tuileMois.copyWith(
                          color: futur ? c.textSecondary : statut.texte,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    etat,
                    style: t.caption.copyWith(
                      color: futur ? c.textSecondary : statut.texte,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LigneMouvement extends StatelessWidget {
  const _LigneMouvement({required this.mouvement});
  final MouvementFinancier mouvement;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final m = mouvement;
    final recette = m.sens == SensMouvement.recette;
    final note = m.note;
    return InkWell(
      onTap: () => context.push(
        Routes.avec(Routes.mouvement(m.bienId), {'mouvement': m.id}),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.ligne),
        child: Row(
          children: [
            TuileIcone(icone: recette ? AppIcons.recette : AppIcons.depense),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.categorie.libelle, style: t.rowTitle),
                  Text(
                    [Formats.date(m.date), ?note].join(', '),
                    style: t.secondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            // Couleurs d'alerte réservées aux échéances : montant en texte.
            Text(
              '${recette ? '+' : '−'} ${Formats.montant(m.montantCentimes)}',
              style: t.rowTitle.copyWith(
                color: recette
                    ? context.couleurs.primary
                    : context.couleurs.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
