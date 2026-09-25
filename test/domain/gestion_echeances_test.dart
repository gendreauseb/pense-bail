import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/gestion_echeances.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late DriftEcheanceRepository echeances;
  late GestionEcheances gestion;
  final t0 = DateTime(2026, 9, 25, 10);

  setUp(() async {
    db = baseDeTest();
    echeances = DriftEcheanceRepository(db);
    gestion = GestionEcheances(
      transactions: DriftTransactions(db),
      echeances: echeances,
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

  test('échéance non récurrente : pas d\'occurrence suivante', () async {
    final unique = revision(intervalle: null);
    await gestion.enregistrer(unique, const [7]);
    expect(await gestion.marquerFaite(unique, maintenant: t0), isNull);
    expect(await echeances.aFaire(), isEmpty);
  });

  test('annuler « faite » restaure l\'état d\'origine', () async {
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
}
