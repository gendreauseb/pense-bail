import 'package:pense_bail/core/config/cles_reglages.dart';
import 'package:pense_bail/data/droits/droits_beta.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';

void main() {
  late AppDatabase db;
  late DriftReglagesRepository reglages;

  setUp(() {
    db = baseDeTest();
    reglages = DriftReglagesRepository(db);
  });
  tearDown(() => db.close());

  test('hors bêta : toujours gratuit, même avec la clé Premium', () async {
    await reglages.ecrire(ClesReglages.modePremiumBeta, 'premium');
    final source = DroitsBeta(reglages: reglages, estBeta: false);
    expect(await source.surveiller().first, Droits.gratuit);

    await source.definirPremium(true);
    expect(await source.surveiller().first, Droits.gratuit);
  });

  test('bêta sans choix : Premium par défaut', () async {
    final source = DroitsBeta(reglages: reglages, estBeta: true);
    expect(await source.surveiller().first, Droits.premium);
  });

  test('bêta : la bascule est suivie en direct', () async {
    final source = DroitsBeta(reglages: reglages, estBeta: true);
    final recus = <Droits>[];
    final abonnement = source.surveiller().listen(recus.add);

    Future<void> attendre(int n) async {
      for (var i = 0; i < 50 && recus.length < n; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    }

    await attendre(1);
    await source.definirPremium(false);
    await attendre(2);
    await source.definirPremium(true);
    await attendre(3);
    await abonnement.cancel();

    expect(recus, [Droits.premium, Droits.gratuit, Droits.premium]);
    expect(await reglages.lire(ClesReglages.modePremiumBeta), 'premium');
  });

  test('valeur inconnue : mode par défaut', () async {
    await reglages.ecrire(ClesReglages.modePremiumBeta, "n'importe quoi");
    final source = DroitsBeta(reglages: reglages, estBeta: true);
    expect(await source.surveiller().first, Droits.premium);
  });

  test("fin d'abonnement simulée : gratuit et message à annoncer", () async {
    final source = DroitsBeta(reglages: reglages, estBeta: true);
    await source.simulerFinAbonnement();
    expect(await source.surveiller().first, Droits.gratuit);
    expect(await reglages.lire(ClesReglages.finAbonnementAAnnoncer), 'true');
  });

  test("hors bêta : la simulation n'a aucun effet", () async {
    await DroitsBeta(reglages: reglages, estBeta: false).simulerFinAbonnement();
    expect(await reglages.lire(ClesReglages.finAbonnementAAnnoncer), isNull);
    expect(await reglages.lire(ClesReglages.modePremiumBeta), isNull);
  });
}
