import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/acces_biens.dart';
import 'package:pense_bail/domain/services/rentabilite.dart';
import 'package:pense_bail/domain/services/sortie_bien.dart';
import 'package:pense_bail/domain/usecases/gestion_biens.dart';
import 'package:pense_bail/domain/usecases/gestion_echeances.dart';
import 'package:pense_bail/domain/usecases/verrou_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

/// Biens vendus ou retirés de la location.
void main() {
  final t = DateTime(2026, 9, 25);

  Echeance echeance(
    TypeEcheance type, {
    String id = 'e',
    DateTime? date,
    StatutEcheance statut = StatutEcheance.aFaire,
    int? intervalleMois,
  }) => Echeance(
    id: id,
    bienId: 'bien-1',
    type: type,
    titre: type.libelle,
    date: date ?? DateTime(2027, 3, 1),
    statut: statut,
    intervalleMois: intervalleMois,
    automatique: false,
    creeLe: t,
    modifieLe: t,
  );

  group('échéances arrêtées', () {
    final vendu = unBien().copyWith(
      venduLe: DateTime(2026, 6, 30),
      venduLoue: true,
    );
    final venduLibre = vendu.copyWith(venduLoue: false);
    final retire = unBien().copyWith(retireLe: DateTime(2026, 6, 30));

    bool arretee(Bien bien, TypeEcheance type, {DateTime? date}) =>
        SortieBien.doitEtreArretee(echeance(type, date: date), bien);

    test('bien en location : aucune', () {
      for (final type in TypeEcheance.values) {
        expect(arretee(unBien(), type), isFalse, reason: type.name);
      }
    });

    test('vente : bail, assurance, chaudière, diagnostics', () {
      for (final type in [
        TypeEcheance.revisionLoyer,
        TypeEcheance.finBail,
        TypeEcheance.dateLimiteConge,
        TypeEcheance.assurancePno,
        TypeEcheance.entretienChaudiere,
        TypeEcheance.diagnostic,
      ]) {
        expect(arretee(vendu, type), isTrue, reason: type.name);
      }
      expect(arretee(vendu, TypeEcheance.personnalisee), isFalse);
    });

    test("vente : taxe foncière de l'année gardée, les suivantes arrêtées", () {
      expect(
        arretee(vendu, TypeEcheance.taxeFonciere, date: DateTime(2026, 10, 15)),
        isFalse,
      );
      expect(
        arretee(vendu, TypeEcheance.taxeFonciere, date: DateTime(2027, 10, 15)),
        isTrue,
      );
    });

    test('vente : régularisation arrêtée si loué, gardée si libre', () {
      expect(arretee(vendu, TypeEcheance.regularisationCharges), isTrue);
      expect(arretee(venduLibre, TypeEcheance.regularisationCharges), isFalse);
    });

    test('retrait : seules révision, fin de bail et congé', () {
      for (final type in TypeEcheance.values) {
        expect(
          arretee(retire, type),
          {
            TypeEcheance.revisionLoyer,
            TypeEcheance.finBail,
            TypeEcheance.dateLimiteConge,
          }.contains(type),
          reason: type.name,
        );
      }
    });

    test('liste avant confirmation : échéances à faire seulement', () {
      final liste = SortieBien.aArreter(retire, [
        echeance(TypeEcheance.finBail, id: 'fin'),
        echeance(
          TypeEcheance.revisionLoyer,
          id: 'faite',
          statut: StatutEcheance.faite,
        ),
        echeance(TypeEcheance.assurancePno, id: 'pno'),
      ]);
      expect(liste.map((e) => e.id), ['fin']);
    });
  });

  group('accès', () {
    final ancien = unBien(id: 'ancien', creeLe: DateTime(2025));
    final recent = unBien(id: 'recent', creeLe: DateTime(2026));

    test('un bien vendu ou retiré ne compte pas dans la limite', () {
      final vendu = ancien.copyWith(venduLe: DateTime(2026, 6, 1));
      expect(AccesBiens.actifs([vendu, recent], Droits.gratuit), {'recent'});
      expect(AccesBiens.peutAjouter([vendu], Droits.gratuit), isTrue);
      // Jamais modifiable, même en Premium.
      expect(AccesBiens.actifs([vendu, recent], Droits.premium), {'recent'});
    });

    test('remettre en location un bien plus ancien : prévenu', () {
      final retire = ancien.copyWith(retireLe: DateTime(2026, 6, 1));
      final biens = [retire, recent];
      expect(
        AccesBiens.perdraientAcces(
          biens,
          retire,
          Droits.gratuit,
        ).map((b) => b.id),
        ['recent'],
      );
      expect(AccesBiens.perdraientAcces(biens, retire, Droits.premium), []);
    });
  });

  group('cas d\'usage', () {
    late AppDatabase db;
    late GestionBiens gestion;
    late DriftEcheanceRepository echeances;
    var droits = Droits.premium;

    setUp(() async {
      db = baseDeTest();
      droits = Droits.premium;
      echeances = DriftEcheanceRepository(db);
      gestion = GestionBiens(
        transactions: DriftTransactions(db),
        biens: DriftBienRepository(db),
        baux: DriftBailRepository(db),
        echeances: echeances,
        droits: () async => droits,
      );
      await gestion.creer(
        bien: unBien(),
        bail: unBail(debut: DateTime(2023, 9, 1)),
        aujourdhui: t,
      );
    });
    tearDown(() => db.close());

    Future<Map<TypeEcheance, StatutEcheance>> statuts() async => {
      for (final e in await echeances.parBien('bien-1')) e.type: e.statut,
    };

    test('vente puis annulation : échéances arrêtées puis rétablies', () async {
      final avant = await statuts();
      expect(avant.values.toSet(), {StatutEcheance.aFaire});

      await gestion.declarerVente(
        bienId: 'bien-1',
        date: DateTime(2026, 9, 30),
        prixCentimes: 25000000,
        loue: true,
      );
      final bien = (await DriftBienRepository(db).parId('bien-1'))!;
      expect(
        (bien.vendu, bien.prixVenteCentimes, bien.venduLoue),
        (true, 25000000, true),
      );
      // Taxe foncière de l'année de la vente gardée ; le reste arrêté
      // (régularisation comprise : vendu loué).
      final pendant = await statuts();
      expect(pendant.keys, containsAll(avant.keys));
      for (final MapEntry(key: type, value: statut) in pendant.entries) {
        expect(
          statut,
          type == TypeEcheance.taxeFonciere
              ? StatutEcheance.aFaire
              : StatutEcheance.arretee,
          reason: type.name,
        );
      }
      expect((await echeances.aFaire()).map((e) => e.type), [
        TypeEcheance.taxeFonciere,
      ]);

      await gestion.annulerVente('bien-1');
      expect(await statuts(), avant);
      expect(
        (await DriftBienRepository(db).parId('bien-1'))!.enLocation,
        isTrue,
      );
    });

    test('retrait puis remise en location', () async {
      final avant = await statuts();
      await gestion.retirerDeLaLocation(bienId: 'bien-1', date: t);
      final pendant = await statuts();
      expect(pendant[TypeEcheance.finBail], StatutEcheance.arretee);
      expect(
        pendant[TypeEcheance.regularisationCharges],
        StatutEcheance.aFaire,
      );

      await gestion.remettreEnLocation('bien-1');
      expect(await statuts(), avant);
    });

    test('vente d\'un bien retiré, annulée : de nouveau retiré', () async {
      await gestion.retirerDeLaLocation(bienId: 'bien-1', date: t);
      await gestion.declarerVente(bienId: 'bien-1', date: t, loue: false);
      await gestion.annulerVente('bien-1');
      final bien = (await DriftBienRepository(db).parId('bien-1'))!;
      expect(bien.retire, isTrue);
      expect((await statuts())[TypeEcheance.finBail], StatutEcheance.arretee);
    });

    test('bien vendu : plus modifiable, même en Premium', () async {
      await gestion.declarerVente(bienId: 'bien-1', date: t, loue: false);
      await expectLater(
        gestion.modifier(
          bien: unBien(nom: 'Autre'),
          aujourdhui: t,
        ),
        throwsA(isA<BienHorsLocation>().having((r) => r.vendu, 'vendu', true)),
      );
    });

    test(
      "taxe foncière faite après la vente : l'année suivante arrêtée",
      () async {
        final taxe = echeance(
          TypeEcheance.taxeFonciere,
          id: 'taxe',
          date: DateTime(2026, 10, 15),
          intervalleMois: 12,
        );
        await echeances.enregistrer(taxe);
        await gestion.declarerVente(bienId: 'bien-1', date: t, loue: false);
        expect((await echeances.parId('taxe'))!.estAFaire, isTrue);

        final suivante = await GestionEcheances(
          transactions: DriftTransactions(db),
          echeances: echeances,
          verrou: VerrouBiens(
            biens: DriftBienRepository(db),
            droits: () async => droits,
          ),
        ).marquerFaite(taxe, aujourdhui: t);
        expect(suivante!.date, DateTime(2027, 10, 15));
        expect(suivante.statut, StatutEcheance.arretee);
      },
    );
  });

  group('bilan de vente', () {
    MouvementFinancier mouvement(CategorieMouvement categorie, int montant) =>
        MouvementFinancier(
          id: '${categorie.name}-$montant',
          bienId: 'bien-1',
          date: t,
          montantCentimes: montant,
          categorie: categorie,
          creeLe: t,
          modifieLe: t,
        );

    final bien = unBien(loyerHcCentimes: 65000).copyWith(
      prixAchatCentimes: 15000000,
      fraisNotaireCentimes: 1200000,
      travauxInitiauxCentimes: 800000,
      venduLe: t,
      prixVenteCentimes: 20000000,
      fraisVenteCentimes: 500000,
    );

    test('plus-value, loyers encaissés, dépenses hors crédit', () {
      final b = Rentabilite.bilanVente(
        bien: bien,
        encaissements: [
          for (final mois in [1, 2, 3])
            EncaissementLoyer(
              bienId: 'bien-1',
              annee: 2026,
              mois: mois,
              recu: true,
            ),
          const EncaissementLoyer(
            bienId: 'bien-1',
            annee: 2026,
            mois: 4,
            recu: false,
          ),
        ],
        mouvements: [
          mouvement(CategorieMouvement.travaux, 300000),
          mouvement(CategorieMouvement.taxeFonciere, 90000),
          mouvement(CategorieMouvement.credit, 500000),
          mouvement(CategorieMouvement.autreRecette, 10000),
        ],
      )!;
      // 200 000 − 5 000 − (150 000 + 12 000) − 8 000 = 25 000 €
      expect(b.plusValueBrute, 2500000);
      expect(b.loyersEncaisses, 195000);
      expect(b.travauxJournal, 300000);
      // Le crédit n'est pas compté.
      expect(b.autresDepenses, 90000);
      // 25 000 + 1 950 + 100 − 3 000 − 900 = 23 150 €
      expect(b.resultat, 2315000);
    });

    test("sans prix de vente ou d'achat : pas de bilan", () {
      expect(
        Rentabilite.bilanVente(
          bien: bien.copyWith(prixVenteCentimes: null),
          encaissements: const [],
          mouvements: const [],
        ),
        isNull,
      );
      expect(
        Rentabilite.bilanVente(
          bien: bien.copyWith(prixAchatCentimes: null),
          encaissements: const [],
          mouvements: const [],
        ),
        isNull,
      );
    });
  });
}
