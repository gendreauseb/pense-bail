import 'package:bailleur_app/core/format/formats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Remplace les espaces insécables par des espaces simples.
String _espaces(String s) => s.replaceAll(RegExp('[\u00A0\u202F]'), ' ');

void main() {
  setUpAll(() => initializeDateFormatting(Formats.locale));

  test('montants à l\'écran : centimes seulement s\'ils sont non nuls', () {
    expect(_espaces(Formats.montant(123456)), '1 234,56 €');
    expect(_espaces(Formats.montant(66423)), '664,23 €');
    expect(_espaces(Formats.montant(65000)), '650 €');
    expect(_espaces(Formats.montant(115000)), '1 150 €');
    expect(_espaces(Formats.montant(0)), '0 €');
    expect(_espaces(Formats.parMois(62000)), '620 € / mois');
    expect(_espaces(Formats.montantArrondi(123456)), '1 235 €');
  });

  test('montants des courriers : toujours les centimes', () {
    expect(_espaces(Formats.montantComplet(65000)), '650,00 €');
  });

  test('aucune espace fine (absente des polices embarquées)', () {
    for (final texte in [
      Formats.montant(123456),
      Formats.montantComplet(123456),
      Formats.montantArrondi(123456),
    ]) {
      expect(texte.contains('\u202F'), isFalse, reason: texte);
    }
  });

  test('dates au format JJ/MM/AAAA', () {
    expect(Formats.date(DateTime(2026, 9, 5)), '05/09/2026');
    expect(Formats.dateLongue(DateTime(2026, 9, 5)), '5 septembre 2026');
  });

  test('saisie de montants', () {
    expect(Formats.parseMontant('1 234,56'), 123456);
    expect(Formats.parseMontant('1234.5'), 123450);
    expect(Formats.parseMontant('650 €'), 65000);
    expect(Formats.parseMontant('1\u202F234,56\u00A0€'), 123456);
    expect(Formats.parseMontant(''), isNull);
    expect(Formats.parseMontant('abc'), isNull);
    expect(Formats.parseMontant('-12'), isNull);
  });

  test('saisie décimale (IRL, surface)', () {
    expect(Formats.parseDecimal('145,17'), 145.17);
    expect(Formats.parseDecimal('32'), 32);
  });
}
