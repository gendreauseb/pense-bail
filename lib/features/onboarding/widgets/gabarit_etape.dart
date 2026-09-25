import 'package:flutter/material.dart';

/// Mise en page commune aux étapes de l'onboarding : titre, contenu
/// défilant, boutons toujours visibles en bas.
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

  /// Bouton secondaire sous l'action principale (ex. « Passer la photo »).
  final Widget? actionSecondaire;
  final VoidCallback? onRetour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // Même fond que la page : l'étape forme un seul bloc visuel.
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        leading: onRetour == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Retour',
                onPressed: onRetour,
              ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (entete != null) ...[
                      entete!,
                      const SizedBox(height: 16),
                    ],
                    Semantics(
                      header: true,
                      child: Text(titre, style: theme.textTheme.headlineSmall),
                    ),
                    if (sousTitre != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        sousTitre!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    contenu,
                  ],
                ),
              ),
            ),
            Material(
              color: theme.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: actionEnCours ? null : onAction,
                      child: actionEnCours
                          ? const SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : Text(libelleAction),
                    ),
                    if (actionSecondaire != null) ...[
                      const SizedBox(height: 8),
                      actionSecondaire!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Encadré d'explication (« À quoi ça sert ? »).
class Explication extends StatelessWidget {
  const Explication({
    super.key,
    required this.texte,
    this.icone = Icons.info_outline,
  });

  final String texte;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final schema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: schema.secondaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: schema.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texte,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: schema.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Titre de section dans un formulaire.
class TitreSection extends StatelessWidget {
  const TitreSection(this.texte, {super.key});
  final String texte;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 12),
    child: Semantics(
      header: true,
      child: Text(
        texte,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}

/// Valide le formulaire ; en cas d'erreur, fait défiler jusqu'au premier
/// champ incorrect. Retourne `true` si tout est correct.
bool validerEtMontrerErreur(GlobalKey<FormState> cle) {
  final erreurs = cle.currentState!.validateGranularly();
  if (erreurs.isEmpty) return true;
  Scrollable.ensureVisible(
    erreurs.first.context,
    duration: const Duration(milliseconds: 300),
    alignment: 0.2,
  );
  return false;
}
