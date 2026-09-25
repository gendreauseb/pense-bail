import 'dart:convert';
import 'dart:io';

import 'package:bailleur_app/app/app.dart';
import 'package:bailleur_app/app/etat_app.dart';
import 'package:bailleur_app/core/config/cles_reglages.dart';
import 'package:bailleur_app/core/format/formats.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/providers.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/features/onboarding/brouillon_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../helpers/base_memoire.dart';

void main() {
  late AppDatabase db;

  setUpAll(() => initializeDateFormatting(Formats.locale));
  setUp(() => db = baseDeTest());
  tearDown(() => db.close());

  /// Démarre l'app directement sur la fiche du bien 1 sur 2.
  Future<void> ouvrirFicheBien(WidgetTester tester) async {
    const brouillon = BrouillonOnboarding(
      etape: EtapeOnboarding.bien,
      nombreBiens: 2,
      biens: [
        BrouillonBien(id: 'b1'),
        BrouillonBien(id: 'b2'),
      ],
    );
    await tester.runAsync(
      () => DriftReglagesRepository(db).ecrire(
        ClesReglages.brouillonOnboarding,
        jsonEncode(brouillon.toJson()),
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          dossierDocumentsProvider.overrideWithValue(Directory.systemTemp),
          onboardingTermineAuDemarrageProvider.overrideWithValue(false),
        ],
        child: const BailleurApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('reprise sur la fiche du bien, avec la progression', (
    tester,
  ) async {
    await ouvrirFicheBien(tester);
    expect(find.text('Bien 1 sur 2'), findsOneWidget);
    expect(find.text('Décrivez votre bien'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('les champs du bail n\'apparaissent qu\'en longue durée', (
    tester,
  ) async {
    await ouvrirFicheBien(tester);
    expect(find.text('Type de bail'), findsNothing);

    await tester.ensureVisible(find.text('Longue durée'));
    await tester.tap(find.text('Longue durée'));
    await tester.pumpAndSettle();
    expect(find.text('Type de bail'), findsOneWidget);
    expect(find.text('Location meublée'), findsOneWidget);
    expect(find.text('Date de début du bail'), findsOneWidget);

    await tester.ensureVisible(find.text('Location meublée'));
    await tester.tap(find.text('Location meublée'));
    await tester.pumpAndSettle();

    // Changement de type : les champs disparaissent...
    await tester.ensureVisible(find.text('Courte durée'));
    await tester.tap(find.text('Courte durée'));
    await tester.pumpAndSettle();
    expect(find.text('Type de bail'), findsNothing);

    // ... et reviennent avec la valeur conservée.
    await tester.ensureVisible(find.text('Longue durée'));
    await tester.tap(find.text('Longue durée'));
    await tester.pumpAndSettle();
    // Coches visibles : « Longue durée » et « Location meublée ».
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    await fermer(tester);
  });
}
