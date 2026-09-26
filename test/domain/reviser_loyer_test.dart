import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/services/calculateur_revision.dart';
import 'package:bailleur_app/domain/usecases/gestion_biens.dart';
import 'package:bailleur_app/domain/usecases/gestion_echeances.dart';
import 'package:bailleur_app/domain/usecases/reviser_loyer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late ReviserLoyer reviser;
  late DriftEcheanceRepository echeances;

  const ancien = IndiceIrl(
    annee: 2025,
    trimestre: 2,
    valeur: 146.68,
    source: SourceIndice.insee,
  );
  const nouveau = IndiceIrl(
    annee: 2026,
    trimestre: 2,
    valeur: 148.37,
    source: SourceIndice.insee,
  );

  setUp(() {
    db = baseDeTest();
    echeances = DriftEcheanceRepository(db);
    final transactions = DriftTransactions(db);
    reviser = ReviserLoyer(
      transactions: transactions,
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      revisions: DriftRevisionRepository(db),
      echeances: echeances,
      gestionEcheances: GestionEcheances(
        transactions: transactions,
        echeances: echeances,
      ),
    );
  });
  tearDown(() => db.close());

  /// Studio loué depuis le 01/09/2023, créé dans l'app le [aujourdhui].
  Future<(Bien, Bail)> studio(DateTime aujourdhui, {Bail? bail}) async {
    await GestionBiens(
      transactions: DriftTransactions(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: echeances,
    ).creer(
      bien: unBien(),
      bail: bail ?? unBail(debut: DateTime(2023, 9, 1)),
      aujourdhui: aujourdhui,
    );
    return (
      (await DriftBienRepository(db).parId('bien-1'))!,
      (await DriftBailRepository(db).bailActif('bien-1'))!,
    );
  }

  Future<List<Echeance>> revisionsAFaire() async => [
    for (final e in await echeances.aFaire())
      if (e.type == TypeEcheance.revisionLoyer) e,
  ];

  ResultatRevision resultat(CycleRevision cycle) =>
      CalculateurRevision.calculer(
        cycle: cycle,
        ancien: ancien,
        nouveau: nouveau,
        loyerActuelCentimes: 65000,
        chargesCentimes: 5000,
      );

  test('à temps : loyer, IRL de référence, historique, échéance', () async {
    final aujourdhui = DateTime(2026, 8, 10);
    // Révisé l'an dernier : l'IRL de référence est celui du T2 2025.
    final (bien, bail) = await studio(
      aujourdhui,
      bail: unBail(
        debut: DateTime(2023, 9, 1),
      ).copyWith(irlTrimestre: 2, irlAnnee: 2025, irlValeur: 146.68),
    );
    final cycle = CalculateurRevision.cycle(bail, aujourdhui: aujourdhui)!;
    expect(cycle.datePrevue, DateTime(2026, 9, 1));
    expect((await revisionsAFaire()).single.date, DateTime(2026, 9, 1));

    final revision = await reviser.confirmer(
      bien: bien,
      bail: bail,
      resultat: resultat(cycle),
      maintenant: aujourdhui,
    );

    expect(
      (await DriftBienRepository(db).parId('bien-1'))!.loyerHcCentimes,
      65749,
    );
    final bailApres = (await DriftBailRepository(db).bailActif('bien-1'))!;
    expect(
      (bailApres.irlTrimestre, bailApres.irlAnnee, bailApres.irlValeur),
      (2, 2026, 148.37),
    );
    final enregistree = (await DriftRevisionRepository(db).parId(revision.id))!;
    expect(enregistree.datePrevue, DateTime(2026, 9, 1));
    expect(enregistree.dateEffet, DateTime(2026, 9, 1));
    expect(enregistree.demandeeEnRetard, isFalse);

    // L'échéance de 2026 est faite, celle de 2027 est créée.
    expect((await revisionsAFaire()).single.date, DateTime(2027, 9, 1));
    expect(
      CalculateurRevision.cycle(
        bailApres,
        aujourdhui: aujourdhui,
        derniereDateEffet: enregistree.dateEffet,
      )!.datePrevue,
      DateTime(2027, 9, 1),
    );
  });

  test('en retard : effet à la demande, échéance suivante intacte', () async {
    final aujourdhui = DateTime(2026, 9, 25);
    final (bien, bail) = await studio(aujourdhui);
    final avant = (await revisionsAFaire()).single;
    expect(avant.date, DateTime(2027, 9, 1));

    final cycle = CalculateurRevision.cycle(bail, aujourdhui: aujourdhui)!;
    final revision = await reviser.confirmer(
      bien: bien,
      bail: bail,
      resultat: resultat(cycle),
      maintenant: aujourdhui,
    );

    expect(revision.dateEffet, aujourdhui);
    expect(revision.demandeeEnRetard, isTrue);
    expect((await revisionsAFaire()).single.id, avant.id);
  });
}
