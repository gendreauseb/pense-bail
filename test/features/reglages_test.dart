import 'package:bailleur_app/app/routes.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/finaliser_onboarding.dart';
import 'package:bailleur_app/features/accueil/accueil_page.dart';
import 'package:bailleur_app/features/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);

  setUp(() {
    db = baseDeTest();
    rootBundle.clear();
  });
  tearDown(() => db.close());

  Future<void> preparer(WidgetTester tester) => tester.runAsync(() async {
    final t = DateTime(2026, 9, 1);
    await FinaliserOnboarding(
      transactions: DriftTransactions(db),
      bailleurs: DriftBailleurRepository(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: DriftEcheanceRepository(db),
      reglages: DriftReglagesRepository(db),
    ).executer(
      bailleur: Bailleur(
        id: 'moi',
        prenom: 'Marie',
        nom: 'Durand',
        rue: '1 place de la Mairie',
        codePostal: '69001',
        ville: 'Lyon',
        telephone: '',
        email: '',
        creeLe: t,
        modifieLe: t,
      ),
      biensInitiaux: [
        BienInitial(
          bien: unBien(id: 'studio', nom: 'Studio Gambetta'),
          bail: unBail(bienId: 'studio', debut: DateTime(2023, 9, 1)),
        ),
      ],
      aujourdhui: aujourdhui,
    );
  });

  /// Laisse aboutir les écritures en base (réellement asynchrones).
  Future<void> attendre(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> ouvrirReglages(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
    await tester.pumpWidget(appDeTest(db: db, aujourdhui: aujourdhui));
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(AccueilPage))).go(Routes.reglages);
    await attendre(tester);
  }

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('profil : modification visible dans les réglages', (
    tester,
  ) async {
    await ouvrirReglages(tester);
    expect(
      find.bySemanticsLabel('Marie Durand, 1 place de la Mairie, 69001 Lyon'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Rappels et notifications, 30 j, 7 j et 1 j avant'),
      findsOneWidget,
    );

    await tester.tap(find.text('Marie Durand'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Ville'),
      'Villeurbanne',
    );
    await tester.tap(find.text('Enregistrer'));
    await attendre(tester);

    expect(
      find.bySemanticsLabel(
        'Marie Durand, 1 place de la Mairie, 69001 Villeurbanne',
      ),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('rappels : délais par défaut et type sans notification', (
    tester,
  ) async {
    await ouvrirReglages(tester);
    await tester.tap(find.text('Rappels et notifications'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15 j avant'));
    await attendre(tester);
    final taxe = find.widgetWithText(SwitchListTile, 'Taxe foncière');
    await tester.ensureVisible(taxe);
    await tester.pumpAndSettle();
    await tester.tap(taxe);
    await attendre(tester);

    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel(
        'Rappels et notifications, 30 j, 15 j, 7 j et 1 j avant. '
        '1 type sans notification',
      ),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('tout effacer : retour à l\'onboarding, base vide', (
    tester,
  ) async {
    await ouvrirReglages(tester);
    final effacer = find.text('Tout effacer');
    await tester.scrollUntilVisible(
      effacer,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(effacer);
    await tester.pumpAndSettle();

    // Dialogue : le bouton de confirmation porte le même libellé.
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Tout effacer'),
      ),
    );
    await attendre(tester);

    expect(find.byType(OnboardingPage), findsOneWidget);
    final biens = await tester.runAsync(() => DriftBienRepository(db).tous());
    expect(biens, isEmpty);
    await fermer(tester);
  });

  testWidgets('mentions légales : données sur le téléphone', (tester) async {
    await ouvrirReglages(tester);
    final mentions = find.text('Mentions légales et confidentialité');
    await tester.scrollUntilVisible(
      mentions,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(mentions);
    await tester.pumpAndSettle();
    expect(find.textContaining('ne demande aucun compte'), findsOneWidget);
    expect(find.textContaining('bdm.insee.fr'), findsOneWidget);
    await fermer(tester);
  });
}
