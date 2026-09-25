import 'package:flutter/material.dart';

import '../../../app/design/design.dart';
import '../../../core/widgets/composants.dart';

export '../../../core/widgets/composants.dart';

/// Mise en page commune aux étapes de l'onboarding : titre, contenu
/// défilant, barre d'action fixe en bas.
class GabaritEtape extends StatelessWidget {
  const GabaritEtape({
    super.key,
    required this.titre,
    this.sousTitre,
    this.entete,
    required this.contenu,
    required this.libelleAction,
    required this.onAction,
    this.actionEnCours = false,
    this.actionSecondaire,
    this.onRetour,
  });

  final String titre;
  final String? sousTitre;

  /// Affiché au-dessus du titre (ex. progression « Bien 2 sur 3 »).
  final Widget? entete;
  final Widget contenu;
  final String libelleAction;
  final VoidCallback? onAction;
  final bool actionEnCours;

  /// Action secondaire sous le bouton principal (ex. « Passer la photo »).
  final Widget? actionSecondaire;
  final VoidCallback? onRetour;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final entete = this.entete;
    final sousTitre = this.sousTitre;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: onRetour == null
            ? null
            : IconButton(
                icon: const Icon(AppIcons.retour),
                tooltip: 'Retour',
                onPressed: onRetour,
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          AppSpacing.s,
          AppSpacing.ecran,
          AppSpacing.ecran,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (entete != null) ...[
              entete,
              const SizedBox(height: AppSpacing.section),
            ],
            Semantics(header: true, child: Text(titre, style: t.headline)),
            if (sousTitre != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                sousTitre,
                style: t.body.copyWith(color: context.couleurs.textMuted),
              ),
            ],
            const SizedBox(height: AppSpacing.sectionLarge),
            contenu,
          ],
        ),
      ),
      bottomNavigationBar: BarreActionFixe(
        libelle: libelleAction,
        onPressed: onAction,
        enCours: actionEnCours,
        secondaire: actionSecondaire,
      ),
    );
  }
}
