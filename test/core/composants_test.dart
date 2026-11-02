import 'package:pense_bail/app/design/design.dart';
import 'package:pense_bail/core/widgets/composants.dart';
import 'package:pense_bail/core/widgets/listes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LigneInfo en grand texte (A4-02)', () {
    Future<void> afficher(WidgetTester tester, double echelle) =>
        tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.clair(),
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(echelle)),
              child: const Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 600,
                    child: LigneInfo(
                      libelle: 'Type de logement',
                      valeur: 'Appartement',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

    double haut(WidgetTester tester, String texte) =>
        tester.getTopLeft(find.text(texte)).dy;

    testWidgets('texte normal : libellé et valeur sur la même ligne', (
      tester,
    ) async {
      await afficher(tester, 1);
      expect(haut(tester, 'Appartement'), haut(tester, 'Type de logement'));
    });

    testWidgets('texte à 200 % : la valeur passe sous le libellé, entière', (
      tester,
    ) async {
      await afficher(tester, 2);
      expect(
        haut(tester, 'Appartement'),
        greaterThan(haut(tester, 'Type de logement')),
      );
      // Le mot n'est pas coupé : la valeur tient sur une seule ligne.
      final valeur = tester.renderObject<RenderParagraph>(
        find.text('Appartement'),
      );
      expect(valeur.didExceedMaxLines, isFalse);
      expect(
        valeur
            .getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: 11),
            )
            .map((b) => b.top)
            .toSet(),
        hasLength(1),
      );
      // Toujours un seul élément pour les lecteurs d'écran.
      expect(
        find.bySemanticsLabel('Type de logement : Appartement'),
        findsOneWidget,
      );
    });
  });

  Widget page(Widget enfant, {double echelle = 1}) => MaterialApp(
    theme: AppTheme.clair(),
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(400, 800),
        textScaler: TextScaler.linear(echelle),
      ),
      child: Scaffold(body: enfant),
    ),
  );

  testWidgets('puce de filtre : jamais plus large que le contenu (A4-08)', (
    tester,
  ) async {
    const nom =
        'Appartement du troisième étage de la résidence des Glycines, '
        'bâtiment B';
    await tester.pumpWidget(
      page(
        ListView(
          scrollDirection: Axis.horizontal,
          children: [PuceFiltre(libelle: nom, active: false, onTap: () {})],
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(PuceFiltre)).width,
      lessThanOrEqualTo(400 - 2 * AppSpacing.ecran),
    );
    // Le lecteur d'écran lit le nom complet.
    expect(find.bySemanticsLabel(nom), findsOneWidget);
  });

  testWidgets("barre d'action : texte plafonné en grand texte (A4-11)", (
    tester,
  ) async {
    await tester.pumpWidget(
      page(
        Align(
          alignment: Alignment.bottomCenter,
          child: BarreActionFixe(libelle: 'Réviser le loyer', onPressed: () {}),
        ),
        echelle: 2,
      ),
    );
    final texte = tester.renderObject<RenderParagraph>(
      find.text('Réviser le loyer'),
    );
    expect(texte.textScaler.scale(1), AppSizes.echelleTexteBarresMax);
  });

  testWidgets('chiffres en colonnes : empilés en grand texte (A4-02)', (
    tester,
  ) async {
    Future<void> afficher(double echelle) => tester.pumpWidget(
      page(
        SizedBox(
          width: 400,
          child: Builder(
            builder: (context) => ChiffresEnColonnes(
              styleValeur: context.textes.figure,
              styleLibelle: context.textes.caption,
              libelleSemantique: (v, l) => '$l : $v',
              chiffres: const [
                ('520 €', 'Loyer hors charges'),
                ('40 €', 'Charges'),
                ('01/11/2026', 'Prochaine révision'),
              ],
            ),
          ),
        ),
        echelle: echelle,
      ),
    );
    Offset coin(String texte) => tester.getTopLeft(find.text(texte));

    // Texte normal : trois colonnes.
    await afficher(1);
    expect(coin('Charges').dx, greaterThan(coin('Loyer hors charges').dx));
    expect(coin('Prochaine révision').dx, greaterThan(coin('Charges').dx));

    // Texte à 200 % : les uns sous les autres, alignés à gauche.
    await afficher(2);
    expect(coin('Charges').dx, coin('Loyer hors charges').dx);
    expect(coin('Charges').dy, greaterThan(coin('Loyer hors charges').dy));
    expect(coin('Prochaine révision').dy, greaterThan(coin('Charges').dy));
  });
}
