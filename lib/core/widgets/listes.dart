// Listes, puces et bannières (design-system.md §6).

import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/proximite.dart';
import '../format/formats.dart';
import 'composants.dart';
import 'statut_echeance.dart';

/// Lignes regroupées dans une carte, séparées par un trait inset de 14.
class CarteListe extends StatelessWidget {
  const CarteListe({super.key, required this.enfants});
  final List<Widget> enfants;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (final (i, enfant) in enfants.indexed) ...[
          if (i > 0)
            const Divider(
              indent: AppSpacing.ligne,
              endIndent: AppSpacing.ligne,
            ),
          enfant,
        ],
      ],
    ),
  );
}

/// Ligne cliquable d'une liste : tuile d'icône, titre, sous-titre et
/// chevron (réglages, choix d'un élément).
class LigneNavigation extends StatelessWidget {
  const LigneNavigation({
    super.key,
    required this.icone,
    required this.titre,
    required this.onTap,
    this.sousTitre,
  });

  final IconData icone;
  final String titre;
  final String? sousTitre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final sousTitre = this.sousTitre;
    return Semantics(
      container: true,
      button: true,
      label: [titre, ?sousTitre].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
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
                    if (sousTitre != null) Text(sousTitre, style: t.secondary),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Icon(AppIcons.suivant, color: context.couleurs.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne d'échéance : tuile de date (facultative), titre, sous-titre et
/// pastille de statut, ou bouton « Calculer » pour une action directe.
class LigneEcheance extends StatelessWidget {
  const LigneEcheance({
    super.key,
    required this.echeance,
    required this.sousTitre,
    required this.aujourdhui,
    required this.onTap,
    this.avecTuile = true,
    this.dense = true,
    this.onCalculer,
  });

  final Echeance echeance;
  final String sousTitre;
  final DateTime aujourdhui;
  final VoidCallback onTap;
  final bool avecTuile;

  /// Pastille « 4 j » (liste dense) ou « Dans 4 j » (fiche).
  final bool dense;

  /// Si fourni, remplace la pastille par un petit bouton « Calculer ».
  final VoidCallback? onCalculer;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final proximite = Proximite.depuisDate(
      echeance.date,
      aujourdhui: aujourdhui,
    );
    final statut = textePastille(
      echeance.date,
      aujourdhui: aujourdhui,
      dense: dense,
    );
    final onCalculer = this.onCalculer;

    final libelle =
        '${echeance.titre}, $sousTitre, le ${Formats.date(echeance.date)}, '
        '${textePastille(echeance.date, aujourdhui: aujourdhui, dense: false)}';

    // Le contenu visuel est remplacé par un libellé complet ; le bouton
    // « Calculer » reste accessible séparément.
    final contenu = Row(
      children: [
        if (avecTuile) ...[
          TuileDate(date: echeance.date, proximite: proximite),
          const SizedBox(width: AppSpacing.bloc),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(echeance.titre, style: t.rowTitle),
              Text(sousTitre, style: t.secondary),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        if (onCalculer == null)
          PastilleStatut(texte: statut, proximite: proximite),
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.ligne),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: libelle,
                excludeSemantics: true,
                child: contenu,
              ),
            ),
            if (onCalculer != null)
              BoutonCompact(libelle: 'Calculer', onPressed: onCalculer),
          ],
        ),
      ),
    );
  }
}

/// Petit bouton primary (action rapide dans une ligne).
class BoutonCompact extends StatelessWidget {
  const BoutonCompact({
    super.key,
    required this.libelle,
    required this.onPressed,
  });

  final String libelle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      minimumSize: const Size(AppSizes.zoneTactile, AppSizes.puceFiltre),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ligne),
      textStyle: context.textes.label,
    ),
    child: Text(libelle),
  );
}

/// Puce de filtre (36 de haut) : inactive blanche avec bordure, active sur
/// fond foncé.
class PuceFiltre extends StatelessWidget {
  const PuceFiltre({
    super.key,
    required this.libelle,
    required this.active,
    required this.onTap,
  });

  final String libelle;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    return Semantics(
      button: true,
      selected: active,
      child: Material(
        color: active ? c.textPrimary : c.surface,
        shape: StadiumBorder(
          side: BorderSide(color: active ? c.textPrimary : c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.puceFiltre),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.ligne,
                vertical: AppSpacing.xxs,
              ),
              child: Center(
                widthFactor: 1,
                child: Text(
                  libelle,
                  style: context.textes.label.copyWith(
                    color: active ? c.surface : c.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bannière d'information, réservée aux données manquantes.
class BanniereInformation extends StatelessWidget {
  const BanniereInformation({
    super.key,
    required this.texte,
    required this.action,
    required this.onAction,
  });

  final String texte;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final t = context.textes;
    return Container(
      decoration: BoxDecoration(
        color: c.banniereFond,
        borderRadius: AppRadius.arrondi(AppRadius.banniere),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ligne,
        AppSpacing.s,
        AppSpacing.xs,
        AppSpacing.s,
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.information,
            color: c.banniereTexte,
            size: AppSizes.iconePetite,
          ),
          const SizedBox(width: AppSpacing.blocSerre),
          Expanded(
            child: Text(
              texte,
              style: t.secondary.copyWith(color: c.banniereTexte),
            ),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: c.banniereTexte),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}

/// État vide d'une section (« Aucune échéance à venir »).
class EtatVide extends StatelessWidget {
  const EtatVide({super.key, required this.icone, required this.texte});
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.carte),
      child: Row(
        children: [
          Icon(icone, color: context.couleurs.textSecondary),
          const SizedBox(width: AppSpacing.bloc),
          Expanded(child: Text(texte, style: context.textes.secondary)),
        ],
      ),
    ),
  );
}
