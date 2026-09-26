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

  group('cycle', () {
    // Bail du 01/09/2023 : révision chaque 1er septembre.
    final bail = unBail(debut: DateTime(2023, 9, 1));

    test('avant la date prévue : révision de cette année, à la date', () {
      final c = CalculateurRevision.cycle(
        bail,
        aujourdhui: DateTime(2026, 8, 10),
        derniereDateEffet: DateTime(2025, 9, 1),
      )!;
      expect(c.datePrevue, DateTime(2026, 9, 1));
      expect(c.enRetard, isFalse);
      expect(c.dateEffet, DateTime(2026, 9, 1));
    });

    test("en retard de moins d'un an : effet à la date de la demande", () {
      final c = CalculateurRevision.cycle(
        bail,
        aujourdhui: DateTime(2026, 9, 25),
      )!;
      expect(c.datePrevue, DateTime(2026, 9, 1));
      expect(c.enRetard, isTrue);
      expect(c.dateEffet, DateTime(2026, 9, 25));
      expect(c.dateLimiteDemande, DateTime(2027, 8, 31));
    });

    test('déjà révisé cette année : révision suivante', () {
      final c = CalculateurRevision.cycle(
        bail,
        aujourdhui: DateTime(2026, 9, 25),
        derniereDateEffet: DateTime(2026, 9, 10),
      )!;
      expect(c.datePrevue, DateTime(2027, 9, 1));
    });

    test("plus d'un an de retard : l'année est perdue", () {
      final c = CalculateurRevision.cycle(
        bail,
        aujourdhui: DateTime(2026, 9, 2),
        derniereDateEffet: DateTime(2024, 9, 1),
      )!;
      // La révision du 01/09/2025 n'a pas été demandée avant le 31/08/2026.
      expect(c.datePrevue, DateTime(2026, 9, 1));
    });

    test("IRL de référence déjà à jour : révision de l'an dernier faite", () {
      final aJour = bail.copyWith(
        irlTrimestre: 2,
        irlAnnee: 2025,
        irlValeur: 146.68,
      );
      final sansInfo = CalculateurRevision.cycle(
        bail,
        aujourdhui: DateTime(2026, 8, 10),
      )!;
      // Sans information : la révision du 01/09/2025 peut encore être
      // demandée (en retard).
      expect(sansInfo.datePrevue, DateTime(2025, 9, 1));
      expect(
        CalculateurRevision.cycle(
          aJour,
          aujourdhui: DateTime(2026, 8, 10),
        )!.datePrevue,
        DateTime(2026, 9, 1),
      );
    });

    test('pas de révision avant un an de bail', () {
      final c = CalculateurRevision.cycle(
        unBail(debut: DateTime(2026, 3, 1)),
        aujourdhui: DateTime(2026, 9, 25),
      )!;
      expect(c.datePrevue, DateTime(2027, 3, 1));
    });
  });

  group('indice à utiliser', () {
    test('dernier IRL du trimestre publié à la date prévue', () {
      // T2 publié mi-juillet : au 01/09/2026, c'est le T2 2026.
      expect(
        CalculateurRevision.anneeDernierIndice(
          trimestre: 2,
          date: DateTime(2026, 9, 1),
        ),
        2026,
      );
      // T3 publié mi-octobre : au 01/09/2026, c'est encore le T3 2025.
      expect(
        CalculateurRevision.anneeDernierIndice(
          trimestre: 3,
          date: DateTime(2026, 9, 1),
        ),
        2025,
      );
      // T4 publié mi-janvier de l'année suivante.
      expect(
        CalculateurRevision.anneeDernierIndice(
          trimestre: 4,
          date: DateTime(2026, 1, 10),
        ),
        2024,
      );
    });

    test('trimestre par défaut : dernier publié à la signature', () {
      final t = CalculateurRevision.dernierTrimestrePublie(
        DateTime(2023, 9, 1),
      );
      expect((t.trimestre, t.annee), (2, 2023));
      final u = CalculateurRevision.dernierTrimestrePublie(
        DateTime(2024, 1, 5),
      );
      expect((u.trimestre, u.annee), (3, 2023));
    });

    test('compare deux années consécutives, jamais un indice plus ancien', () {
      const table = [
        IndiceIrl(
          annee: 2026,
          trimestre: 2,
          valeur: 148.37,
          source: SourceIndice.insee,
        ),
        IndiceIrl(
          annee: 2025,
          trimestre: 2,
          valeur: 146.68,
          source: SourceIndice.insee,
        ),
        IndiceIrl(
          annee: 2024,
          trimestre: 2,
          valeur: 145.17,
          source: SourceIndice.insee,
        ),
        IndiceIrl(
          annee: 2026,
          trimestre: 1,
          valeur: 146.6,
          source: SourceIndice.insee,
        ),
      ];
      final i = CalculateurRevision.indices(
        trimestre: 2,
        annee: 2026,
        table: table,
      );
      expect(i.ancien!.valeur, 146.68);
      expect(i.nouveau!.valeur, 148.37);
      expect(i.complets, isTrue);

      final manquant = CalculateurRevision.indices(
        trimestre: 3,
        annee: 2026,
        table: table,
      );
      expect(manquant.complets, isFalse);
    });

    test('résultat avec les indices INSEE du 2e trimestre 2025 et 2026', () {
      final r = CalculateurRevision.calculer(
        cycle: CycleRevision(
          datePrevue: DateTime(2026, 9, 1),
          aujourdhui: DateTime(2026, 8, 1),
        ),
        ancien: const IndiceIrl(
          annee: 2025,
          trimestre: 2,
          valeur: 146.68,
          source: SourceIndice.insee,
        ),
        nouveau: const IndiceIrl(
          annee: 2026,
          trimestre: 2,
          valeur: 148.37,
          source: SourceIndice.insee,
        ),
        loyerActuelCentimes: 65000,
        chargesCentimes: 5000,
      );
      // 650 × 148,37 / 146,68 = 657,4890... → 657,49
      expect(r.nouveauLoyerCentimes, 65749);
      expect(r.augmentationMensuelleCentimes, 749);
      expect(r.augmentationAnnuelleCentimes, 8988);
      expect(r.nouveauTotalCentimes, 70749);
      expect(r.baisse, isFalse);
    });
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
