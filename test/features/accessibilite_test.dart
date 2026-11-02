import 'package:pense_bail/app/routes.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/usecases/finaliser_onboarding.dart';
import 'package:pense_bail/features/accueil/accueil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

// Chaque ligne d'information est lue en une seule fois par les lecteurs
// d'écran, avec un libellé complet (audit A4-01). Les boutons appeler et
// écrire restent des éléments séparés.

void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);
  final e = String.fromCharCode(0xA0);

  setUp(() => db = baseDeTest());
  tearDown(() => db.close());

  Future<void> preparer(WidgetTester tester) => tester.runAsync(() async {
    final t = DateTime(2026, 1, 5);
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
    await DriftBailRepository(db).enregistrerLocataire(
      Locataire(
        id: 'l1',
        bailId: 'bail-1',
        prenom: 'Paul',
        nom: 'Martin',
        telephone: '06 11 22 33 44',
        creeLe: t,
        modifieLe: t,
      ),
    );
    final artisans = DriftArtisanRepository(db);
    await artisans.enregistrer(
      Artisan(
        id: 'a1',
        nom: 'Karim Haddad',
        entreprise: 'Plomberie Haddad',
        metier: MetierArtisan.plombier,
        telephone: '04 78 00 00 00',
        creeLe: t,
        modifieLe: t,
      ),
    );
    await artisans.enregistrerIntervention(
      Intervention(
        id: 'i1',
        bienId: 'studio',
        artisanId: 'a1',
        date: DateTime(2026, 5, 20),
        description: 'Chauffe-eau',
        coutCentimes: 64000,
        creeLe: t,
        modifieLe: t,
      ),
    );
  });

  Future<void> ouvrir(WidgetTester tester, String chemin) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
    await tester.pumpWidget(appDeTest(db: db, aujourdhui: aujourdhui));
    await tester.pumpAndSettle();
    final routeur = GoRouter.of(tester.element(find.byType(AccueilPage)));
    if (chemin == Routes.accueil) return;
    chemin.startsWith(Routes.ficheBien(''))
        ? routeur.push(chemin)
        : routeur.go(chemin);
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

  Future<void> voir(WidgetTester tester, String texte) async {
    await tester.ensureVisible(find.text(texte).first);
    await tester.pumpAndSettle();
  }

  testWidgets('carte de bien de l\'accueil', (tester) async {
    await ouvrir(tester, Routes.accueil);
    await voir(tester, 'Studio Gambetta');
    expect(
      find.bySemanticsLabel(
        RegExp('^Studio Gambetta, Appartement, 650$e€ / mois, '),
      ),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('ligne de bien', (tester) async {
    await ouvrir(tester, Routes.biens);
    expect(
      find.bySemanticsLabel(
        RegExp(
          '^Studio Gambetta, Appartement, longue durée, 650$e€ / mois, '
          '.+ : ',
        ),
      ),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('ligne d\'artisan : appeler reste séparé', (tester) async {
    await ouvrir(tester, Routes.artisans);
    expect(
      find.bySemanticsLabel('Karim Haddad, Plombier, Plomberie Haddad'),
      findsOneWidget,
    );
    expect(find.byTooltip('Appeler Karim Haddad'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('onglet Bail : ligne de locataire', (tester) async {
    await ouvrir(tester, Routes.ficheBien('studio'));
    await onglet(tester, 'Bail');
    await voir(tester, 'Paul Martin');
    expect(
      find.bySemanticsLabel('Paul Martin, 06 11 22 33 44'),
      findsOneWidget,
    );
    expect(find.byTooltip('Appeler Paul Martin'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('onglet Rentabilité : ligne du journal', (tester) async {
    await ouvrir(tester, Routes.ficheBien('studio'));
    await onglet(tester, 'Rentabilité');
    await voir(tester, 'Intervention artisan');
    expect(
      find.bySemanticsLabel(
        'Intervention artisan, 20/05/2026, Chauffe-eau, dépense de 640$e€',
      ),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('onglet Artisans : ligne d\'intervention', (tester) async {
    await ouvrir(tester, Routes.ficheBien('studio'));
    await onglet(tester, 'Artisans');
    await voir(tester, 'Chauffe-eau');
    expect(
      find.bySemanticsLabel('Chauffe-eau, 20/05/2026, Karim Haddad, 640$e€'),
      findsOneWidget,
    );
    await fermer(tester);
  });
}
