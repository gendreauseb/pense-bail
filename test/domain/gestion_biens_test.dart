import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/gestion_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late GestionBiens gestion;
  late DriftEcheanceRepository echeances;
  final aujourdhui = DateTime(2026, 9, 25);

  setUp(() {
    db = baseDeTest();
    echeances = DriftEcheanceRepository(db);
    gestion = GestionBiens(
      transactions: DriftTransactions(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: echeances,
    );
  });

  tearDown(() => db.close());

  Future<List<Echeance>> aFaire() async =>
      (await echeances.aFaire()).where((e) => e.bienId == 'bien-1').toList();

  Future<void> creerStudio() => gestion.creer(
    bien: unBien(),
    bail: unBail(debut: DateTime(2023, 9, 1)),
    aujourdhui: aujourdhui,
  );

  test('créer : bien, bail, échéances et rappels par défaut', () async {
    await creerStudio();
    final liste = await aFaire();
    expect(liste.map((e) => e.type).toSet(), {
      TypeEcheance.revisionLoyer,
      TypeEcheance.finBail,
      TypeEcheance.dateLimiteConge,
      TypeEcheance.regularisationCharges,
      TypeEcheance.taxeFonciere,
    });
    final rappels = await echeances.rappels(liste.first.id);
    expect(rappels.map((r) => r.joursAvant), [30, 7, 1]);
  });

  test('modifier le nom : échéances conservées telles quelles', () async {
    await creerStudio();
    final avant = {for (final e in await aFaire()) e.id};

    await gestion.modifier(
      bien: unBien().copyWith(nom: 'Studio rénové'),
      aujourdhui: aujourdhui,
    );

    expect({for (final e in await aFaire()) e.id}, avant);
  });

  test('passer en moyenne durée : la révision disparaît', () async {
    await creerStudio();
    await gestion.modifier(
      bien: unBien(typeLocation: TypeLocation.moyenneDuree),
      aujourdhui: aujourdhui,
    );
    final types = (await aFaire()).map((e) => e.type);
    expect(types, isNot(contains(TypeEcheance.revisionLoyer)));
    expect(types, contains(TypeEcheance.finBail));
  });

  test('bail : l\'IRL seul ne recalcule pas, la date de début oui', () async {
    await creerStudio();
    final bail = (await DriftBailRepository(db).bailActif('bien-1'))!;
    final avant = {for (final e in await aFaire()) e.id};

    await gestion.enregistrerBail(
      bien: unBien(),
      bail: bail.copyWith(irlTrimestre: 2, irlAnnee: 2023, irlValeur: 100.0),
      aujourdhui: aujourdhui,
    );
    expect({for (final e in await aFaire()) e.id}, avant);

    await gestion.enregistrerBail(
      bien: unBien(),
      bail: bail.copyWith(dateDebut: DateTime(2024, 3, 1)),
      aujourdhui: aujourdhui,
    );
    final apres = await aFaire();
    expect(
      {for (final e in apres) e.id}.intersection(avant).length,
      1,
      reason: 'seule la taxe foncière (non liée au bail) est conservée',
    );
    final revision = apres.firstWhere(
      (e) => e.type == TypeEcheance.revisionLoyer,
    );
    expect(revision.date, DateTime(2027, 3, 1));
  });

  test('supprimer : tout ce qui se rattache au bien disparaît', () async {
    await creerStudio();
    await gestion.supprimer('bien-1');
    expect(await DriftBienRepository(db).tous(), isEmpty);
    expect(await DriftBailRepository(db).bailActif('bien-1'), isNull);
    expect(await echeances.aFaire(), isEmpty);
    expect(await echeances.tousLesRappels(), isEmpty);
  });
}
