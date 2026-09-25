import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_controller.dart';

class _Promesse {
  const _Promesse(this.icone, this.titre, this.texte);
  final IconData icone;
  final String titre;
  final String texte;
}

const _promesses = [
  _Promesse(
    Icons.notifications_active_outlined,
    'Ne ratez plus aucune échéance',
    'Révision du loyer, fin de bail, assurance, taxe foncière : '
        'l\'application vous prévient à temps.',
  ),
  _Promesse(
    Icons.apartment,
    'Tous vos biens au même endroit',
    'Bail, locataire, rentabilité, artisans : l\'essentiel de chaque bien '
        'toujours sous la main.',
  ),
  _Promesse(
    Icons.mail_outline,
    'Vos courriers prêts en un clic',
    'La révision de loyer est calculée pour vous, avec un courrier prêt à '
        'envoyer.\n\nVos données restent sur votre téléphone.',
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

  bool get _derniere => _page == _promesses.length - 1;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _commencer() =>
      ref.read(onboardingControllerProvider.notifier).suivant();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _derniere
                    ? const SizedBox(height: 48)
                    : TextButton(
                        onPressed: _commencer,
                        child: const Text('Passer'),
                      ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: _promesses.length,
                onPageChanged: (p) => setState(() => _page = p),
                itemBuilder: (context, i) {
                  final promesse = _promesses[i];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            promesse.icone,
                            size: 64,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Semantics(
                          header: true,
                          child: Text(
                            promesse.titre,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          promesse.texte,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _Points(nombre: _promesses.length, actif: _page),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _derniere
                      ? _commencer
                      : () => _pages.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ),
                  child: Text(_derniere ? 'Commencer' : 'Suivant'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Points extends StatelessWidget {
  const _Points({required this.nombre, required this.actif});
  final int nombre;
  final int actif;

  @override
  Widget build(BuildContext context) {
    final schema = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Écran ${actif + 1} sur $nombre',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < nombre; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == actif ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == actif ? schema.primary : schema.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
