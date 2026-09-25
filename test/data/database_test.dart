import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late DriftBienRepository biens;
  late DriftBailRepository baux;
  late DriftEcheanceRepository echeances;
  late DriftArtisanRepository artisans;
  late DriftFinanceRepository finances;
  late DriftIndiceIrlRepository indices;

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    biens = DriftBienRepository(db);
    baux = DriftBailRepository(db);
    echeances = DriftEcheanceRepository(db);
    artisans = DriftArtisanRepository(db);
    finances = DriftFinanceRepository(db);
    indices = DriftIndiceIrlRepository(db);
  });

  tearDown(() => db.close());

  Echeance uneEcheance(String id, DateTime date, {bool automatique = true}) =>
      Echeance(
        id: id,
        bienId: 'bien-1',
        type: TypeEcheance.revisionLoyer,
        titre: 'Révision',
        date: date,
        statut: StatutEcheance.aFaire,
        automatique: automatique,
        creeLe: date,
        modifieLe: date,
      );

  test(
    'un bien est relu à l\'identique (énumérations, montants, dates)',
    () async {
      final bien = unBien(
        classeDpe: ClasseDpe.c,
      ).copyWith(surfaceM2: 32.5, dateDpe: DateTime(2024, 5, 2));
      await biens.enregistrer(bien);

      final relu = (await biens.parId('bien-1'))!;
      expect(relu.nom, 'Studio Gambetta');
      expect(relu.typeLocation, TypeLocation.longueDuree);
      expect(relu.classeDpe, ClasseDpe.c);
      expect(relu.loyerHcCentimes, 65000);
      expect(relu.surfaceM2, 32.5);
      expect(relu.dateDpe, DateTime(2024, 5, 2));
    },
  );

  test('un seul bail actif par bien', () async {
    await biens.enregistrer(unBien());
    await baux.enregistrer(unBail(id: 'a', debut: DateTime(2020, 1, 1)));
    await baux.enregistrer(unBail(id: 'b', debut: DateTime(2024, 1, 1)));

    expect((await baux.bailActif('bien-1'))!.id, 'b');
  });

  test(
    'remplacerAutomatiques garde les échéances faites et manuelles',
    () async {
      await biens.enregistrer(unBien());
      await echeances.enregistrerTout([
        uneEcheance('auto', DateTime(2027, 1, 1)),
        uneEcheance('manuelle', DateTime(2027, 2, 1), automatique: false),
        uneEcheance(
          'faite',
          DateTime(2026, 1, 1),
        ).copyWith(statut: StatutEcheance.faite),
      ]);

      await echeances.remplacerAutomatiques('bien-1', [
        uneEcheance('nouvelle', DateTime(2027, 3, 1)),
      ]);

      final ids = (await echeances.surveillerParBien('bien-1').first)
          .map((e) => e.id)
          .toList();
      expect(ids, ['faite', 'manuelle', 'nouvelle']);
    },
  );

  test('rappels par échéance', () async {
    await biens.enregistrer(unBien());
    await echeances.enregistrer(uneEcheance('e', DateTime(2027, 1, 1)));

    final rappels = await echeances.definirRappels('e', [30, 7, 1, 7]);
    expect(rappels.map((r) => r.joursAvant), [30, 7, 1]);
    expect(rappels.map((r) => r.id).toSet().length, 3);
  });

  test('le coût d\'une intervention alimente le journal financier', () async {
    await biens.enregistrer(unBien());
    final t = DateTime(2026, 9, 1);
    final intervention = Intervention(
      id: 'i1',
      bienId: 'bien-1',
      date: t,
      description: 'Fuite sous l\'évier',
      coutCentimes: 12000,
      creeLe: t,
      modifieLe: t,
    );

    await artisans.enregistrerIntervention(intervention);
    var mouvements = await finances.mouvements('bien-1', annee: 2026);
    expect(mouvements.single.montantCentimes, 12000);
    expect(mouvements.single.categorie, CategorieMouvement.intervention);
    expect(mouvements.single.montantSigneCentimes, -12000);

    await artisans.enregistrerIntervention(
      intervention.copyWith(coutCentimes: 15000),
    );
    mouvements = await finances.mouvements('bien-1');
    expect(mouvements.single.montantCentimes, 15000);

    await artisans.supprimerIntervention('i1');
    expect(await finances.mouvements('bien-1'), isEmpty);
  });

  test('supprimer un bien supprime tout ce qui s\'y rattache', () async {
    await biens.enregistrer(unBien());
    await baux.enregistrer(unBail(debut: DateTime(2024, 1, 1)));
    await echeances.enregistrer(uneEcheance('e', DateTime(2027, 1, 1)));
    await echeances.definirRappels('e', [7]);

    await biens.supprimer('bien-1');

    expect(await baux.bailActif('bien-1'), isNull);
    expect(await echeances.parId('e'), isNull);
    expect(await echeances.rappels('e'), isEmpty);
  });

  test('une saisie manuelle ne remplace jamais un indice INSEE', () async {
    // Valeurs FICTIVES.
    await indices.enregistrerTout(const [
      IndiceIrl(
        annee: 2030,
        trimestre: 1,
        valeur: 100.00,
        source: SourceIndice.insee,
      ),
    ]);
    await indices.enregistrerTout(const [
      IndiceIrl(
        annee: 2030,
        trimestre: 1,
        valeur: 999.99,
        source: SourceIndice.manuel,
      ),
      IndiceIrl(
        annee: 2030,
        trimestre: 2,
        valeur: 101.00,
        source: SourceIndice.manuel,
      ),
    ]);

    expect((await indices.trouver(annee: 2030, trimestre: 1))!.valeur, 100.00);
    expect((await indices.dernier())!.trimestre, 2);
  });
}
