import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../format/formats.dart';
import 'listes.dart';

/// Choix du trimestre de référence de l'IRL (puces « 1er trimestre »...).
class ChoixTrimestre extends StatelessWidget {
  const ChoixTrimestre({
    super.key,
    required this.valeur,
    required this.onChanged,
    this.effacable = true,
  });

  final int? valeur;

  /// `null` quand la puce active est touchée et que [effacable] est vrai.
  final ValueChanged<int?> onChanged;
  final bool effacable;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.s,
    runSpacing: AppSpacing.s,
    children: [
      for (var t = 1; t <= 4; t++)
        PuceFiltre(
          libelle: Formats.trimestre(t),
          active: valeur == t,
          onTap: () => onChanged(valeur == t && effacable ? null : t),
        ),
    ],
  );
}
