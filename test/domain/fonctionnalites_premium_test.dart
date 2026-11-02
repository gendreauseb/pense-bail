import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/acces_biens.dart';
import 'package:pense_bail/domain/usecases/gestion_artisans.dart';
import 'package:pense_bail/domain/usecases/gestion_finances.dart';
import 'package:pense_bail/domain/usecases/verrou_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

/// Rentabilité et carnet d'artisans : réservés à Premium, ce qui est déjà
/// saisi reste en base.
void main() {
  late AppDatabase db;
  late GestionFinances finances;
  late GestionArtisans artisans;
  var droits = Droits.premium;
  final t = DateTime(2026, 9, 25);

  setUp(() async {
    db = baseDeTest();
    droits = Droits.premium;
    final verrou = VerrouBiens(
      biens: DriftBienRepository(db),
      droits: () async => droits,
    );
    finances = GestionFinances(
      biens: DriftBienRepository(db),
      finances: DriftFinanceRepository(db),
      verrou: verrou,
    );
    artisans = GestionArtisans(
      artisans: DriftArtisanRepository(db),
      verrou: verrou,
    );
    await DriftBienRepository(db).enregistrer(unBien());
  });
  tearDown(() => db.close());

  MouvementFinancier mouvement({String id = 'm1'}) => MouvementFinancier(
    id: id,
    bienId: 'bien-1',
    date: t,
    montantCentimes: 12000,
    categorie: CategorieMouvement.travaux,
    creeLe: t,
    modifieLe: t,
  );

  const encaissement = EncaissementLoyer(
    bienId: 'bien-1',
    annee: 2026,
    mois: 9,
    recu: true,
  );

  Artisan plombier() => Artisan(
    id: 'a1',
    nom: 'Dupont Plomberie',
    metier: MetierArtisan.plombier,
    creeLe: t,
    modifieLe: t,
  );

  Intervention fuite() => Intervention(
    id: 'i1',
    bienId: 'bien-1',
    date: t,
    description: 'Fuite sous évier',
    coutCentimes: 9000,
    creeLe: t,
    modifieLe: t,
  );

  Matcher reservee(Fonctionnalite f) => throwsA(
    isA<FonctionnaliteReservee>().having(
      (e) => e.fonctionnalite,
      'fonctionnalité',
      f,
    ),
  );

  group('rentabilité', () {
    test('Premium : journal, cases et investissement enregistrés', () async {
      await finances.enregistrerMouvement(mouvement());
      await finances.definirEncaissement(encaissement);
      await finances.enregistrerInvestissement(
        unBien().copyWith(prixAchatCentimes: 15000000),
      );
      final repo = DriftFinanceRepository(db);
      expect(await repo.mouvements('bien-1'), hasLength(1));
      expect(
        await repo.surveillerEncaissements('bien-1', annee: 2026).first,
        hasLength(1),
      );
      expect(
        (await DriftBienRepository(db).parId('bien-1'))!.prixAchatCentimes,
        15000000,
      );
    });

    test('gratuit : écritures refusées, données existantes intactes', () async {
      await finances.enregistrerMouvement(mouvement());
      droits = Droits.gratuit;

      await expectLater(
        finances.enregistrerMouvement(mouvement(id: 'm2')),
        reservee(Fonctionnalite.rentabilite),
      );
      await expectLater(
        finances.supprimerMouvement(mouvement()),
        reservee(Fonctionnalite.rentabilite),
      );
      await expectLater(
        finances.definirEncaissement(encaissement),
        reservee(Fonctionnalite.rentabilite),
      );
      await expectLater(
        finances.enregistrerInvestissement(
          unBien().copyWith(prixAchatCentimes: 1),
        ),
        reservee(Fonctionnalite.rentabilite),
      );

      final repo = DriftFinanceRepository(db);
      expect((await repo.mouvements('bien-1')).map((m) => m.id), ['m1']);
      expect(await repo.surveillerEncaissements('bien-1').first, isEmpty);
      expect(
        (await DriftBienRepository(db).parId('bien-1'))!.prixAchatCentimes,
        isNull,
      );
    });

    test('encaissements de toutes les années', () async {
      await finances.definirEncaissement(encaissement);
      await finances.definirEncaissement(
        const EncaissementLoyer(
          bienId: 'bien-1',
          annee: 2025,
          mois: 12,
          recu: true,
        ),
      );
      final tous = await DriftFinanceRepository(
        db,
      ).surveillerEncaissements('bien-1').first;
      expect(
        [for (final e in tous) (e.annee, e.mois)],
        [(2025, 12), (2026, 9)],
      );
    });
  });

  group("carnet d'artisans", () {
    test('Premium : artisan et intervention enregistrés', () async {
      await artisans.enregistrer(plombier());
      await artisans.enregistrerIntervention(fuite());
      expect(
        await DriftArtisanRepository(db).surveillerTous().first,
        hasLength(1),
      );
      expect(
        await DriftArtisanRepository(
          db,
        ).surveillerInterventions('bien-1').first,
        hasLength(1),
      );
    });

    test('gratuit : écritures refusées, carnet existant intact', () async {
      await artisans.enregistrer(plombier());
      await artisans.enregistrerIntervention(fuite());
      droits = Droits.gratuit;

      await expectLater(
        artisans.enregistrer(plombier().copyWith(nom: 'Autre')),
        reservee(Fonctionnalite.artisans),
      );
      await expectLater(
        artisans.supprimer('a1'),
        reservee(Fonctionnalite.artisans),
      );
      await expectLater(
        artisans.enregistrerIntervention(
          fuite().copyWith(description: 'Autre'),
        ),
        reservee(Fonctionnalite.artisans),
      );
      await expectLater(
        artisans.supprimerIntervention(fuite()),
        reservee(Fonctionnalite.artisans),
      );

      final repo = DriftArtisanRepository(db);
      expect((await repo.parId('a1'))!.nom, 'Dupont Plomberie');
      expect(
        (await repo.surveillerInterventions('bien-1').first).single.description,
        'Fuite sous évier',
      );
    });
  });

  test('messages en clair, avec ce qui reste consultable', () {
    expect(
      const FonctionnaliteReservee(Fonctionnalite.rentabilite).message,
      contains('reste consultable'),
    );
    expect(
      const FonctionnaliteReservee(Fonctionnalite.courrierRevision).message,
      'Le courrier de révision est inclus dans Pense-Bail Premium.',
    );
  });
}
