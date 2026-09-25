import 'package:bailleur_app/core/config/cles_reglages.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/finaliser_onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late FinaliserOnboarding finaliser;
  final aujourdhui = DateTime(2026, 9, 25);
  final t0 = DateTime(2026, 9, 25, 10);

  setUp(() {
    db = baseDeTest();
    finaliser = FinaliserOnboarding(
      transactions: DriftTransactions(db),
      bailleurs: DriftBailleurRepository(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: DriftEcheanceRepository(db),
      reglages: DriftReglagesRepository(db),
    );
  });

  tearDown(() => db.close());

  final bailleur = Bailleur(
    id: 'moi',
    prenom: 'Marie',
    nom: 'Durand',
    rue: '1 place de la Mairie',
    codePostal: '69001',
    ville: 'Lyon',
    telephone: '06 12 34 56 78',
    email: 'marie@exemple.fr',
    creeLe: t0,
    modifieLe: t0,
  );

  test('enregistre bailleur, biens, bail, échéances et rappels', () async {
    await DriftReglagesRepository(
      db,
    ).ecrire(ClesReglages.brouillonOnboarding, '{}');

    await finaliser.executer(
      bailleur: bailleur,
      biensInitiaux: [
        BienInitial(
          bien: unBien(id: 'studio'),
          bail: unBail(bienId: 'studio', debut: DateTime(2023, 9, 1)),
        ),
        BienInitial(
          bien: unBien(id: 'gite', typeLocation: TypeLocation.courteDuree),
        ),
      ],
      aujourdhui: aujourdhui,
    );

    expect((await DriftBailleurRepository(db).obtenir())!.prenom, 'Marie');
    expect(await DriftBienRepository(db).tous(), hasLength(2));
    expect(await DriftBailRepository(db).bailActif('studio'), isNotNull);
    expect(await DriftBailRepository(db).bailActif('gite'), isNull);

    final echeances = await DriftEcheanceRepository(
      db,
    ).surveillerAFaire().first;
    int nombre(String? bienId) =>
        echeances.where((e) => e.bienId == bienId).length;
    // Studio : révision, fin de bail, congé, régularisation + taxe foncière.
    expect(nombre('studio'), 5);
    // Gîte : taxe foncière seulement.
    expect(nombre('gite'), 1);
    // Déclaration de revenus : une seule, commune.
    expect(nombre(null), 1);

    final rappels = await DriftEcheanceRepository(
      db,
    ).rappels(echeances.first.id);
    expect(rappels.map((r) => r.joursAvant), [30, 7, 1]);

    final reglages = DriftReglagesRepository(db);
    expect(await reglages.lire(ClesReglages.onboardingTermine), 'true');
    expect(await reglages.lire(ClesReglages.brouillonOnboarding), isNull);
  });

  test('tout ou rien : une erreur annule tout', () async {
    await expectLater(
      finaliser.executer(
        bailleur: bailleur,
        biensInitiaux: [
          // Bail rattaché à un bien inexistant : violation de clé étrangère.
          BienInitial(
            bien: unBien(id: 'studio'),
            bail: unBail(bienId: 'inconnu', debut: DateTime(2023, 9, 1)),
          ),
        ],
        aujourdhui: aujourdhui,
      ),
      throwsA(anything),
    );

    expect(await DriftBailleurRepository(db).obtenir(), isNull);
    expect(await DriftBienRepository(db).tous(), isEmpty);
    expect(
      await DriftReglagesRepository(db).lire(ClesReglages.onboardingTermine),
      isNull,
    );
  });
}
