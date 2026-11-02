import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/acces_biens.dart';
import 'package:pense_bail/domain/usecases/gestion_echeances.dart';
import 'package:pense_bail/domain/usecases/verrou_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late DriftEcheanceRepository echeances;
  late GestionEcheances gestion;
  final t0 = DateTime(2026, 9, 25, 10);
  var droits = Droits.premium;

  setUp(() async {
    db = baseDeTest();
    droits = Droits.premium;
    echeances = DriftEcheanceRepository(db);
    gestion = GestionEcheances(
      transactions: DriftTransactions(db),
      echeances: echeances,
      verrou: VerrouBiens(
        biens: DriftBienRepository(db),
        droits: () async => droits,
      ),
    );
    await DriftBienRepository(db).enregistrer(unBien());
  });

  tearDown(() => db.close());

  Echeance revision({DateTime? dateInitiale, int? intervalle = 12}) => Echeance(
    id: 'rev',
    bienId: 'bien-1',
    type: TypeEcheance.revisionLoyer,
    titre: 'Révision du loyer',
    date: DateTime(2026, 9, 1),
    dateInitiale: dateInitiale,
    statut: StatutEcheance.aFaire,
    intervalleMois: intervalle,
    automatique: true,
    creeLe: t0,
    modifieLe: t0,
  );

  test(
    'marquer comme faite crée l\'occurrence suivante et ses rappels',
    () async {
      await gestion.enregistrer(revision(), [30, 7, 1]);

      final suivante = await gestion.marquerFaite(revision(), maintenant: t0);

      expect(suivante!.date, DateTime(2027, 9, 1));
      expect(suivante.automatique, isTrue);
      expect((await echeances.parId('rev'))!.estFaite, isTrue);
      expect((await echeances.parId('rev'))!.faiteLe, DateTime(2026, 9, 25));
      final rappels = await echeances.rappels(suivante.id);
      expect(rappels.map((r) => r.joursAvant), [30, 7, 1]);
      expect(await echeances.aFaire(), hasLength(1));
    },
  );

  test('l\'occurrence suivante part de la date prévue à l\'origine', () async {
    final reportee = revision().copyWith(
      date: DateTime(2026, 9, 15),
      dateInitiale: DateTime(2026, 9, 1),
    );
    await gestion.enregistrer(reportee, const []);
    final suivante = await gestion.marquerFaite(reportee, maintenant: t0);
    expect(suivante!.date, DateTime(2027, 9, 1));
    expect(suivante.dateInitiale, isNull);
  });

  test("« Faite le » : date du jour de l'application", () async {
    await gestion.enregistrer(revision(), const []);
    await gestion.marquerFaite(
      revision(),
      aujourdhui: DateTime(2026, 9, 24),
      maintenant: t0,
    );
    expect((await echeances.parId('rev'))!.faiteLe, DateTime(2026, 9, 24));
  });

  test('échéance non récurrente : pas d\'occurrence suivante', () async {
    final unique = revision(intervalle: null);
    await gestion.enregistrer(unique, const [7]);
    expect(await gestion.marquerFaite(unique, maintenant: t0), isNull);
    expect(await echeances.aFaire(), isEmpty);
  });

  test('annuler « faite » restaure l\'état d\'origine', () async {
    await gestion.enregistrer(revision(), [7]);
    final suivante = await gestion.marquerFaite(revision(), maintenant: t0);
    await gestion.annulerFaite(originale: revision(), suivante: suivante);

    final aFaire = await echeances.aFaire();
    expect(aFaire.single.id, 'rev');
    expect(aFaire.single.estFaite, isFalse);
    expect(await echeances.parId(suivante!.id), isNull);
  });

  test('reporter conserve la date prévue à l\'origine', () async {
    await gestion.enregistrer(revision(), const []);
    var e = await gestion.reporter(revision(), DateTime(2026, 9, 20));
    expect(e.date, DateTime(2026, 9, 20));
    expect(e.dateInitiale, DateTime(2026, 9, 1));

    // Second report : l'origine ne change pas.
    e = await gestion.reporter(e, DateTime(2026, 10, 5));
    expect(e.dateInitiale, DateTime(2026, 9, 1));
    expect((await echeances.parId('rev'))!.date, DateTime(2026, 10, 5));
  });

  group('bien en lecture seule (version gratuite)', () {
    // bien-1 (le plus ancien) reste actif, bien-2 passe en lecture seule.
    Echeance duBien2({String id = 'e2'}) => revision()
        .copyWith(titre: 'Révision T2 Belleville')
        .avecId(id, 'bien-2');

    setUp(() async {
      await DriftBienRepository(
        db,
      ).enregistrer(unBien(id: 'bien-2', creeLe: DateTime(2026, 6, 1)));
      await gestion.enregistrer(duBien2(), [30, 7, 1]);
      droits = Droits.gratuit;
    });

    test('marquer faite et reporter restent possibles', () async {
      final reportee = await gestion.reporter(duBien2(), DateTime(2026, 10, 1));
      expect(reportee.date, DateTime(2026, 10, 1));
      final suivante = await gestion.marquerFaite(reportee, maintenant: t0);
      expect(suivante!.bienId, 'bien-2');
      expect((await echeances.parId('e2'))!.estFaite, isTrue);
    });

    test('créer, modifier ou supprimer est refusé', () async {
      await expectLater(
        gestion.enregistrer(duBien2(id: 'nouvelle'), const []),
        throwsA(isA<BienVerrouille>()),
      );
      expect(await echeances.parId('nouvelle'), isNull);

      await expectLater(
        gestion.enregistrer(duBien2().copyWith(titre: 'Autre'), const []),
        throwsA(isA<BienVerrouille>()),
      );
      expect((await echeances.parId('e2'))!.titre, 'Révision T2 Belleville');

      // Déplacer l'échéance vers le bien actif ne contourne pas le verrou.
      await expectLater(
        gestion.enregistrer(duBien2().avecId('e2', 'bien-1'), const []),
        throwsA(isA<BienVerrouille>()),
      );

      await expectLater(
        gestion.supprimer('e2'),
        throwsA(isA<BienVerrouille>()),
      );
      expect(await echeances.parId('e2'), isNotNull);
    });

    test('bien actif et échéances communes : toujours modifiables', () async {
      await gestion.enregistrer(revision(), const []);
      await gestion.enregistrer(revision().avecId('commune', null), const []);
      await gestion.supprimer('commune');
      expect(await echeances.parId('commune'), isNull);
    });
  });
}

extension on Echeance {
  /// Copie avec un autre identifiant et un autre bien (nul : commune).
  Echeance avecId(String id, String? bienId) => Echeance(
    id: id,
    bienId: bienId,
    type: type,
    titre: titre,
    date: date,
    dateInitiale: dateInitiale,
    statut: statut,
    intervalleMois: intervalleMois,
    automatique: automatique,
    creeLe: creeLe,
    modifieLe: modifieLe,
  );
}
