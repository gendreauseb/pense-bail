// Composants communs du design system (UI.md §6).

import 'package:flutter/material.dart';

import '../../app/design/design.dart';

/// Logo Pense-Bail : tuile d'icône + nom en Fraunces.
class LogoPenseBail extends StatelessWidget {
  const LogoPenseBail({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    return Semantics(
      label: 'Pense-Bail',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.tuileIcone,
            height: AppSizes.tuileIcone,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: AppRadius.arrondi(AppRadius.tuile),
            ),
            child: Icon(
              AppIcons.logo,
              color: c.onPrimary,
              size: AppSizes.icone,
            ),
          ),
          const SizedBox(width: AppSpacing.blocSerre),
          Text('Pense-Bail', style: context.textes.title),
        ],
      ),
    );
  }
}

/// Tuile d'icône 44 × 44 sur fond bleu canard pâle.
class TuileIcone extends StatelessWidget {
  const TuileIcone({super.key, required this.icone});
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    return Container(
      width: AppSizes.tuileIcone,
      height: AppSizes.tuileIcone,
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: AppRadius.arrondi(AppRadius.tuile),
      ),
      child: Icon(icone, color: c.primary, size: AppSizes.icone),
    );
  }
}

/// Carte d'action (ex. « Réviser un loyer ») : tuile d'icône, titre,
/// sous-titre et chevron. Toute la carte est cliquable.
class CarteAction extends StatelessWidget {
  const CarteAction({
    super.key,
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.onTap,
  });

  final IconData icone;
  final String titre;
  final String sousTitre;

  /// `null` : action indisponible (carte atténuée).
  final VoidCallback? onTap;

  static const _opaciteIndisponible = 0.55;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final c = context.couleurs;
    return Opacity(
      opacity: onTap == null ? _opaciteIndisponible : 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.ligne),
            child: Row(
              children: [
                TuileIcone(icone: icone),
                const SizedBox(width: AppSpacing.bloc),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titre, style: t.rowTitle),
                      Text(sousTitre, style: t.secondary),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Icon(AppIcons.suivant, color: c.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Explication rassurante (« À quoi ça sert ? ») : carte avec tuile d'icône.
/// À ne pas confondre avec la bannière d'information, réservée aux données
/// manquantes.
class Note extends StatelessWidget {
  const Note({
    super.key,
    required this.texte,
    this.icone = AppIcons.information,
  });

  final String texte;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.ligne),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TuileIcone(icone: icone),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Text(
                texte,
                style: context.textes.body.copyWith(
                  color: context.couleurs.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Titre de section (Fraunces 21).
class TitreSection extends StatelessWidget {
  const TitreSection(this.texte, {super.key});
  final String texte;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.bloc),
    child: Semantics(
      header: true,
      child: Text(texte, style: context.textes.title),
    ),
  );
}

/// Points de pagination : actif allongé 24 × 8, inactifs 8 × 8.
class Pagination extends StatelessWidget {
  const Pagination({super.key, required this.nombre, required this.actif});
  final int nombre;
  final int actif;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    const duree = Duration(milliseconds: 200);
    return Semantics(
      label: 'Écran ${actif + 1} sur $nombre',
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < nombre; i++)
            AnimatedContainer(
              duration: duree,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              width: i == actif
                  ? AppSizes.pointPaginationActif.width
                  : AppSizes.pointPagination,
              height: AppSizes.pointPagination,
              decoration: BoxDecoration(
                color: i == actif ? c.primary : c.dotInactive,
                borderRadius: AppRadius.arrondi(AppRadius.complet),
              ),
            ),
        ],
      ),
    );
  }
}

/// Barre d'action fixe en bas d'écran : fond blanc, bordure haute, bouton
/// principal, puis éventuellement une action secondaire ou une légende.
class BarreActionFixe extends StatelessWidget {
  const BarreActionFixe({
    super.key,
    required this.libelle,
    required this.onPressed,
    this.enCours = false,
    this.secondaire,
    this.legende,
  });

  final String libelle;
  final VoidCallback? onPressed;
  final bool enCours;
  final Widget? secondaire;
  final String? legende;

  static const _tailleIndicateur = 24.0;
  static const _epaisseurIndicateur = 3.0;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final secondaire = this.secondaire;
    final legende = this.legende;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.ecran,
            AppSpacing.bloc,
            AppSpacing.ecran,
            AppSpacing.bloc,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: enCours ? null : onPressed,
                child: enCours
                    ? SizedBox.square(
                        dimension: _tailleIndicateur,
                        child: CircularProgressIndicator(
                          strokeWidth: _epaisseurIndicateur,
                          color: c.onPrimary,
                        ),
                      )
                    : Text(libelle),
              ),
              if (secondaire != null) ...[
                const SizedBox(height: AppSpacing.xs),
                secondaire,
              ],
              if (legende != null) ...[
                const SizedBox(height: AppSpacing.s),
                Text(
                  legende,
                  textAlign: TextAlign.center,
                  style: context.textes.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
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
