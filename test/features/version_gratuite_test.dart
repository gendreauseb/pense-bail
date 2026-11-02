import 'dart:convert';

import 'package:pense_bail/app/routes.dart';
import 'package:pense_bail/core/config/cles_reglages.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/usecases/finaliser_onboarding.dart';
import 'package:pense_bail/features/onboarding/brouillon_onboarding.dart';
import 'package:pense_bail/features/premium/fin_abonnement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

/// Version gratuite : un seul bien actif, les autres en lecture seule.
void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);

  setUp(() {
    db = baseDeTest();
    rootBundle.clear();
  });
  tearDown(() => db.close());

  /// Deux biens créés à l'onboarding : « Studio Gambetta » (saisi en premier,
  /// actif) et « T2 Belleville » (lecture seule en gratuit).
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
    bool estBeta = false,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
    await tester.pumpWidget(
      appDeTest(
        db: db,
        aujourdhui: aujourdhui,
        droits: droits,
        estBeta: estBeta,
      ),
    );
    await attendre(tester);
  }

  void aller(WidgetTester tester, String chemin) => GoRouter.of(
    tester.element(find.byType(Scaffold, skipOffstage: false).first),
  ).go(chemin);

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('accueil et liste : le second bien est en lecture seule', (
    tester,
  ) async {
    await lancer(tester, droits: Droits.gratuit);
    // Accueil : les deux biens restent visibles, un seul est verrouillé.
    expect(find.text('Studio Gambetta'), findsWidgets);
    expect(find.text('T2 Belleville'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Lecture seule'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Lecture seule'), findsOneWidget);

    aller(tester, Routes.biens);
    await attendre(tester);
    expect(find.text('Lecture seule'), findsOneWidget);
    final ligneT2 = find.ancestor(
      of: find.text('T2 Belleville'),
      matching: find.byType(InkWell),
    );
    expect(
      find.descendant(of: ligneT2.first, matching: find.text('Lecture seule')),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets("accueil : pas d'invitation à compléter un bien verrouillé", (
    tester,
  ) async {
    await lancer(tester, droits: Droits.gratuit);
    final studio = find.textContaining('IRL de référence de Studio Gambetta');
    await tester.scrollUntilVisible(
      studio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(studio, findsOneWidget);
    expect(
      find.textContaining('IRL de référence de T2 Belleville'),
      findsNothing,
    );
    await fermer(tester);
  });

  testWidgets('Premium : aucun bien en lecture seule', (tester) async {
    await lancer(tester, droits: Droits.premium);
    expect(find.text('Lecture seule'), findsNothing);
    await fermer(tester);
  });

  testWidgets('fiche verrouillée : consultation, pas de modification', (
    tester,
  ) async {
    await lancer(tester, droits: Droits.gratuit);
    aller(tester, Routes.ficheBien('t2'));
    await attendre(tester);

    expect(
      find.textContaining('en lecture seule dans la version gratuite'),
      findsOneWidget,
    );
    expect(find.text('Découvrir Pense-Bail Premium'), findsOneWidget);
    expect(find.text('Ajouter une photo'), findsNothing);
    final modifier = find.text('Modifier les informations');
    final supprimer = find.text('Supprimer ce bien');
    await tester.scrollUntilVisible(
      supprimer,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(modifier, findsNothing);
    expect(supprimer, findsOneWidget);

    // Bail : ni ajout de locataire ni modification.
    await tester.ensureVisible(find.text('Bail').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bail').first);
    await tester.pumpAndSettle();
    expect(find.text('Ajouter le locataire'), findsNothing);
    expect(find.text('Modifier'), findsNothing);
    expect(find.text('Aucun locataire renseigné.'), findsOneWidget);

    // Échéances : visibles, pas d'ajout.
    await tester.ensureVisible(find.text('Échéances').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Échéances').first);
    await tester.pumpAndSettle();
    expect(find.text('Ajouter un rappel'), findsNothing);
    expect(find.text('Fin du bail'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('fiche du bien actif : modifiable, sans bandeau', (tester) async {
    await lancer(tester, droits: Droits.gratuit);
    aller(tester, Routes.ficheBien('studio'));
    await attendre(tester);
    expect(
      find.textContaining('en lecture seule dans la version gratuite'),
      findsNothing,
    );
    expect(find.text('Ajouter une photo'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Modifier les informations'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Modifier les informations'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets("échéance d'un bien verrouillé : faite possible, pas Modifier", (
    tester,
  ) async {
    await lancer(tester, droits: Droits.gratuit);
    aller(tester, Routes.ficheBien('t2'));
    await attendre(tester);
    await tester.ensureVisible(find.text('Échéances').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Échéances').first);
    await tester.pumpAndSettle();
    final finBail = find.text('Fin du bail');
    await tester.scrollUntilVisible(
      finBail,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(finBail);
    await tester.pumpAndSettle();

    expect(find.text('Marquer comme faite'), findsOneWidget);
    expect(find.text('Reporter'), findsOneWidget);
    expect(find.text('Modifier'), findsNothing);

    await tester.tap(find.text('Marquer comme faite'));
    await attendre(tester);
    final faites = await tester.runAsync(
      () async => [
        for (final e in await DriftEcheanceRepository(
          db,
        ).surveillerParBien('t2').first)
          if (e.type == TypeEcheance.finBail && e.estFaite) e,
      ],
    );
    expect(faites, hasLength(1));
    await fermer(tester);
  });

  testWidgets('« + » puis « Ajouter un bien » : présentation de Premium', (
    tester,
  ) async {
    await lancer(tester, droits: Droits.gratuit);
    await tester.tap(find.bySemanticsLabel('Ajouter une échéance ou un bien'));
    await tester.pumpAndSettle();
    expect(find.text('Avec Pense-Bail Premium'), findsOneWidget);

    await tester.tap(find.text('Ajouter un bien'));
    await tester.pumpAndSettle();
    expect(find.text('Pense-Bail Premium'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('bientôt disponible'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('bientôt disponible'), findsOneWidget);
    // Hors bêta, aucun bouton d'activation.
    expect(find.text('Activer Premium (version bêta)'), findsNothing);
    await fermer(tester);
  });

  testWidgets('nouvelle échéance : seuls les biens modifiables sont proposés', (
    tester,
  ) async {
    await lancer(tester, droits: Droits.gratuit);
    aller(tester, Routes.nouvelleEcheance);
    await attendre(tester);
    final bienConcerne = find.text('Bien concerné');
    await tester.scrollUntilVisible(
      bienConcerne,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Studio Gambetta'), findsOneWidget);
    expect(find.text('T2 Belleville'), findsNothing);
    await fermer(tester);
  });

  testWidgets('onboarding en gratuit : prévenu avant de saisir 2 biens', (
    tester,
  ) async {
    const brouillon = BrouillonOnboarding(
      etape: EtapeOnboarding.nombreBiens,
      nombreBiens: 2,
    );
    await tester.runAsync(
      () => DriftReglagesRepository(db).ecrire(
        ClesReglages.brouillonOnboarding,
        jsonEncode(brouillon.toJson()),
      ),
    );
    await tester.pumpWidget(
      appDeTest(db: db, onboardingTermine: false, droits: Droits.gratuit),
    );
    await attendre(tester);
    expect(
      find.textContaining('La version gratuite permet de gérer un bien'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Retirer un bien'));
    await tester.pumpAndSettle();
    expect(find.textContaining('La version gratuite'), findsNothing);
    expect(
      find.text('Vous pourrez en ajouter ou en retirer plus tard.'),
      findsOneWidget,
    );
    await fermer(tester);
  });

  /// Ouvre l'onglet [onglet] de la fiche du bien [bienId].
  Future<void> ouvrirOnglet(
    WidgetTester tester,
    String bienId,
    String onglet,
  ) async {
    aller(tester, Routes.ficheBien(bienId));
    await attendre(tester);
    final cible = find.descendant(
      of: find.byType(TabBar),
      matching: find.text(onglet),
    );
    await tester.ensureVisible(cible);
    await tester.pumpAndSettle();
    await tester.tap(cible);
    await attendre(tester);
  }

  group('fonctionnalités Premium en version gratuite', () {
    testWidgets('rentabilité sans données : bandeau seul', (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrirOnglet(tester, 'studio', 'Rentabilité');
      expect(
        find.textContaining('sont inclus dans Pense-Bail Premium'),
        findsOneWidget,
      );
      expect(find.text('Loyers reçus'), findsNothing);
      expect(find.text('Ajouter une dépense ou une recette'), findsNothing);
      await fermer(tester);
    });

    testWidgets('rentabilité déjà saisie : consultable, sans saisie', (
      tester,
    ) async {
      await lancer(tester, droits: Droits.gratuit);
      await tester.runAsync(
        () => DriftFinanceRepository(db).enregistrerMouvement(
          MouvementFinancier(
            id: 'm1',
            bienId: 'studio',
            date: DateTime(2026, 3, 10),
            montantCentimes: 12000,
            categorie: CategorieMouvement.travaux,
            note: 'Peinture',
            creeLe: aujourdhui,
            modifieLe: aujourdhui,
          ),
        ),
      );
      await ouvrirOnglet(tester, 'studio', 'Rentabilité');
      expect(find.textContaining('reste consultable'), findsOneWidget);
      final ligne = find.textContaining('Peinture');
      await tester.scrollUntilVisible(
        ligne,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(ligne, findsOneWidget);
      expect(find.text('Ajouter une dépense ou une recette'), findsNothing);
      expect(find.textContaining('Exporter le récapitulatif'), findsNothing);
      expect(find.text('Compléter'), findsNothing);
      await fermer(tester);
    });

    testWidgets("carnet d'artisans : consultable, sans ajout", (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await tester.runAsync(
        () => DriftArtisanRepository(db).enregistrer(
          Artisan(
            id: 'a1',
            nom: 'Dupont Plomberie',
            metier: MetierArtisan.plombier,
            telephone: '0612345678',
            creeLe: aujourdhui,
            modifieLe: aujourdhui,
          ),
        ),
      );
      aller(tester, Routes.artisans);
      await attendre(tester);
      expect(find.textContaining('restent consultables'), findsOneWidget);
      expect(find.text('Dupont Plomberie'), findsOneWidget);
      expect(find.byTooltip('Appeler Dupont Plomberie'), findsOneWidget);
      expect(find.text('Ajouter un artisan'), findsNothing);
      await fermer(tester);
    });

    testWidgets("Premium : ajout d'artisan proposé", (tester) async {
      await lancer(tester, droits: Droits.premium);
      aller(tester, Routes.artisans);
      await attendre(tester);
      expect(find.text('Ajouter un artisan'), findsOneWidget);
      expect(find.text('Découvrir Pense-Bail Premium'), findsNothing);
      await fermer(tester);
    });

    testWidgets('courriers : produits consultables, les autres verrouillés', (
      tester,
    ) async {
      await lancer(tester, droits: Droits.gratuit);
      RevisionLoyer revision(String id, DateTime effet, bool inclus) =>
          RevisionLoyer(
            id: id,
            bienId: 'studio',
            bailId: 'bail-1',
            dateEffet: effet,
            ancienLoyerCentimes: 64000,
            nouveauLoyerCentimes: 65000,
            ancienIrlTrimestre: 2,
            ancienIrlAnnee: 2024,
            ancienIrlValeur: 145.17,
            nouvelIrlTrimestre: 2,
            nouvelIrlAnnee: 2025,
            nouvelIrlValeur: 146.68,
            courrierInclus: inclus,
            creeLe: effet,
          );
      await tester.runAsync(() async {
        final repo = DriftRevisionRepository(db);
        await repo.enregistrer(
          revision('ancienne', DateTime(2024, 9, 1), true),
        );
        await repo.enregistrer(
          revision('gratuite', DateTime(2025, 9, 1), false),
        );
      });
      await ouvrirOnglet(tester, 'studio', 'Bail');

      final verrouillee = find.bySemanticsLabel(
        RegExp(
          'Révision du 01/09/2025.*Courrier inclus dans Pense-Bail Premium',
        ),
      );
      expect(verrouillee, findsOneWidget);
      await tester.ensureVisible(verrouillee);
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel(
          RegExp('Révision du 01/09/2024.*Voir le courrier'),
        ),
        findsOneWidget,
      );

      await tester.tap(verrouillee);
      await tester.pumpAndSettle();
      expect(find.text('Pense-Bail Premium'), findsOneWidget);

      // Accès direct au courrier non inclus : page verrouillée.
      aller(tester, Routes.courrierRevision('gratuite'));
      await attendre(tester);
      expect(
        find.textContaining('Le courrier de révision est inclus'),
        findsOneWidget,
      );
      await fermer(tester);
    });
  });

  group("fin d'abonnement (bêta)", () {
    test('textes : bien actif et autres biens', () {
      final un = TextesFinAbonnement([unBien(id: 'a', nom: 'Studio')]);
      expect(un.texteBienActif, contains('« Studio » reste votre bien actif'));
      expect(un.texteAutresBiens, isNull);

      final trois = TextesFinAbonnement([
        unBien(id: 'c', nom: 'Récent', creeLe: DateTime(2026, 5)),
        unBien(id: 'a', nom: 'Ancien', creeLe: DateTime(2020)),
        unBien(id: 'b', nom: 'Moyen', creeLe: DateTime(2024)),
      ]);
      expect(trois.texteBienActif, contains('« Ancien »'));
      expect(trois.texteAutresBiens, startsWith('Vos 2 autres biens'));

      expect(TextesFinAbonnement(const []).texteBienActif, isNull);
    });

    testWidgets("simulée : message sur l'accueil, une seule fois", (
      tester,
    ) async {
      await lancer(tester, estBeta: true);
      aller(tester, Routes.reglages);
      await attendre(tester);
      await tester.tap(find.text("Simuler la fin de l'abonnement"));
      await attendre(tester);

      expect(find.text('Votre abonnement Premium a pris fin'), findsOneWidget);
      expect(find.textContaining("Rien n'a été supprimé"), findsOneWidget);
      expect(
        find.textContaining('« Studio Gambetta » reste votre bien actif'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Votre autre bien reste consultable'),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Continuer en version gratuite'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuer en version gratuite'));
      await attendre(tester);
      expect(find.text('Votre abonnement Premium a pris fin'), findsNothing);
      expect(find.text('Bêta : gratuit'), findsOneWidget);
      final drapeau = await tester.runAsync(
        () => DriftReglagesRepository(
          db,
        ).lire(ClesReglages.finAbonnementAAnnoncer),
      );
      expect(drapeau, isNull);

      // Relance de l'application : le message ne revient pas.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        appDeTest(db: db, aujourdhui: aujourdhui, estBeta: true),
      );
      await attendre(tester);
      expect(find.text('Votre abonnement Premium a pris fin'), findsNothing);
      await fermer(tester);
    });
  });
}
