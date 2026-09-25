import 'package:bailleur_app/domain/services/proximite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final aujourdhui = DateTime(2026, 9, 25);
  DateTime dans(int jours) =>
      DateTime(aujourdhui.year, aujourdhui.month, aujourdhui.day + jours);

  test('4 statuts : bornes strictes de UI.md', () {
    expect(Proximite.depuisJours(-3), Proximite.urgent);
    expect(Proximite.depuisJours(0), Proximite.urgent);
    expect(Proximite.depuisJours(7), Proximite.urgent);
    expect(Proximite.depuisJours(8), Proximite.bientot);
    expect(Proximite.depuisJours(30), Proximite.bientot);
    expect(Proximite.depuisJours(31), Proximite.aVenir);
    expect(Proximite.depuisJours(90), Proximite.aVenir);
    expect(Proximite.depuisJours(91), Proximite.lointain);
  });

  group('texte de la pastille', () {
    String texte(DateTime d, {bool dense = true}) =>
        textePastille(d, aujourdhui: aujourdhui, dense: dense);

    test('jours, dense ou dans une fiche', () {
      expect(texte(dans(4)), '4 j');
      expect(texte(dans(4), dense: false), 'Dans 4 j');
      expect(texte(dans(90)), '90 j');
    });

    test('dépassée et aujourd\'hui', () {
      expect(texte(dans(-1)), 'En retard');
      expect(texte(dans(0)), 'Aujourd\'hui');
    });

    test('mois au-delà de 90 jours', () {
      expect(texte(dans(91)), '3 mois');
      expect(texte(DateTime(2027, 3, 25)), '6 mois');
      expect(texte(DateTime(2027, 3, 24), dense: false), 'Dans 5 mois');
    });

    test('année au-delà de 18 mois', () {
      expect(texte(DateTime(2028, 3, 25)), '18 mois');
      expect(texte(DateTime(2028, 3, 26)), '2028');
      expect(texte(DateTime(2029, 8, 31)), '2029');
    });
  });
}
