import 'package:flutter/material.dart';

import '../../app/design/design.dart';

/// Choix unique présenté sous forme de grandes cartes (plus lisibles et plus
/// faciles à toucher qu'une liste déroulante).
class ChoixCartes<T> extends StatelessWidget {
  const ChoixCartes({
    super.key,
    required this.options,
    required this.valeur,
    required this.libelle,
    required this.onChanged,
    this.icone,
    this.precision,
    this.erreur,
    this.colonnesMax = 2,
  });

  final List<T> options;
  final T? valeur;
  final String Function(T) libelle;
  final IconData Function(T)? icone;
  final String Function(T)? precision;
  final ValueChanged<T> onChanged;
  final String? erreur;

  /// 1 pour les options à libellé long (toujours une carte par ligne).
  final int colonnesMax;

  /// Au-delà, le texte agrandi par l'utilisateur impose une seule colonne.
  static const _echelleTexteMaxDeuxColonnes = 1.3;
  static const _largeurMinDeuxColonnes = 320.0;

  @override
  Widget build(BuildContext context) {
    final erreur = this.erreur;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, contraintes) {
            final texteAgrandi =
                MediaQuery.textScalerOf(context).scale(1) >
                _echelleTexteMaxDeuxColonnes;
            final colonnes =
                contraintes.maxWidth < _largeurMinDeuxColonnes || texteAgrandi
                ? 1
                : colonnesMax;
            const espace = AppSpacing.bloc;
            final largeur =
                (contraintes.maxWidth - espace * (colonnes - 1)) / colonnes;
            return Wrap(
              spacing: espace,
              runSpacing: espace,
              children: [
                for (final option in options)
                  SizedBox(
                    width: largeur,
                    child: _Carte(
                      libelle: libelle(option),
                      precision: precision?.call(option),
                      icone: icone?.call(option),
                      selectionnee: option == valeur,
                      enErreur: erreur != null,
                      onTap: () => onChanged(option),
                    ),
                  ),
              ],
            );
          },
        ),
        if (erreur != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.s,
              left: AppSpacing.bloc,
            ),
            child: Text(
              erreur,
              style: context.textes.secondary.copyWith(
                color: context.couleurs.erreur,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _Carte extends StatelessWidget {
  const _Carte({
    required this.libelle,
    required this.precision,
    required this.icone,
    required this.selectionnee,
    required this.enErreur,
    required this.onTap,
  });

  final String libelle;
  final String? precision;
  final IconData? icone;
  final bool selectionnee;
  final bool enErreur;
  final VoidCallback onTap;

  static const _hauteurMin = 64.0;
  static const _bordureSelection = 2.0;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final t = context.textes;
    final bordure = selectionnee
        ? BorderSide(color: c.primary, width: _bordureSelection)
        : BorderSide(color: enErreur ? c.erreur : c.border);
    final precision = this.precision;

    return Semantics(
      button: true,
      selected: selectionnee,
      child: Material(
        color: selectionnee ? c.primarySoft : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.bouton),
          side: bordure,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _hauteurMin),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.ligne,
                vertical: AppSpacing.bloc,
              ),
              child: Row(
                children: [
                  // Sélection : la coche remplace l'icône, sans prendre de
                  // place en plus (les libellés ne sont pas coupés).
                  if (icone != null || selectionnee) ...[
                    Icon(
                      selectionnee ? AppIcons.selectionne : icone,
                      size: AppSizes.icone,
                      color: selectionnee ? c.primary : c.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.bloc),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          libelle,
                          style: t.rowTitle.copyWith(
                            color: selectionnee ? c.primary : c.textPrimary,
                          ),
                        ),
                        if (precision != null)
                          Text(precision, style: t.secondary),
                      ],
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

/// [ChoixCartes] intégré à un [Form] (validation et message d'erreur).
class ChampChoix<T> extends FormField<T> {
  ChampChoix({
    super.key,
    required List<T> options,
    required T? valeurInitiale,
    required String Function(T) libelle,
    required ValueChanged<T> onChanged,
    IconData Function(T)? icone,
    String Function(T)? precision,
    String messageObligatoire = 'Choisissez une option.',
    int colonnesMax = 2,
  }) : super(
         initialValue: valeurInitiale,
         validator: (v) => v == null ? messageObligatoire : null,
         builder: (state) => ChoixCartes<T>(
           options: options,
           valeur: state.value,
           libelle: libelle,
           icone: icone,
           precision: precision,
           erreur: state.errorText,
           colonnesMax: colonnesMax,
           onChanged: (v) {
             state.didChange(v);
             onChanged(v);
           },
         ),
       );
}
