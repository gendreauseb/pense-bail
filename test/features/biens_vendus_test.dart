import 'package:pense_bail/app/routes.dart';
import 'package:pense_bail/core/format/formats.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/usecases/finaliser_onboarding.dart';
import 'package:pense_bail/domain/usecases/gestion_biens.dart';
import 'package:pense_bail/features/accueil/accueil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

/// Biens vendus ou retirés de la location : écrans.
void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);
  final e = String.fromCharCode(0xA0);

  setUp(() {
    db = baseDeTest();
    rootBundle.clear();
  });
  tearDown(() => db.close());

  GestionBiens gestion() => GestionBiens(
    transactions: DriftTransactions(db),
    biens: DriftBienRepository(db),
    baux: DriftBailRepository(db),
    echeances: DriftEcheanceRepository(db),
    droits: () async => Droits.premium,
  );

  /// « Studio Gambetta » (le plus ancien, actif en version gratuite) et
  /// « T2 Belleville ».
  Future<void> preparer(
    WidgetTester tester, {
    Future<void> Function()? ensuite,
  }) => tester.runAsync(() async {
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
          bien: unBien(id: 't2', nom: 'T2 Belleville', ordre: 1),
          bail: unBail(
            id: 'bail-t2',
            bienId: 't2',
            debut: DateTime(2024, 10, 15),
          ),
        ),
      ],
      aujourdhui: aujourdhui,
    );
    await ensuite?.call();
  });

  Future<void> attendre(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> lancer(
    WidgetTester tester, {
    Droits droits = Droits.premium,
    Future<void> Function()? ensuite,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester, ensuite: ensuite);
    await tester.pumpWidget(
      appDeTest(db: db, aujourdhui: aujourdhui, droits: droits),
    );
    await attendre(tester);
  }

  Future<void> ouvrir(WidgetTester tester, String chemin) async {
    GoRouter.of(tester.element(find.byType(AccueilPage))).push(chemin);
    await attendre(tester);
  }

  Future<void> toucher(WidgetTester tester, Finder cible) async {
    await tester.ensureVisible(cible);
    await tester.pumpAndSettle();
    await tester.tap(cible);
    await attendre(tester);
  }

  Finder dansDialogue(String texte) => find.descendant(
    of: find.byType(AlertDialog),
    matching: find.widgetWithText(TextButton, texte),
  );

  Future<Bien> bien(WidgetTester tester, String id) async =>
      (await tester.runAsync(() => DriftBienRepository(db).parId(id)))!;

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('vente déclarée depuis la fiche, puis annulée', (tester) async {
    await lancer(tester);
    await ouvrir(tester, Routes.ficheBien('studio'));
    expect(find.text('Réviser le loyer'), findsOneWidget);

    await toucher(tester, find.text('Supprimer ce bien'));
    await toucher(tester, find.text('Je l\'ai vendu'));
    expect(find.text('Déclarer la vente'), findsOneWidget);

    // Date et situation du logement obligatoires ; prix facultatif.
    await toucher(tester, find.text('Continuer'));
    expect(find.text('Indiquez la date de la vente.'), findsOneWidget);
    expect(find.text('Indiquez si le logement était loué.'), findsOneWidget);

    await toucher(
      tester,
      find.widgetWithText(TextFormField, 'Date de la vente'),
    );
    await toucher(tester, find.text('Choisir cette date'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Prix de vente (facultatif)'),
      '200 000',
    );
    await toucher(tester, find.text('Oui, il était loué'));
    await toucher(tester, find.text('Continuer'));

    // Liste des échéances arrêtées avant de confirmer.
    expect(find.textContaining('Ces échéances sont arrêtées'), findsOneWidget);
    expect(find.textContaining('Fin du bail, le'), findsOneWidget);
    await toucher(tester, dansDialogue('Déclarer la vente'));

    final vendu = await bien(tester, 'studio');
    expect(
      (vendu.venduLe, vendu.prixVenteCentimes, vendu.venduLoue),
      (aujourdhui, 20000000, true),
    );
    expect(find.textContaining('Vendu le 25/09/2026'), findsOneWidget);
    expect(find.text('Réviser le loyer'), findsNothing);

    await toucher(tester, find.text('Annuler la vente'));
    expect(
      find.text(
        'Annuler la vente de «${e}Studio Gambetta$e» ?'.replaceAll(' ?', '$e?'),
      ),
      findsOneWidget,
    );
    await toucher(tester, dansDialogue('Annuler la vente'));
    expect((await bien(tester, 'studio')).enLocation, isTrue);
    expect(find.text('Réviser le loyer'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets(
    'version gratuite : retiré, il libère sa place ; remis, prévenu',
    (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrir(tester, Routes.ficheBien('studio'));
      await toucher(tester, find.text('Supprimer ce bien'));
      await toucher(tester, find.text('Je ne le loue plus'));
      expect(
        find.textContaining('Ces échéances sont arrêtées'),
        findsOneWidget,
      );
      await toucher(tester, dansDialogue('Je ne le loue plus'));

      expect((await bien(tester, 'studio')).retire, isTrue);
      expect(
        find.textContaining('Plus en location depuis le 25/09/2026'),
        findsOneWidget,
      );

      // Le T2 est devenu le bien actif : le remettre en location le
      // repasserait en lecture seule.
      await toucher(tester, find.text('Remettre en location'));
      expect(find.textContaining('T2 Belleville'), findsOneWidget);
      expect(find.textContaining('passera en lecture seule'), findsOneWidget);
      await toucher(tester, dansDialogue('Remettre en location'));
      expect((await bien(tester, 'studio')).enLocation, isTrue);
      await fermer(tester);
    },
  );

  testWidgets('liste des biens : vendus à part, repliés', (tester) async {
    await lancer(
      tester,
      ensuite: () => gestion().declarerVente(
        bienId: 't2',
        date: DateTime(2026, 6, 30),
        loue: false,
      ),
    );
    // Accueil : la régularisation gardée (vendu libre) garde le nom du bien.
    expect(find.text('Bien supprimé'), findsNothing);
    expect(find.text('T2 Belleville'), findsWidgets);

    GoRouter.of(tester.element(find.byType(AccueilPage))).go(Routes.biens);
    await attendre(tester);

    expect(find.text('Studio Gambetta'), findsOneWidget);
    expect(find.text('T2 Belleville'), findsNothing);
    await toucher(tester, find.text('Biens vendus (1)'));
    expect(find.text('T2 Belleville'), findsOneWidget);
    expect(find.text('Vendu le 30/06/2026'), findsOneWidget);
    await fermer(tester);
  });

  group('bilan de vente', () {
    Future<void> vendre() async {
      final repo = DriftBienRepository(db);
      await repo.enregistrer(
        (await repo.parId('studio'))!.copyWith(prixAchatCentimes: 15000000),
      );
      await gestion().declarerVente(
        bienId: 'studio',
        date: DateTime(2026, 6, 30),
        prixCentimes: 20000000,
        loue: false,
      );
    }

    testWidgets('Premium : plus-value et bilan', (tester) async {
      await lancer(tester, ensuite: vendre);
      await ouvrir(tester, Routes.ficheBien('studio'));
      await toucher(tester, find.text('Rentabilité'));
      expect(find.text('Plus-value brute'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          'Bilan de la vente$e: +${Formats.montant(5000000)}',
        ),
        findsOneWidget,
      );
      await fermer(tester);
    });

    testWidgets('version gratuite : présenté avec Premium', (tester) async {
      await lancer(tester, droits: Droits.gratuit, ensuite: vendre);
      await ouvrir(tester, Routes.ficheBien('studio'));
      await toucher(tester, find.text('Rentabilité'));
      expect(find.text('Plus-value brute'), findsNothing);
      expect(
        find.textContaining('Le bilan de la vente (plus-value'),
        findsOneWidget,
      );
      await fermer(tester);
    });
  });
}
