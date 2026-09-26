import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/services/rentabilite.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

MouvementFinancier _mvt(
  String id,
  DateTime date,
  int montant,
  CategorieMouvement categorie,
) => MouvementFinancier(
  id: id,
  bienId: 'bien-1',
  date: date,
  montantCentimes: montant,
  categorie: categorie,
  creeLe: date,
  modifieLe: date,
);

void main() {
  group('indicateurs', () {
    test('sans données d\'investissement : pas de rendement', () {
      final i = Rentabilite.indicateurs(unBien(loyerHcCentimes: 65000));
      expect(i.loyersAnnuels, 780000);
      expect(i.chargesAnnuelles, 0);
      expect(i.cashFlowMensuel, 65000);
      expect(i.cashFlowAnnuel, 780000);
      expect(i.rendementBrut, isNull);
      expect(i.rendementNet, isNull);
    });

    test('rendements brut et net, cash-flow après crédit et charges', () {
      final bien = unBien(loyerHcCentimes: 65000).copyWith(
        prixAchatCentimes: 12000000, // 120 000 €
        fraisNotaireCentimes: 900000, // 9 000 €
        travauxInitiauxCentimes: 1100000, // 11 000 €
        mensualiteCreditCentimes: 45000, // 450 €
        taxeFonciereCentimes: 80000, // 800 €
        assuranceCentimes: 15000, // 150 €
        chargesNonRecuperablesCentimes: 25000, // 250 €
      );
      final i = Rentabilite.indicateurs(bien);

      expect(i.coutAcquisition, 14000000); // 140 000 €
      expect(i.chargesAnnuelles, 120000); // 1 200 €
      expect(i.creditAnnuel, 540000); // 5 400 €
      // 7 800 € de loyers / 140 000 € = 5,57 %
      expect(i.rendementBrut, closeTo(0.05571, 0.00001));
      // (7 800 − 1 200) / 140 000 = 4,71 %
      expect(i.rendementNet, closeTo(0.04714, 0.00001));
      // (7 800 − 1 200 − 5 400) / 12 = 100 €
      expect(i.cashFlowMensuel, 10000);
    });
  });

  test('bilan annuel : loyers cochés + journal de l\'année', () {
    final bilan = Rentabilite.bilan(
      bien: unBien(loyerHcCentimes: 65000),
      annee: 2026,
      encaissements: [
        for (var m = 1; m <= 8; m++)
          EncaissementLoyer(bienId: 'bien-1', annee: 2026, mois: m, recu: true),
        const EncaissementLoyer(
          bienId: 'bien-1',
          annee: 2026,
          mois: 9,
          recu: false,
        ),
        const EncaissementLoyer(
          bienId: 'bien-1',
          annee: 2025,
          mois: 12,
          recu: true,
        ),
      ],
      mouvements: [
        _mvt('a', DateTime(2026, 3, 1), 12000, CategorieMouvement.intervention),
        _mvt('b', DateTime(2026, 6, 1), 5000, CategorieMouvement.autreRecette),
        _mvt('c', DateTime(2025, 6, 1), 99900, CategorieMouvement.travaux),
      ],
    );
    expect(bilan.moisRecus, 8);
    expect(bilan.loyersPercus, 520000);
    expect(bilan.autresRecettes, 5000);
    expect(bilan.depenses, 12000);
    expect(bilan.resultat, 513000);
  });

  group('mois en retard', () {
    final aujourdhui = DateTime(2026, 9, 25);

    test('mois écoulés non cochés, après le début du bail', () {
      final retard = Rentabilite.moisEnRetard(
        annee: 2026,
        encaissements: [
          for (final m in [3, 4, 6])
            EncaissementLoyer(
              bienId: 'bien-1',
              annee: 2026,
              mois: m,
              recu: true,
            ),
        ],
        aujourdhui: aujourdhui,
        debutBail: DateTime(2026, 3, 1),
      );
      // Septembre (mois en cours) n'est pas encore en retard.
      expect(retard, [5, 7, 8]);
    });

    test('année future : aucun retard', () {
      expect(
        Rentabilite.moisEnRetard(
          annee: 2027,
          encaissements: const [],
          aujourdhui: aujourdhui,
        ),
        isEmpty,
      );
    });
  });

  group('loyer en vigueur chaque mois', () {
    final revision = RevisionLoyer(
      id: 'r1',
      bienId: 'bien-1',
      bailId: 'bail-1',
      dateEffet: DateTime(2026, 9, 1),
      ancienLoyerCentimes: 65000,
      nouveauLoyerCentimes: 65749,
      ancienIrlTrimestre: 2,
      ancienIrlAnnee: 2025,
      ancienIrlValeur: 146.68,
      nouvelIrlTrimestre: 2,
      nouvelIrlAnnee: 2026,
      nouvelIrlValeur: 148.37,
      creeLe: DateTime(2026, 8, 10),
    );
    final bien = unBien(loyerHcCentimes: 65749);

    int loyer(int mois, List<RevisionLoyer> revisions) =>
        Rentabilite.loyerDuMois(
          bien: bien,
          revisions: revisions,
          annee: 2026,
          mois: mois,
        );

    test("avant et après la révision", () {
      expect(loyer(8, [revision]), 65000);
      expect(loyer(9, [revision]), 65749);
      expect(loyer(8, const []), 65749, reason: 'sans révision : loyer actuel');
    });

    test("bilan : chaque mois reçu au loyer de l'époque", () {
      final bilan = Rentabilite.bilan(
        bien: bien,
        annee: 2026,
        encaissements: const [
          EncaissementLoyer(bienId: 'bien-1', annee: 2026, mois: 8, recu: true),
          EncaissementLoyer(bienId: 'bien-1', annee: 2026, mois: 9, recu: true),
        ],
        mouvements: const [],
        revisions: [revision],
      );
      expect(bilan.loyersPercus, 65000 + 65749);
    });

    test('totaux par catégorie', () {
      final totaux = Rentabilite.totauxParCategorie(
        annee: 2026,
        mouvements: [
          _mvt('a', DateTime(2026, 2, 1), 100, CategorieMouvement.assurance),
          _mvt('b', DateTime(2026, 5, 1), 50, CategorieMouvement.assurance),
          _mvt('c', DateTime(2025, 5, 1), 70, CategorieMouvement.travaux),
        ],
      );
      expect(totaux, {CategorieMouvement.assurance: 150});
    });
  });
}
