import 'package:bailleur_app/core/utils/dates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ajouterMois', () {
    test('reste dans le mois cible (fin de mois)', () {
      expect(
        Dates.ajouterMois(DateTime(2026, 1, 31), 1),
        DateTime(2026, 2, 28),
      );
      expect(
        Dates.ajouterMois(DateTime(2024, 1, 31), 1),
        DateTime(2024, 2, 29),
      );
      expect(
        Dates.ajouterMois(DateTime(2026, 3, 31), -1),
        DateTime(2026, 2, 28),
      );
    });

    test("change d'année", () {
      expect(
        Dates.ajouterMois(DateTime(2026, 11, 15), 3),
        DateTime(2027, 2, 15),
      );
      expect(
        Dates.ajouterMois(DateTime(2026, 2, 15), -3),
        DateTime(2025, 11, 15),
      );
      expect(Dates.ajouterMois(DateTime(2023, 9, 1), 36), DateTime(2026, 9, 1));
    });
  });

  test("joursEntre ignore les changements d'heure", () {
    expect(Dates.joursEntre(DateTime(2026, 3, 28), DateTime(2026, 3, 30)), 2);
    expect(Dates.joursEntre(DateTime(2026, 10, 24), DateTime(2026, 10, 26)), 2);
    expect(Dates.joursEntre(DateTime(2026, 9, 25), DateTime(2026, 9, 20)), -5);
  });

  group('prochaineOccurrence', () {
    test('premier terme après la date', () {
      expect(
        Dates.prochaineOccurrence(
          origine: DateTime(2023, 9, 1),
          pasMois: 12,
          aPartirDe: DateTime(2026, 9, 25),
        ),
        DateTime(2027, 9, 1),
      );
    });

    test('le jour même compte', () {
      expect(
        Dates.prochaineOccurrence(
          origine: DateTime(2023, 9, 1),
          pasMois: 12,
          aPartirDe: DateTime(2026, 9, 1),
        ),
        DateTime(2026, 9, 1),
      );
    });

    test("jamais l'origine elle-même", () {
      expect(
        Dates.prochaineOccurrence(
          origine: DateTime(2026, 9, 1),
          pasMois: 12,
          aPartirDe: DateTime(2026, 6, 1),
        ),
        DateTime(2027, 9, 1),
      );
    });

    test('29 février : pas de dérive au fil des années', () {
      final origine = DateTime(2024, 2, 29);
      expect(
        Dates.prochaineOccurrence(
          origine: origine,
          pasMois: 12,
          aPartirDe: DateTime(2026, 9, 25),
        ),
        DateTime(2027, 2, 28),
      );
      expect(
        Dates.prochaineOccurrence(
          origine: origine,
          pasMois: 12,
          aPartirDe: DateTime(2027, 3, 1),
        ),
        DateTime(2028, 2, 29),
      );
    });
  });

  test('prochaineDateAnnuelle', () {
    expect(
      Dates.prochaineDateAnnuelle(
        jour: 15,
        mois: 10,
        aPartirDe: DateTime(2026, 9, 25),
      ),
      DateTime(2026, 10, 15),
    );
    expect(
      Dates.prochaineDateAnnuelle(
        jour: 20,
        mois: 5,
        aPartirDe: DateTime(2026, 9, 25),
      ),
      DateTime(2027, 5, 20),
    );
  });
}
