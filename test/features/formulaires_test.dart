import 'package:pense_bail/app/routes.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/acces_biens.dart';
import 'package:pense_bail/domain/usecases/finaliser_onboarding.dart';
import 'package:pense_bail/features/accueil/accueil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

/// Écrans de saisie : enregistrement, modification, suppression, et refus
/// en version gratuite quel que soit le chemin (audit A1-02).
void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);

  setUp(() {
    db = baseDeTest();
    rootBundle.clear();
  });
  tearDown(() => db.close());

  /// « Studio Gambetta » (bien actif) et « T2 Belleville » (lecture seule
  /// en version gratuite).
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
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
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
    await tester.pumpAndSettle();
  }

  Future<void> saisir(WidgetTester tester, String libelle, String texte) async {
    final champ = find.widgetWithText(TextFormField, libelle);
    await tester.ensureVisible(champ);
    await tester.enterText(champ, texte);
    await tester.pump();
  }

  Future<void> enregistrer(WidgetTester tester) async {
    await tester.tap(find.text('Enregistrer'));
    await attendre(tester);
  }

  /// Icône de suppression de la barre du haut, puis confirmation.
  Future<void> supprimer(
    WidgetTester tester,
    String description, {
    String action = 'Supprimer',
  }) async {
    await tester.tap(find.byTooltip(description));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, action));
    await attendre(tester);
  }

  Future<T> lire<T>(WidgetTester tester, Future<T> Function() requete) async =>
      (await tester.runAsync(requete)) as T;

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  group('locataire', () {
    Future<List<Locataire>> locataires(WidgetTester tester, String bailId) =>
        lire(tester, () => DriftBailRepository(db).locataires(bailId));

    testWidgets('ajout, modification puis retrait', (tester) async {
      await lancer(tester);
      await ouvrir(tester, Routes.locataire('studio'));
      expect(find.text('Nouveau locataire'), findsOneWidget);

      await enregistrer(tester);
      expect(find.text('Indiquez le nom.'), findsOneWidget);
      expect(await locataires(tester, 'bail-1'), isEmpty);

      await saisir(tester, 'Prénom', 'Paul');
      await saisir(tester, 'Nom', 'Martin');
      await saisir(tester, 'Email (facultatif)', 'paul@exemple.fr');
      await enregistrer(tester);
      final ajoute = (await locataires(tester, 'bail-1')).single;
      expect(
        (ajoute.prenom, ajoute.nom, ajoute.email),
        ('Paul', 'Martin', 'paul@exemple.fr'),
      );

      await ouvrir(
        tester,
        Routes.avec(Routes.locataire('studio'), {'locataire': ajoute.id}),
      );
      expect(find.text('Locataire'), findsOneWidget);
      await saisir(tester, 'Nom', 'Martin-Leroy');
      await enregistrer(tester);
      expect((await locataires(tester, 'bail-1')).single.nom, 'Martin-Leroy');

      await ouvrir(
        tester,
        Routes.avec(Routes.locataire('studio'), {'locataire': ajoute.id}),
      );
      await supprimer(tester, 'Retirer le locataire', action: 'Retirer');
      expect(await locataires(tester, 'bail-1'), isEmpty);
      await fermer(tester);
    });

    testWidgets('version gratuite, bien en lecture seule : refusé', (
      tester,
    ) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrir(tester, Routes.locataire('t2'));
      await saisir(tester, 'Nom', 'Martin');
      await enregistrer(tester);
      expect(find.text(const BienVerrouille().message), findsOneWidget);
      expect(find.text('Nouveau locataire'), findsOneWidget);
      expect(await locataires(tester, 'bail-t2'), isEmpty);
      await fermer(tester);
    });
  });

  group('ligne du journal', () {
    Future<List<MouvementFinancier>> mouvements(WidgetTester tester) =>
        lire(tester, () => DriftFinanceRepository(db).mouvements('studio'));

    testWidgets('ajout, modification puis suppression', (tester) async {
      await lancer(tester);
      await ouvrir(tester, Routes.mouvement('studio'));

      await enregistrer(tester);
      expect(find.text('Choisissez une catégorie.'), findsOneWidget);
      expect(find.text('Indiquez le montant.'), findsOneWidget);

      await toucher(tester, find.text('Travaux'));
      await saisir(tester, 'Montant', '1 250,50');
      await saisir(tester, 'Note (facultatif)', 'Peinture');
      await enregistrer(tester);
      final ajoute = (await mouvements(tester)).single;
      expect(
        (ajoute.categorie, ajoute.montantCentimes, ajoute.date, ajoute.note),
        (CategorieMouvement.travaux, 125050, aujourdhui, 'Peinture'),
      );

      final chemin = Routes.avec(Routes.mouvement('studio'), {
        'mouvement': ajoute.id,
      });
      await ouvrir(tester, chemin);
      expect(find.text('Modifier la ligne'), findsOneWidget);
      await saisir(tester, 'Montant', '1300');
      await enregistrer(tester);
      expect((await mouvements(tester)).single.montantCentimes, 130000);

      await ouvrir(tester, chemin);
      await supprimer(tester, 'Supprimer la ligne');
      expect(await mouvements(tester), isEmpty);
      await fermer(tester);
    });

    testWidgets('version gratuite : refusé', (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrir(tester, Routes.mouvement('studio'));
      await toucher(tester, find.text('Travaux'));
      await saisir(tester, 'Montant', '100');
      await enregistrer(tester);
      expect(
        find.text(
          const FonctionnaliteReservee(Fonctionnalite.rentabilite).message,
        ),
        findsOneWidget,
      );
      expect(await mouvements(tester), isEmpty);
      await fermer(tester);
    });
  });

  group('chiffres de rentabilité', () {
    Future<Bien> studio(WidgetTester tester) async =>
        (await lire<Bien?>(
          tester,
          () => DriftBienRepository(db).parId('studio'),
        ))!;

    testWidgets('saisie puis effacement d\'un montant', (tester) async {
      await lancer(tester);
      await ouvrir(tester, Routes.investissement('studio'));
      await saisir(tester, 'Prix d\'achat', '150 000');
      await saisir(tester, 'Frais de notaire', '12000');
      await enregistrer(tester);
      final bien = await studio(tester);
      expect(
        (bien.prixAchatCentimes, bien.fraisNotaireCentimes),
        (15000000, 1200000),
      );

      await ouvrir(tester, Routes.investissement('studio'));
      await saisir(tester, 'Frais de notaire', '');
      await enregistrer(tester);
      final modifie = await studio(tester);
      expect(
        (modifie.prixAchatCentimes, modifie.fraisNotaireCentimes),
        (15000000, null),
      );
      await fermer(tester);
    });

    testWidgets('version gratuite : refusé', (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrir(tester, Routes.investissement('studio'));
      await saisir(tester, 'Prix d\'achat', '150000');
      await enregistrer(tester);
      expect(
        find.text(
          const FonctionnaliteReservee(Fonctionnalite.rentabilite).message,
        ),
        findsOneWidget,
      );
      expect((await studio(tester)).prixAchatCentimes, isNull);
      await fermer(tester);
    });
  });

  group('intervention', () {
    Future<List<Intervention>> interventions(WidgetTester tester) => lire(
      tester,
      () => DriftArtisanRepository(db).surveillerInterventions('studio').first,
    );
    Future<List<MouvementFinancier>> mouvements(WidgetTester tester) =>
        lire(tester, () => DriftFinanceRepository(db).mouvements('studio'));

    testWidgets('avec un coût : dépense ajoutée, puis retirée avec elle', (
      tester,
    ) async {
      await lancer(tester);
      await ouvrir(tester, Routes.intervention('studio'));

      await enregistrer(tester);
      expect(find.text('Décrivez l\'intervention.'), findsOneWidget);

      await saisir(tester, 'Travaux réalisés', 'Réparation de la fuite');
      await saisir(tester, 'Coût (facultatif)', '180');
      await enregistrer(tester);
      final ajoutee = (await interventions(tester)).single;
      expect(
        (ajoutee.description, ajoutee.coutCentimes, ajoutee.date),
        ('Réparation de la fuite', 18000, aujourdhui),
      );
      final depense = (await mouvements(tester)).single;
      expect(
        (depense.categorie, depense.montantCentimes, depense.interventionId),
        (CategorieMouvement.intervention, 18000, ajoutee.id),
      );

      await ouvrir(
        tester,
        Routes.avec(Routes.intervention('studio'), {
          'intervention': ajoutee.id,
        }),
      );
      await supprimer(tester, 'Supprimer l\'intervention');
      expect(await interventions(tester), isEmpty);
      expect(await mouvements(tester), isEmpty);
      await fermer(tester);
    });

    testWidgets('version gratuite : refusé', (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrir(tester, Routes.intervention('studio'));
      await saisir(tester, 'Travaux réalisés', 'Réparation de la fuite');
      await enregistrer(tester);
      expect(
        find.text(
          const FonctionnaliteReservee(Fonctionnalite.artisans).message,
        ),
        findsOneWidget,
      );
      expect(await interventions(tester), isEmpty);
      await fermer(tester);
    });
  });

  group('artisan', () {
    Future<List<Artisan>> artisans(WidgetTester tester) =>
        lire(tester, () => DriftArtisanRepository(db).surveillerTous().first);

    testWidgets('ajout, modification puis retrait du carnet', (tester) async {
      await lancer(tester);
      await ouvrir(tester, Routes.artisan);

      await enregistrer(tester);
      expect(find.text('Indiquez le nom.'), findsOneWidget);
      expect(find.text('Choisissez le métier.'), findsOneWidget);

      await saisir(tester, 'Nom', 'Dupont');
      await toucher(tester, find.text('Plombier'));
      await enregistrer(tester);
      final ajoute = (await artisans(tester)).single;
      expect((ajoute.nom, ajoute.metier), ('Dupont', MetierArtisan.plombier));

      final chemin = Routes.avec(Routes.artisan, {'artisan': ajoute.id});
      await ouvrir(tester, chemin);
      await saisir(tester, 'Entreprise (facultatif)', 'Dupont Plomberie');
      await enregistrer(tester);
      expect((await artisans(tester)).single.entreprise, 'Dupont Plomberie');

      await ouvrir(tester, chemin);
      await supprimer(tester, 'Retirer l\'artisan', action: 'Retirer');
      expect(await artisans(tester), isEmpty);
      await fermer(tester);
    });

    testWidgets('version gratuite : refusé', (tester) async {
      await lancer(tester, droits: Droits.gratuit);
      await ouvrir(tester, Routes.artisan);
      await saisir(tester, 'Nom', 'Dupont');
      await toucher(tester, find.text('Plombier'));
      await enregistrer(tester);
      expect(
        find.text(
          const FonctionnaliteReservee(Fonctionnalite.artisans).message,
        ),
        findsOneWidget,
      );
      expect(await artisans(tester), isEmpty);
      await fermer(tester);
    });
  });
}
