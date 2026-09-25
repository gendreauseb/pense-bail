import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, contraintes) {
            // 2 colonnes, ou 1 seule si l'écran est étroit / le texte agrandi.
            final texteAgrandi =
                MediaQuery.textScalerOf(context).scale(1) > 1.3;
            final colonnes = contraintes.maxWidth < 320 || texteAgrandi
                ? 1
                : colonnesMax;
            const espace = 12.0;
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
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              erreur!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
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

  @override
  Widget build(BuildContext context) {
    final schema = Theme.of(context).colorScheme;
    final texte = Theme.of(context).textTheme;
    final couleurBord = selectionnee
        ? schema.primary
        : enErreur
        ? schema.error
        : schema.outlineVariant;

    return Semantics(
      button: true,
      selected: selectionnee,
      child: Material(
        color: selectionnee ? schema.primaryContainer : schema.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: couleurBord, width: selectionnee ? 2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Sélection : la coche remplace l'icône, sans prendre de
                  // place en plus (les libellés ne sont pas coupés).
                  if (icone != null || selectionnee) ...[
                    Icon(
                      selectionnee ? Icons.check_circle : icone,
                      size: 28,
                      color: schema.primary,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          libelle,
                          style: texte.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: selectionnee
                                ? schema.onPrimaryContainer
                                : schema.onSurface,
                          ),
                        ),
                        if (precision != null)
                          Text(
                            precision!,
                            style: texte.bodySmall?.copyWith(
                              color: selectionnee
                                  ? schema.onPrimaryContainer
                                  : schema.onSurfaceVariant,
                            ),
                          ),
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
