import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  test('sans complément', () {
    final bien = unBien();
    expect(bien.adresseComplete, '12 rue Gambetta, 75020 Paris');
    expect(bien.lignesAdresse, ['12 rue Gambetta', '75020 Paris']);
  });

  test(
    'avec complément : après la voie sur une ligne, avant sur un courrier',
    () {
      final bien = unBien().copyWith(
        complementAdresse: 'Résidence Les Pins, bât. B, apt 12',
      );
      expect(
        bien.adresseComplete,
        '12 rue Gambetta, Résidence Les Pins, bât. B, apt 12, 75020 Paris',
      );
      expect(bien.lignesAdresse, [
        'Résidence Les Pins, bât. B, apt 12',
        '12 rue Gambetta',
        '75020 Paris',
      ]);
      // Le complément peut être retiré.
      expect(
        bien.copyWith(complementAdresse: null).lignesAdresse,
        hasLength(2),
      );
    },
  );

  test('complément vide ou blanc ignoré', () {
    expect(
      lignesAdressePostale(
        rue: '1 place de la Mairie',
        complement: '  ',
        codePostal: '69001',
        ville: 'Lyon',
      ),
      ['1 place de la Mairie', '69001 Lyon'],
    );
  });
}
