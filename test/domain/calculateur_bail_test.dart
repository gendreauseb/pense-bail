import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/calculateur_bail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  final aujourdhui = DateTime(2026, 9, 25);

  group('Location vide (3 ans, congé 6 mois)', () {
    test('bail reconduit tacitement', () {
      final bail = unBail(debut: DateTime(2023, 9, 1));
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2029, 8, 31),
      );
      expect(
        CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui),
        DateTime(2029, 2, 28),
      );
      expect(
        CalculateurBail.prochaineRevision(bail, aujourdhui),
        DateTime(2027, 9, 1),
      );
    });

    test('bail en cours', () {
      final bail = unBail(debut: DateTime(2025, 1, 1));
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2027, 12, 31),
      );
      expect(
        CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui),
        DateTime(2027, 6, 30),
      );
      expect(
        CalculateurBail.prochaineRevision(bail, aujourdhui),
        DateTime(2027, 1, 1),
      );
    });

    test('exemple de référence : fin au 31/08, congé au 28/02', () {
      expect(
        CalculateurBail.dateLimiteConge(DateTime(2026, 8, 31), 6),
        DateTime(2026, 2, 28),
      );
    });
  });

  group('Location meublée (1 an, congé 3 mois)', () {
    test('date limite de congé à venir', () {
      final bail = unBail(
        typeBail: TypeBail.meuble,
        debut: DateTime(2026, 3, 15),
      );
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2027, 3, 14),
      );
      expect(
        CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui),
        DateTime(2026, 12, 14),
      );
      expect(
        CalculateurBail.prochaineRevision(bail, aujourdhui),
        DateTime(2027, 3, 15),
      );
    });

    test('date limite dépassée : on passe à la période suivante', () {
      final bail = unBail(
        typeBail: TypeBail.meuble,
        debut: DateTime(2025, 10, 15),
      );
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2026, 10, 14),
      );
      expect(
        CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui),
        DateTime(2027, 7, 14),
      );
    });
  });

  test('bail mobilité : ni congé bailleur, ni révision', () {
    final bail = unBail(
      typeBail: TypeBail.mobilite,
      debut: DateTime(2026, 6, 1),
      dureeMois: 6,
    );
    expect(
      CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
      DateTime(2026, 11, 30),
    );
    expect(CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui), isNull);
    expect(CalculateurBail.prochaineRevision(bail, aujourdhui), isNull);
  });

  test('bail mobilité sans durée saisie : fin inconnue', () {
    final bail = unBail(
      typeBail: TypeBail.mobilite,
      debut: DateTime(2026, 6, 1),
    );
    expect(CalculateurBail.finPeriodeEnCours(bail, aujourdhui), isNull);
  });

  group('Location saisonnière (A2-09)', () {
    test('fin au terme saisi, ni congé du bailleur, ni révision', () {
      final bail = unBail(
        typeBail: TypeBail.saisonnier,
        debut: DateTime(2026, 7, 1),
        dureeMois: 2,
      );
      // Pas de reconduction : le terme reste le même, même passé.
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2026, 8, 31),
      );
      expect(CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui), isNull);
      expect(CalculateurBail.prochaineRevision(bail, aujourdhui), isNull);
    });

    test('sans durée saisie : fin inconnue', () {
      final bail = unBail(
        typeBail: TypeBail.saisonnier,
        debut: DateTime(2026, 7, 1),
      );
      expect(CalculateurBail.finPeriodeEnCours(bail, aujourdhui), isNull);
    });
  });

  group('Bail professionnel (6 ans, congé 6 mois) (A2-09)', () {
    test('reconduit par périodes de 6 ans, sans révision IRL', () {
      final bail = unBail(
        typeBail: TypeBail.professionnel,
        debut: DateTime(2019, 1, 1),
      );
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2030, 12, 31),
      );
      expect(
        CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui),
        DateTime(2030, 6, 30),
      );
      // Le loyer suit l'indice prévu au contrat, que l'app ne calcule pas.
      expect(CalculateurBail.prochaineRevision(bail, aujourdhui), isNull);
    });
  });

  group('Bail commercial (9 ans, congé 6 mois) (A2-09)', () {
    test('en cours : fin à 9 ans, congé 6 mois avant, sans révision IRL', () {
      final bail = unBail(
        typeBail: TypeBail.commercial,
        debut: DateTime(2020, 4, 1),
      );
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2029, 3, 31),
      );
      expect(
        CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui),
        DateTime(2028, 9, 30),
      );
      expect(CalculateurBail.prochaineRevision(bail, aujourdhui), isNull);
    });

    test('terme passé : prolongé sans durée fixe, seule la première fin '
        'est connue', () {
      final bail = unBail(
        typeBail: TypeBail.commercial,
        debut: DateTime(2015, 1, 1),
      );
      expect(
        CalculateurBail.finPeriodeEnCours(bail, aujourdhui),
        DateTime(2023, 12, 31),
      );
    });
  });

  test('date de révision prévue au bail', () {
    final bail = unBail(
      typeBail: TypeBail.meuble,
      debut: DateTime(2026, 3, 15),
      dateRevision: DateTime(2026, 1, 1),
    );
    expect(
      CalculateurBail.prochaineRevision(bail, aujourdhui),
      DateTime(2027, 1, 1),
    );
  });
}
