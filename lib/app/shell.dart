import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/composants.dart';
import 'design/design.dart';
import 'etat_app.dart';
import 'routes.dart';

/// Coque de l'application : contenu de l'onglet + barre de navigation.
class ShellApp extends ConsumerWidget {
  const ShellApp({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _allerA(int branche) => navigationShell.goBranch(
    branche,
    initialLocation: branche == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Notification touchée : retour à l'accueil, qui ouvre l'échéance.
    ref.listen(echeanceAOuvrirProvider, (_, id) {
      if (id != null) _allerA(0);
    });
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BarreNavigation(
        brancheActive: navigationShell.currentIndex,
        onBranche: _allerA,
      ),
      // Le « + » est placé par le Scaffold (et non dans la barre) pour que
      // toute sa surface reste cliquable, y compris la partie surélevée.
      floatingActionButton: BoutonCentral(
        onPressed: () => _ouvrirAjout(context),
      ),
      floatingActionButtonLocation: const _EmplacementBoutonCentral(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
    );
  }

  Future<void> _ouvrirAjout(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    // Au-dessus de la barre de navigation et du bouton « + ».
    useRootNavigator: true,
    builder: (context) => const _ChoixAjout(),
  );
}

/// Destinations de la barre (le bouton central « + » n'est pas un onglet).
enum _Destination {
  accueil('Accueil', AppIcons.accueil, 0),
  biens('Biens', AppIcons.biens, 1),
  artisans('Artisans', AppIcons.artisans, 2),
  reglages('Réglages', AppIcons.reglages, 3);

  const _Destination(this.libelle, this.icone, this.branche);
  final String libelle;
  final IconData icone;
  final int branche;
}

/// Centré horizontalement, le haut du bouton dépasse de 26 au-dessus de la
/// barre de navigation.
class _EmplacementBoutonCentral extends FloatingActionButtonLocation {
  const _EmplacementBoutonCentral();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry g) => Offset(
    (g.scaffoldSize.width - g.floatingActionButtonSize.width) / 2,
    g.contentBottom - AppSizes.boutonCentralSurelevation,
  );
}

/// Barre de navigation (UI.md §6) : fond blanc, bordure haute, 5
/// emplacements ; celui du centre est laissé libre pour le bouton « + ».
class BarreNavigation extends StatelessWidget {
  const BarreNavigation({
    super.key,
    required this.brancheActive,
    required this.onBranche,
  });

  final int brancheActive;
  final ValueChanged<int> onBranche;

  /// Les libellés suivent la taille de texte du téléphone, dans une limite
  /// qui préserve la barre.
  static const _echelleTexteMax = 1.3;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    Widget onglet(_Destination d) => Expanded(
      child: _Onglet(
        destination: d,
        actif: d.branche == brancheActive,
        onTap: () => onBranche(d.branche),
      ),
    );

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: _echelleTexteMax,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          // Hauteur fixe : la taille du texte est déjà plafonnée ci-dessus.
          child: SizedBox(
            height: AppSizes.barreNavigation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                onglet(_Destination.accueil),
                onglet(_Destination.biens),
                const Spacer(),
                onglet(_Destination.artisans),
                onglet(_Destination.reglages),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Onglet extends StatelessWidget {
  const _Onglet({
    required this.destination,
    required this.actif,
    required this.onTap,
  });

  final _Destination destination;
  final bool actif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final couleur = actif ? c.primary : c.textSecondary;
    return Semantics(
      button: true,
      selected: actif,
      label: destination.libelle,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.icone, color: couleur, size: AppSizes.icone),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              destination.libelle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textes.nav.copyWith(
                color: couleur,
                fontWeight: actif ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouton « + » : 56 × 56, rayon 18, fond primary, ombre douce.
class BoutonCentral extends StatelessWidget {
  const BoutonCentral({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final forme = AppRadius.arrondi(AppSizes.boutonCentralRayon);
    return Semantics(
      button: true,
      label: 'Ajouter une échéance ou un bien',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: forme,
          boxShadow: AppShadows.douce(c),
        ),
        child: Material(
          color: c.primary,
          borderRadius: forme,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: AppSizes.boutonCentral,
              child: Icon(
                AppIcons.ajouter,
                color: c.onPrimary,
                size: AppSizes.icone,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Choix proposé par le bouton « + ».
class _ChoixAjout extends StatelessWidget {
  const _ChoixAjout();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          0,
          AppSpacing.ecran,
          AppSpacing.ecran,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitreSection('Ajouter'),
            CarteAction(
              icone: AppIcons.echeance,
              titre: 'Ajouter une échéance',
              sousTitre: 'Un rappel personnel, pour un bien ou pour tous',
              onTap: () {
                final routeur = GoRouter.of(context);
                Navigator.of(context).pop();
                routeur.push(Routes.nouvelleEcheance);
              },
            ),
            const SizedBox(height: AppSpacing.bloc),
            // Branché à l'étape 4 (fiche bien).
            const CarteAction(
              icone: AppIcons.biens,
              titre: 'Ajouter un bien',
              sousTitre: 'Bientôt disponible',
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}
