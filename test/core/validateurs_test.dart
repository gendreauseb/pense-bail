import 'package:bailleur_app/core/validation/validateurs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('téléphone', () {
    test('formats acceptés, normalisés', () {
      for (final saisie in [
        '0612345678',
        '06 12 34 56 78',
        '06.12.34.56.78',
        '06-12-34-56-78',
        '+33 6 12 34 56 78',
        '+33612345678',
        '0033612345678',
      ]) {
        expect(
          Validateurs.normaliserTelephone(saisie),
          '06 12 34 56 78',
          reason: saisie,
        );
      }
      expect(
        Validateurs.normaliserTelephone('01 45 67 89 10'),
        '01 45 67 89 10',
      );
    });

    test('formats refusés', () {
      for (final saisie in [
        '061234567',
        '06123456789',
        '00 12 34 56 78',
        'abc',
      ]) {
        expect(Validateurs.normaliserTelephone(saisie), isNull, reason: saisie);
      }
    });

    test('facultatif si vide', () {
      expect(Validateurs.telephone(''), isNull);
      expect(Validateurs.telephone('', obligatoire: true), isNotNull);
      expect(Validateurs.telephone('12'), isNotNull);
    });
  });

  test('email', () {
    expect(Validateurs.email('prenom.nom@email.fr'), isNull);
    expect(Validateurs.email(' a@b.co '), isNull);
    expect(Validateurs.email(''), isNull);
    for (final saisie in ['prenom', 'a@b', 'a@b.c', 'a b@c.fr', '@email.fr']) {
      expect(Validateurs.email(saisie), isNotNull, reason: saisie);
    }
  });

  test('code postal', () {
    for (final cp in ['75011', '01000', '20000', '97400', '98000']) {
      expect(Validateurs.codePostal(cp), isNull, reason: cp);
    }
    for (final cp in ['', '7501', '750111', '00100', '99000', '75A11']) {
      expect(Validateurs.codePostal(cp), isNotNull, reason: cp);
    }
  });
}
