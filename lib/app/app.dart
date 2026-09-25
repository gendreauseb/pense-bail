import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class BailleurApp extends ConsumerWidget {
  const BailleurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Bailleur App', // nom provisoire
      debugShowCheckedModeBanner: false,
      theme: ThemeApp.clair(),
      darkTheme: ThemeApp.sombre(),
      routerConfig: ref.watch(routeurProvider),
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // La taille du texte suit les réglages du téléphone (pas de blocage).
    );
  }
}
