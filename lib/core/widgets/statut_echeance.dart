import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../domain/services/proximite.dart';
import '../format/formats.dart';

extension CouleursProximite on AppColors {
  CouleursStatut statut(Proximite p) => switch (p) {
    Proximite.urgent => urgent,
    Proximite.bientot => bientot,
    Proximite.aVenir => aVenir,
    Proximite.lointain => lointain,
  };
}

/// Tuile de date 50 × 54 : jour en Fraunces, mois abrégé en majuscules.
/// Sa couleur suit le statut de l'échéance.
class TuileDate extends StatelessWidget {
  const TuileDate({super.key, required this.date, required this.proximite});

  final DateTime date;
  final Proximite proximite;

  @override
  Widget build(BuildContext context) {
    final couleurs = context.couleurs.statut(proximite);
    final t = context.textes;
    return Semantics(
      label: Formats.date(date),
      excludeSemantics: true,
      child: Container(
        width: AppSizes.tuileDate.width,
        height: AppSizes.tuileDate.height,
        decoration: BoxDecoration(
          color: couleurs.fond,
          borderRadius: AppRadius.arrondi(AppRadius.tuile),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${date.day}',
                  style: t.tuileJour.copyWith(color: couleurs.texte),
                ),
                Text(
                  Formats.moisAbrege(date),
                  style: t.tuileMois.copyWith(color: couleurs.texte),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pastille de statut : texte + couleur (jamais la couleur seule).
class PastilleStatut extends StatelessWidget {
  const PastilleStatut({
    super.key,
    required this.texte,
    required this.proximite,
  });

  final String texte;
  final Proximite proximite;

  @override
  Widget build(BuildContext context) {
    final couleurs = context.couleurs.statut(proximite);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.blocSerre,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: couleurs.fond,
        borderRadius: AppRadius.arrondi(AppRadius.complet),
      ),
      child: Text(
        texte,
        style: context.textes.caption.copyWith(color: couleurs.texte),
      ),
    );
  }
}
