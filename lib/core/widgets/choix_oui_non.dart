import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import 'listes.dart';

/// Réponse « Oui », « Non » ou « Je ne sais pas » (`null`), en puces.
class ChoixOuiNon extends StatelessWidget {
  const ChoixOuiNon({super.key, required this.valeur, required this.onChanged});

  final bool? valeur;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.s,
    runSpacing: AppSpacing.s,
    children: [
      for (final (reponse, libelle) in const [
        (true, 'Oui'),
        (false, 'Non'),
        (null, 'Je ne sais pas'),
      ])
        PuceFiltre(
          libelle: libelle,
          active: valeur == reponse,
          onTap: () => onChanged(reponse),
        ),
    ],
  );
}
