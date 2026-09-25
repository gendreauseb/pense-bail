import 'package:bailleur_app/app/design/design.dart';
import 'package:bailleur_app/app/shell.dart';
import 'package:bailleur_app/core/widgets/listes.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/finaliser_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/lanceur_app.dart';
import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  final aujourdhui = DateTime(2026, 9, 25);

  setUp(() => db = baseDeTest());
  tearDown(() => db.close());

  /// Marie : un studio en longue durée (bail vide depuis le 01/09/2023, sans
  /// IRL de référence) et un gîte en courte durée.
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
            loyerHcCentimes: 115000,
          ).copyWith(chargesCentimes: 0),
        ),
      ],
      aujourdhui: aujourdhui,
    );
  });

  Future<void> ouvrir(WidgetTester tester) async {
    // Écran de téléphone, pour une mise en page réaliste.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await preparer(tester);
    await tester.pumpWidget(appDeTest(db: db, aujourdhui: aujourdhui));
    await tester.pumpAndSettle();
  }

  Future<void> fermer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('en-tête, synthèse et action de révision', (tester) async {
    await ouvrir(tester);

    expect(find.text('Vendredi 25 septembre'), findsOneWidget);
    expect(find.text('Bonjour Marie'), findsOneWidget);

    expect(find.bySemanticsLabel('2 biens'), findsOneWidget);
    // Espace insécable du format français des montants.
    final e = String.fromCharCode(0xA0);
    expect(
      find.bySemanticsLabel('1${e}800$e€ loyers par mois'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('50$e€ charges par mois'), findsOneWidget);
    expect(find.text('Réviser un loyer'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('échéances triées, commune comprise, filtre par bien', (
    tester,
  ) async {
    await ouvrir(tester);

    Finder dansLaListe(String texte) => find.descendant(
      of: find.byType(CarteListe).first,
      matching: find.text(texte),
    );

    // Première échéance : taxe foncière du 15/10 (20 jours, « bientôt »).
    final taxes = dansLaListe('Taxe foncière');
    expect(taxes, findsNWidgets(2)); // une par bien
    expect(find.text('20 j'), findsNWidgets(2));
    // La déclaration est commune à tous les biens.
    expect(find.text('Déclaration des revenus fonciers'), findsOneWidget);
    expect(find.text('Tous vos biens'), findsOneWidget);

    // 7 échéances au total : 5 affichées, puis « Afficher les 2 autres ».
    expect(find.text('Afficher les 2 autres'), findsOneWidget);

    // Filtre sur le gîte : seule sa taxe foncière reste.
    final puceGite = find.descendant(
      of: find.byType(PuceFiltre),
      matching: find.text('Gîte du lac'),
    );
    await tester.ensureVisible(puceGite);
    await tester.pumpAndSettle();
    await tester.tap(puceGite);
    await tester.pumpAndSettle();
    expect(dansLaListe('Taxe foncière'), findsOneWidget);
    expect(dansLaListe('Déclaration des revenus fonciers'), findsNothing);
    await fermer(tester);
  });

  testWidgets('révision : bouton « Calculer » à la place de la pastille', (
    tester,
  ) async {
    await ouvrir(tester);
    // La révision (01/09/2027) est la 4e : visible dans les 5 premières.
    expect(find.text('Révision du loyer'), findsOneWidget);
    expect(find.text('Calculer'), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('invitation à compléter le gîte et l\'IRL du studio', (
    tester,
  ) async {
    await ouvrir(tester);
    await tester.scrollUntilVisible(
      find.text('Mes biens'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(
      find.text(
        'Indiquez l\'IRL de référence de Studio Gambetta pour calculer sa '
        'révision.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Complétez Gîte du lac pour activer vos rappels.'),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('détail d\'une échéance, marquée faite puis annulée', (
    tester,
  ) async {
    await ouvrir(tester);

    await tester.tap(find.text('Déclaration des revenus fonciers'));
    await tester.pumpAndSettle();
    expect(find.text('TOUS VOS BIENS'), findsOneWidget);
    expect(find.text('Se répète chaque année'), findsOneWidget);
    expect(
      find.text('Rappels 30 j avant, 7 j avant et 1 j avant'),
      findsOneWidget,
    );

    await tester.tap(find.text('Marquer comme faite'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.textContaining('Prochaine le 20/05/2028'), findsOneWidget);

    // Annuler : l'échéance revient au 20/05/2027.
    await tester.tap(find.text('Annuler'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    final echeances = await tester.runAsync(
      () => DriftEcheanceRepository(db).aFaire(),
    );
    final declarations = echeances!.where(
      (e) => e.type == TypeEcheance.declarationRevenus,
    );
    expect(declarations.single.date, DateTime(2027, 5, 20));
    await fermer(tester);
  });

  testWidgets("le détail s'ouvre au-dessus de la barre ; « Modifier »", (
    tester,
  ) async {
    await ouvrir(tester);
    await tester.tap(find.text('Déclaration des revenus fonciers'));
    await tester.pumpAndSettle();

    // Le panneau est ouvert au-dessus de la coque (barre + bouton « + »).
    expect(
      find.ancestor(
        of: find.byType(BottomSheet),
        matching: find.byType(ShellApp),
      ),
      findsNothing,
    );

    // Le bouton doit être touchable (pas caché par la barre ni le « + »).
    await tester.tap(find.text('Modifier'), warnIfMissed: true);
    await tester.pumpAndSettle();
    expect(find.text("Modifier l'échéance"), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Déclaration des revenus fonciers'),
      findsOneWidget,
    );
    await fermer(tester);
  });

  testWidgets('choix du bien à réviser : courte durée grisée', (tester) async {
    await ouvrir(tester);
    await tester.tap(find.text('Réviser un loyer'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Révision disponible uniquement pour les locations longue durée.',
      ),
      findsOneWidget,
    );
    expect(find.byIcon(AppIcons.verrou), findsOneWidget);
    await fermer(tester);
  });

  testWidgets('cloche : nombre d\'échéances urgentes', (tester) async {
    await ouvrir(tester);
    // Aucune échéance à 7 jours ou moins : pas de pastille.
    expect(find.byTooltip('Notifications'), findsOneWidget);
    await fermer(tester);
  });
}
