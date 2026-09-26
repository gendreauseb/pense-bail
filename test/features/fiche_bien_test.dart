import 'package:bailleur_app/app/routes.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/finaliser_onboarding.dart';
import 'package:bailleur_app/features/accueil/accueil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);

  setUp(() => db = baseDeTest());
  tearDown(() => db.close());

  /// Studio en longue durée (bail vide depuis le 01/09/2023, sans IRL) et
  /// gîte en courte durée.
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
        BienInitial(
          bien: unBien(
            id: 'gite',
            nom: 'Gîte du lac',
            typeLocation: TypeLocation.courteDuree,
          ),
        ),
      ],
      aujourdhui: aujourdhui,
    );
  });

  Future<void> ouvrir(WidgetTester tester, String chemin) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
    await tester.pumpWidget(appDeTest(db: db, aujourdhui: aujourdhui));
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(AccueilPage))).push(chemin);
    await tester.pumpAndSettle();
  }

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> onglet(WidgetTester tester, String nom) async {
    final tab = find.widgetWithText(Tab, nom);
    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();
  }

  testWidgets('en-tête, chiffres clés et barre « Réviser le loyer »', (
    tester,
  ) async {
    await ouvrir(tester, Routes.ficheBien('studio'));
    final e = String.fromCharCode(0xA0);

    expect(find.text('Studio Gambetta'), findsOneWidget);
    expect(find.text('Longue durée'), findsWidgets);
    expect(
      find.bySemanticsLabel('Loyer hors charges : 650$e€'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Prochaine révision : 01/09/2027'),
      findsOneWidget,
    );
    expect(find.text('Réviser le loyer'), findsOneWidget);
    expect(find.text('Prochaine révision le 01/09/2027'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('courte durée : pas de barre de révision', (tester) async {
    await ouvrir(tester, Routes.ficheBien('gite'));
    expect(find.text('Gîte du lac'), findsOneWidget);
    expect(find.text('Réviser le loyer'), findsNothing);
    await fermer(tester);
  });

  testWidgets('onglet Bail : IRL de référence à compléter', (tester) async {
    await ouvrir(tester, Routes.ficheBien('studio'));
    await onglet(tester, 'Bail');
    expect(find.text('Location vide'), findsOneWidget);
    // Les lecteurs d'écran n'exposent que ce qui est visible : on défile.
    await tester.ensureVisible(find.text('IRL de référence'));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel('IRL de référence : À renseigner'),
      findsOneWidget,
    );
    expect(find.text('Ajouter le locataire'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('onglet Rentabilité : mois en retard, case « Loyer reçu »', (
    tester,
  ) async {
    await ouvrir(tester, Routes.ficheBien('studio'));
    await onglet(tester, 'Rentabilité');

    // Janvier à août 2026 sont écoulés et non cochés.
    expect(find.text('8 mois sans loyer indiqué comme reçu.'), findsOneWidget);
    final janvier = find.bySemanticsLabel('janvier 2026 : En retard');
    await tester.ensureVisible(janvier);
    await tester.pumpAndSettle();
    await tester.tap(janvier);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('janvier 2026 : Reçu'), findsOneWidget);
    expect(find.text('7 mois sans loyer indiqué comme reçu.'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('bail : dépôt de garantie limité au maximum légal', (
    tester,
  ) async {
    await ouvrir(tester, Routes.bail('studio'));
    final depot = find.widgetWithText(TextFormField, 'Dépôt de garantie');
    await tester.ensureVisible(depot);
    await tester.enterText(depot, '2000');
    await tester.tap(find.text('Enregistrer le bail'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Au-delà du maximum légal'), findsOneWidget);
    await fermer(tester);
  });
}
