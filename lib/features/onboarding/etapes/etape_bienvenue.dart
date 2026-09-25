import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/widgets/composants.dart';
import '../onboarding_controller.dart';
import '../widgets/illustrations_bienvenue.dart';

class _Promesse {
  const _Promesse(this.illustration, this.titre, this.texte);
  final Widget illustration;
  final String titre;
  final String texte;
}

const _promesses = [
  _Promesse(
    IllustrationEcheances(),
    'Ne ratez plus aucune échéance',
    'Révision du loyer, fin de bail, assurance, taxe foncière : '
        'Pense-Bail vous prévient à temps.',
  ),
  _Promesse(
    IllustrationBiens(),
    'Tous vos biens au même endroit',
    'Bail, locataire, rentabilité, artisans : l\'essentiel de chaque bien, '
        'toujours sous la main.',
  ),
  _Promesse(
    IllustrationCourrier(),
    'Vos courriers prêts en un clic',
    'La révision du loyer est calculée pour vous, avec un courrier prêt à '
        'envoyer. Vos données restent sur votre téléphone.',
  ),
];

class EtapeBienvenue extends ConsumerStatefulWidget {
  const EtapeBienvenue({super.key});

  @override
  ConsumerState<EtapeBienvenue> createState() => _EtapeBienvenueState();
}

class _EtapeBienvenueState extends ConsumerState<EtapeBienvenue> {
  final _pages = PageController();
  int _page = 0;

  static const _defilement = Duration(milliseconds: 300);

  bool get _derniere => _page == _promesses.length - 1;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _commencer() =>
      ref.read(onboardingControllerProvider.notifier).suivant();

  void _suivant() =>
      _pages.nextPage(duration: _defilement, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.ecran,
                AppSpacing.section,
                AppSpacing.ecran,
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: LogoPenseBail(),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: _promesses.length,
                onPageChanged: (p) => setState(() => _page = p),
                itemBuilder: (context, i) {
                  final promesse = _promesses[i];
                  return LayoutBuilder(
                    builder: (context, contraintes) => SingleChildScrollView(
                      padding: AppSpacing.paddingEcran,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: contraintes.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.section),
                            Center(child: promesse.illustration),
                            const SizedBox(height: AppSpacing.tresGrand),
                            Semantics(
                              header: true,
                              child: Text(
                                promesse.titre,
                                style: t.displayLarge,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.bloc),
                            Text(
                              promesse.texte,
                              style: t.body.copyWith(
                                color: context.couleurs.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.section),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Pagination(nombre: _promesses.length, actif: _page),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.ecran,
                AppSpacing.section,
                AppSpacing.ecran,
                AppSpacing.s,
              ),
              child: FilledButton(
                onPressed: _derniere ? _commencer : _suivant,
                child: Text(_derniere ? 'Commencer' : 'Suivant'),
              ),
            ),
            // Même hauteur sur toutes les pages : le bouton ne bouge pas.
            SizedBox(
              height: AppSizes.boutonSecondaire,
              child: _derniere
                  ? null
                  : Center(
                      child: TextButton(
                        onPressed: _commencer,
                        child: const Text('Passer l\'introduction'),
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.s),
          ],
        ),
      ),
    );
  }
}
