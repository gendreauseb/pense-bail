import 'package:flutter/material.dart';

import '../../../app/design/design.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/composants.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: AppRadius.arrondi(AppRadius.synthese),
      ),
      padding: const EdgeInsets.all(AppSpacing.carte),
      child: ChiffresEnColonnes(
        styleValeur: t.figure.copyWith(color: c.onPrimary),
        styleLibelle: t.caption.copyWith(
          color: c.onPrimary.withValues(alpha: _opaciteLibelle),
        ),
        // Chaque chiffre est lu séparément par les lecteurs d'écran.
        libelleSemantique: (valeur, libelle) => '$valeur $libelle',
        chiffres: [
          ('$n', n > 1 ? 'biens' : 'bien'),
          (Formats.montant(synthese.loyersCentimes), 'loyers par mois'),
          (Formats.montant(synthese.chargesCentimes), 'charges par mois'),
        ],
      ),
    );
  }
}
