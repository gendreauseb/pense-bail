import 'package:flutter/material.dart';

/// Écran provisoire des onglets non encore développés.
class PageAVenir extends StatelessWidget {
  const PageAVenir({
    super.key,
    required this.titre,
    required this.icone,
    required this.etape,
  });

  final String titre;
  final IconData icone;
  final String etape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(titre)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(titre, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Cet écran sera développé à l\'$etape.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
