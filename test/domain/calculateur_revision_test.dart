import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/services/calculateur_revision.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  // Indices FICTIFS, utilisés uniquement pour tester la formule.
  group('nouveauLoyer', () {
    test('loyer × nouvel IRL / ancien IRL, arrondi au centime', () {
      // 650 × 145,17 / 142,06 = 664,2299... → 664,23
      expect(
        CalculateurRevision.nouveauLoyer(
          loyerActuelCentimes: 65000,
          ancienIrl: 142.06,
          nouvelIrl: 145.17,
        ),
        66423,
      );
    });

    test('un demi-centime est arrondi au-dessus', () {
      // 1,00 × 101 / 200 = 0,505 → 0,51
      expect(
        CalculateurRevision.nouveauLoyer(
          loyerActuelCentimes: 100,
          ancienIrl: 200,
          nouvelIrl: 101,
        ),
        51,
      );
    });

    test("pas d'erreur d'arrondi des nombres à virgule", () {
      expect(
        CalculateurRevision.nouveauLoyer(
          loyerActuelCentimes: 80000,
          ancienIrl: 130.12,
          nouvelIrl: 130.12,
        ),
        80000,
      );
    });

    test('indice nul refusé', () {
      expect(
        () => CalculateurRevision.nouveauLoyer(
          loyerActuelCentimes: 100,
          ancienIrl: 0,
          nouvelIrl: 101,
        ),
        throwsArgumentError,
      );
    });
  });

  test('nouvel IRL : même trimestre, année suivante', () {
    final t = CalculateurRevision.trimestreNouvelIrl(
      trimestreReference: 2,
      anneeReference: 2025,
    );
    expect(t.trimestre, 2);
    expect(t.annee, 2026);
  });

  group('blocages', () {
    final bail = unBail(debut: DateTime(2024, 1, 1));

    test('longue durée, bail vide, DPE D : autorisé', () {
      expect(
        CalculateurRevision.blocages(unBien(classeDpe: ClasseDpe.d), bail),
        isEmpty,
      );
    });

    test('DPE F ou G : révision interdite', () {
      expect(
        CalculateurRevision.blocages(unBien(classeDpe: ClasseDpe.f), bail),
        [BlocageRevision.dpeGel],
      );
      expect(
        CalculateurRevision.blocages(unBien(classeDpe: ClasseDpe.g), bail),
        [BlocageRevision.dpeGel],
      );
    });

    test('hors longue durée', () {
      expect(
        CalculateurRevision.blocages(
          unBien(typeLocation: TypeLocation.courteDuree),
          null,
        ),
        [BlocageRevision.pasLongueDuree, BlocageRevision.pasDeBail],
      );
    });

    test('bail mobilité', () {
      expect(
        CalculateurRevision.blocages(
          unBien(),
          unBail(typeBail: TypeBail.mobilite, debut: DateTime(2026, 1, 1)),
        ),
        [BlocageRevision.bailSansRevision],
      );
    });
  });
}
