import 'package:flutter/material.dart';

import '../../app/design/design.dart';

/// Écran provisoire des onglets non encore développés.
class PageAVenir extends StatelessWidget {
  const PageAVenir({
    super.key,
    required this.titre,
    required this.icone,
    required this.etape,
    this.avecRetour = false,
  });

  final String titre;
  final IconData icone;
  final String etape;

  /// Écran ouvert par-dessus un autre : bouton retour en haut.
  final bool avecRetour;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final t = context.textes;
    return Scaffold(
      appBar: avecRetour
          ? AppBar(
              leading: IconButton(
                icon: const Icon(AppIcons.retour),
                tooltip: 'Retour',
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.ecran),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSizes.pictogrammeGrand * 1.5,
                  height: AppSizes.pictogrammeGrand * 1.5,
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: AppRadius.arrondi(AppRadius.carte),
                  ),
                  child: Icon(
                    icone,
                    size: AppSizes.pictogramme,
                    color: c.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionLarge),
                Semantics(header: true, child: Text(titre, style: t.headline)),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Cet écran sera développé à l\'$etape.',
                  textAlign: TextAlign.center,
                  style: t.body.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
