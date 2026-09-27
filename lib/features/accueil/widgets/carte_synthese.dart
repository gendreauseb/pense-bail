import 'package:flutter/material.dart';

import '../../../app/design/design.dart';
import '../../../core/format/formats.dart';
import '../../../domain/services/tableau_de_bord.dart';

/// Carte de synthèse : fond bleu canard, 3 colonnes égales (design-system.md
/// §6).
class CarteSynthese extends StatelessWidget {
  const CarteSynthese({super.key, required this.synthese});
  final Synthese synthese;

  /// Libellés à 85 % d'opacité (design-system.md).
  static const _opaciteLibelle = 0.85;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final t = context.textes;
    final n = synthese.nombreBiens;

    Widget colonne(String valeur, String libelle) => Expanded(
      child: Semantics(
        // Chaque chiffre est lu séparément par les lecteurs d'écran.
        container: true,
        label: '$valeur $libelle',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(valeur, style: t.figure.copyWith(color: c.onPrimary)),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              libelle,
              style: t.caption.copyWith(
                color: c.onPrimary.withValues(alpha: _opaciteLibelle),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: AppRadius.arrondi(AppRadius.synthese),
      ),
      padding: const EdgeInsets.all(AppSpacing.carte),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          colonne('$n', n > 1 ? 'biens' : 'bien'),
          const SizedBox(width: AppSpacing.bloc),
          colonne(Formats.montant(synthese.loyersCentimes), 'loyers par mois'),
          const SizedBox(width: AppSpacing.bloc),
          colonne(
            Formats.montant(synthese.chargesCentimes),
            'charges par mois',
          ),
        ],
      ),
    );
  }
}
