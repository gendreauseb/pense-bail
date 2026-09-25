import 'dart:io';

import 'package:bailleur_app/app/app.dart';
import 'package:bailleur_app/app/etat_app.dart';
import 'package:bailleur_app/core/format/formats.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'helpers/base_memoire.dart';

void main() {
  late AppDatabase db;

  setUpAll(() => initializeDateFormatting(Formats.locale));
  setUp(() => db = baseDeTest());
  tearDown(() => db.close());

  Widget app({required bool onboardingTermine}) => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      dossierDocumentsProvider.overrideWithValue(Directory.systemTemp),
      onboardingTermineAuDemarrageProvider.overrideWithValue(onboardingTermine),
    ],
    child: const BailleurApp(),
  );

  /// Démonte l'app et laisse passer la sauvegarde différée du brouillon.
  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('onboarding terminé : barre de navigation', (tester) async {
    await tester.pumpWidget(app(onboardingTermine: true));
    await tester.pumpAndSettle();

    for (final onglet in ['Accueil', 'Biens', 'Artisans', 'Paramètres']) {
      expect(find.text(onglet), findsOneWidget);
    }
    await fermer(tester);
  });

  testWidgets('premier lancement : écrans de bienvenue', (tester) async {
    await tester.pumpWidget(app(onboardingTermine: false));
    await tester.pumpAndSettle();

    expect(find.text('Ne ratez plus aucune échéance'), findsOneWidget);
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(find.text('Tous vos biens au même endroit'), findsOneWidget);
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(find.text('Vos courriers prêts en un clic'), findsOneWidget);

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();
    expect(find.text('Vos coordonnées'), findsOneWidget);

    // Formulaire vide : les erreurs s'affichent, on reste sur l'étape.
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.text('Indiquez votre prénom.'), findsOneWidget);
    expect(find.text('Vos coordonnées'), findsOneWidget);
    await fermer(tester);
  });
}
