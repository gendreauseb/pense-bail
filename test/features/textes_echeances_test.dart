import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/features/echeances/textes_echeances.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  group('fin de bail', () {
    // Bail vide du 15/10/2023 : fin le 14/10/2026, congé à recevoir au plus
    // tard le 14/04/2026.
    final bail = unBail(debut: DateTime(2023, 10, 15));
    final fin = DateTime(2026, 10, 14);

    test('délai de congé encore ouvert : texte général', () {
      final texte = explicationEcheance(
        TypeEcheance.finBail,
        bail: bail,
        date: fin,
        aujourdhui: DateTime(2026, 3, 1),
      );
      expect(texte, startsWith('Fin de la période en cours du bail. Sans'));
    });

    test("délai de congé passé : le bail sera reconduit", () {
      final texte = explicationEcheance(
        TypeEcheance.finBail,
        bail: bail,
        date: fin,
        aujourdhui: DateTime(2026, 10, 6),
      )!;
      expect(texte, contains('(14/04/2026) est passée'));
      expect(texte, contains('sera reconduit'));
      expect(texte, isNot(contains('Sans congé')));
    });

    test('bail mobilité : pas de reconduction', () {
      final texte = explicationEcheance(
        TypeEcheance.finBail,
        bail: unBail(
          typeBail: TypeBail.mobilite,
          debut: DateTime(2026, 6, 1),
          dureeMois: 6,
        ),
        date: DateTime(2026, 11, 30),
        aujourdhui: DateTime(2026, 10, 6),
      )!;
      expect(texte, contains("n'est pas reconduit"));
    });
  });
}
