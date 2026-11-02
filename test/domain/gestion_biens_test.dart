import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/acces_biens.dart';
import 'package:pense_bail/domain/usecases/gestion_biens.dart';
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
      droits: () async => Droits.premium,
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

  test('créer : bien, bail, échéances et rappels par défaut', () async {
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

  test('modifier le nom : échéances conservées telles quelles', () async {
    await creerStudio();
    final avant = {for (final e in await aFaire()) e.id};

    await gestion.modifier(
      bien: unBien().copyWith(nom: 'Studio rénové'),
      aujourdhui: aujourdhui,
    );

    expect({for (final e in await aFaire()) e.id}, avant);
  });

  test('passer en moyenne durée : la révision disparaît', () async {
    await creerStudio();
    await gestion.modifier(
      bien: unBien(typeLocation: TypeLocation.moyenneDuree),
      aujourdhui: aujourdhui,
    );
    final types = (await aFaire()).map((e) => e.type);
    expect(types, isNot(contains(TypeEcheance.revisionLoyer)));
    expect(types, contains(TypeEcheance.finBail));
  });

  test('bail : l\'IRL seul ne recalcule pas, la date de début oui', () async {
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

  test('clause de révision', () async {
    await creerStudio();
    final bail = (await DriftBailRepository(db).bailActif('bien-1'))!;
    final avant = {for (final e in await aFaire()) e.id};
    Future<void> enregistrer(bool? clause) => gestion.enregistrerBail(
      bien: unBien(),
      bail: bail.copyWith(clauseRevision: clause),
      aujourdhui: aujourdhui,
    );

    // « Oui » au lieu de « je ne sais pas » : rien à recalculer.
    await enregistrer(true);
    expect({for (final e in await aFaire()) e.id}, avant);
    expect(
      (await DriftBailRepository(db).bailActif('bien-1'))!.clauseRevision,
      isTrue,
    );

    // « Non » : plus de rappel de révision.
    await enregistrer(false);
    expect(
      (await aFaire()).map((e) => e.type),
      isNot(contains(TypeEcheance.revisionLoyer)),
    );

    // Retour à « je ne sais pas » : le rappel revient.
    await enregistrer(null);
    expect(
      (await aFaire()).map((e) => e.type),
      contains(TypeEcheance.revisionLoyer),
    );
  });

  test('supprimer : tout ce qui se rattache au bien disparaît', () async {
    await creerStudio();
    await gestion.supprimer('bien-1');
    expect(await DriftBienRepository(db).tous(), isEmpty);
    expect(await DriftBailRepository(db).bailActif('bien-1'), isNull);
    expect(await echeances.aFaire(), isEmpty);
    expect(await echeances.tousLesRappels(), isEmpty);
  });

  group('limite de la version gratuite', () {
    GestionBiens avec(Droits droits) => GestionBiens(
      transactions: DriftTransactions(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: echeances,
      droits: () async => droits,
    );

    test('premier bien accepté, deuxième refusé sans rien créer', () async {
      final gratuit = avec(Droits.gratuit);
      await gratuit.creer(bien: unBien(), aujourdhui: aujourdhui);

      await expectLater(
        gratuit.creer(
          bien: unBien(id: 'bien-2', nom: 'T2 Belleville'),
          bail: unBail(id: 'bail-2', bienId: 'bien-2', debut: DateTime(2024)),
          aujourdhui: aujourdhui,
        ),
        throwsA(isA<LimiteBiensAtteinte>()),
      );
      expect((await DriftBienRepository(db).tous()).map((b) => b.id), [
        'bien-1',
      ]);
      expect(await DriftBailRepository(db).bailActif('bien-2'), isNull);
      expect(
        (await echeances.aFaire()).where((e) => e.bienId == 'bien-2'),
        isEmpty,
      );
    });

    test('Premium : plusieurs biens', () async {
      final premium = avec(Droits.premium);
      await premium.creer(bien: unBien(), aujourdhui: aujourdhui);
      await premium.creer(
        bien: unBien(id: 'bien-2'),
        aujourdhui: aujourdhui,
      );
      expect(await DriftBienRepository(db).tous(), hasLength(2));
    });

    test('déjà plusieurs biens (ancien Premium) : ajout refusé', () async {
      await avec(Droits.premium).creer(bien: unBien(), aujourdhui: aujourdhui);
      await avec(Droits.premium).creer(
        bien: unBien(id: 'bien-2'),
        aujourdhui: aujourdhui,
      );

      await expectLater(
        avec(Droits.gratuit).creer(
          bien: unBien(id: 'bien-3'),
          aujourdhui: aujourdhui,
        ),
        throwsA(isA<LimiteBiensAtteinte>()),
      );
      expect(await DriftBienRepository(db).tous(), hasLength(2));
    });
  });

  group('bien en lecture seule (version gratuite)', () {
    late GestionBiens gratuit;

    setUp(() async {
      await creerStudio();
      await gestion.creer(
        bien: unBien(id: 'bien-2', nom: 'T2', creeLe: DateTime(2026, 6, 1)),
        bail: unBail(id: 'bail-2', bienId: 'bien-2', debut: DateTime(2024)),
        aujourdhui: aujourdhui,
      );
      gratuit = GestionBiens(
        transactions: DriftTransactions(db),
        biens: DriftBienRepository(db),
        baux: DriftBailRepository(db),
        echeances: echeances,
        droits: () async => Droits.gratuit,
      );
    });

    Locataire locataire(String bailId) => Locataire(
      id: 'loc-$bailId',
      bailId: bailId,
      prenom: 'Paul',
      nom: 'Martin',
      creeLe: aujourdhui,
      modifieLe: aujourdhui,
    );

    test('modifier, bail, locataires : refusés, rien ne change', () async {
      final t2 = (await DriftBienRepository(db).parId('bien-2'))!;
      final bail2 = (await DriftBailRepository(db).bailActif('bien-2'))!;

      await expectLater(
        gratuit.modifier(
          bien: t2.copyWith(nom: 'Renommé', photoChemin: 'photos/x.jpg'),
          aujourdhui: aujourdhui,
        ),
        throwsA(isA<BienVerrouille>()),
      );
      await expectLater(
        gratuit.enregistrerBail(
          bien: t2,
          bail: bail2.copyWith(dureeMois: 48),
          aujourdhui: aujourdhui,
        ),
        throwsA(isA<BienVerrouille>()),
      );
      await expectLater(
        gratuit.enregistrerLocataire(
          bienId: 'bien-2',
          locataire: locataire('bail-2'),
        ),
        throwsA(isA<BienVerrouille>()),
      );
      await expectLater(
        gratuit.supprimerLocataire(bienId: 'bien-2', locataireId: 'x'),
        throwsA(isA<BienVerrouille>()),
      );

      final apres = (await DriftBienRepository(db).parId('bien-2'))!;
      expect((apres.nom, apres.photoChemin), ('T2', null));
      expect(
        (await DriftBailRepository(db).bailActif('bien-2'))!.dureeMois,
        isNull,
      );
      expect(await DriftBailRepository(db).locataires('bail-2'), isEmpty);
    });

    test('le bien actif reste modifiable', () async {
      await gratuit.modifier(
        bien: unBien().copyWith(nom: 'Studio rénové'),
        aujourdhui: aujourdhui,
      );
      await gratuit.enregistrerLocataire(
        bienId: 'bien-1',
        locataire: locataire('bail-1'),
      );
      expect(
        (await DriftBienRepository(db).parId('bien-1'))!.nom,
        'Studio rénové',
      );
      expect(await DriftBailRepository(db).locataires('bail-1'), hasLength(1));
    });

    test('supprimer un bien en lecture seule reste possible', () async {
      await gratuit.supprimer('bien-2');
      expect((await DriftBienRepository(db).tous()).map((b) => b.id), [
        'bien-1',
      ]);
    });

    test('le bien actif supprimé : le suivant devient modifiable', () async {
      await gratuit.supprimer('bien-1');
      await gratuit.modifier(
        bien: (await DriftBienRepository(
          db,
        ).parId('bien-2'))!.copyWith(nom: 'T2 rénové'),
        aujourdhui: aujourdhui,
      );
      expect((await DriftBienRepository(db).parId('bien-2'))!.nom, 'T2 rénové');
    });
  });
}
