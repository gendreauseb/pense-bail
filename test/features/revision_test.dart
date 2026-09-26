import 'package:bailleur_app/app/routes.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/finaliser_onboarding.dart';
import 'package:bailleur_app/features/accueil/accueil_page.dart';
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
  final e = String.fromCharCode(0xA0);

  setUp(() {
    db = baseDeTest();
    // Le cache des assets garde des Future créés dans la zone du test
    // précédent : on repart de zéro.
    rootBundle.clear();
  });
  tearDown(() => db.close());

  /// Studio loué depuis le 01/09/2023 (IRL de référence non renseigné) et
  /// maison classée G.
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
          bien: unBien(id: 'maison', nom: 'Maison', classeDpe: ClasseDpe.g),
          bail: unBail(
            id: 'bail-2',
            bienId: 'maison',
            debut: DateTime(2023, 9, 1),
          ),
        ),
      ],
      aujourdhui: aujourdhui,
    );
  });

  /// Laisse aboutir les opérations réellement asynchrones (import de la
  /// table IRL embarquée, tentative de mise à jour depuis l'INSEE, écritures
  /// en base) jusqu'à la fin des chargements.
  Future<void> attendre(WidgetTester tester) async {
    for (var i = 0; i < 50; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> ouvrir(WidgetTester tester, String chemin) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
    await tester.pumpWidget(appDeTest(db: db, aujourdhui: aujourdhui));
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(AccueilPage))).push(chemin);
    await attendre(tester);
  }

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> suivant(WidgetTester tester, String libelle) async {
    await tester.tap(find.widgetWithText(FilledButton, libelle));
    await tester.pumpAndSettle();
  }

  testWidgets('révision en retard : données, indices INSEE, résultat', (
    tester,
  ) async {
    await ouvrir(tester, Routes.revision('studio'));

    expect(find.bySemanticsLabel('Étape 1 sur 3 : Vos données'), findsOne);
    expect(
      find.bySemanticsLabel('Date de révision prévue : 01/09/2026'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Nouveau loyer applicable : Dès votre courrier'),
      findsOneWidget,
    );
    expect(find.textContaining('jusqu\'au 31/08/2027'), findsOneWidget);

    await suivant(tester, 'Continuer');
    expect(find.bySemanticsLabel('Étape 2 sur 3 : Indices IRL'), findsOne);
    // Trimestre par défaut : dernier publié à la signature (T2 2023).
    expect(
      find.bySemanticsLabel('Ancien indice, 2e trimestre 2025 : 146,68'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Nouvel indice, 2e trimestre 2026 : 148,37'),
      findsOneWidget,
    );

    await suivant(tester, 'Calculer le nouveau loyer');
    expect(
      find.bySemanticsLabel('Nouveau loyer hors charges : 657,49$e€ / mois'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Évolution par mois : +7,49$e€'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('À partir du : 25/09/2026'), findsOneWidget);
    expect(
      find.text('Ajoutez le locataire pour qu\'il figure sur le courrier.'),
      findsOneWidget,
    );

    // Retour à l'étape précédente.
    await tester.tap(find.byTooltip('Étape précédente'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Étape 2 sur 3 : Indices IRL'), findsOne);
    await fermer(tester);
  });

  testWidgets('confirmation : loyer du bien mis à jour', (tester) async {
    await ouvrir(tester, Routes.revision('studio'));
    await suivant(tester, 'Continuer');
    await suivant(tester, 'Calculer le nouveau loyer');
    await tester.tap(
      find.widgetWithText(FilledButton, 'Confirmer la révision'),
    );
    await attendre(tester);

    final bien = await tester.runAsync(
      () => DriftBienRepository(db).parId('studio'),
    );
    expect(bien!.loyerHcCentimes, 65749);
    expect(find.text('Courrier au locataire'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('déjà révisé hors de l\'application : révision suivante', (
    tester,
  ) async {
    await ouvrir(tester, Routes.revision('studio'));
    await tester.tap(find.text('J\'ai déjà révisé le loyer au 01/09/2026'));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel('Date de révision prévue : 01/09/2027'),
      findsOneWidget,
    );
    await suivant(tester, 'Continuer');
    // L'IRL du T2 2027 n'est pas encore publié.
    expect(find.textContaining('L\'INSEE publiera l\'IRL'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('DPE G : révision bloquée', (tester) async {
    await ouvrir(tester, Routes.revision('maison'));
    expect(find.textContaining('classé F ou G'), findsOneWidget);
    expect(find.text('Modifier le bien'), findsOneWidget);
    await fermer(tester);
  });
}
