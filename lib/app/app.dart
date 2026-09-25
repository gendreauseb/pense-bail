import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'design/design.dart';
import 'router.dart';

class BailleurApp extends ConsumerWidget {
  const BailleurApp({super.key});

  static const nom = 'Pense-Bail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: nom,
      debugShowCheckedModeBanner: false,
      // Mode sombre hors périmètre V1 (UI.md §10).
      theme: AppTheme.clair(),
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(routeurProvider),
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // La taille du texte suit les réglages du téléphone (pas de blocage).
    );
  }
}
