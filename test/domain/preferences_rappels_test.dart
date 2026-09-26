import 'package:bailleur_app/core/config/cles_reglages.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/gestion_biens.dart';
import 'package:bailleur_app/domain/usecases/preferences_rappels.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  group('PreferencesRappels', () {
    test('par défaut : J-30, J-7, J-1 et tous les types notifiés', () {
      const p = PreferencesRappels();
      expect(p.delaisParDefaut, [30, 7, 1]);
      expect(TypeEcheance.values.every(p.notifie), isTrue);
    });

    test('aller-retour JSON', () {
      const p = PreferencesRappels(
        delaisParDefaut: [15, 0],
        typesDesactives: {TypeEcheance.taxeFonciere},
      );
      expect(PreferencesRappels.depuisJson(p.versJson()), p);
    });

    test('valeurs inconnues ignorées, délais triés', () {
      final p = PreferencesRappels.depuisJson({
        'delaisParDefaut': [1, 'x', 42, 30],
        'typesDesactives': ['inconnu', 'finBail'],
      });
      expect(p.delaisParDefaut, [30, 1]);
      expect(p.typesDesactives, {TypeEcheance.finBail});
    });
  });

  group('GestionPreferencesRappels', () {
    late AppDatabase db;
    late GestionPreferencesRappels gestion;
    late DriftEcheanceRepository echeances;

    setUp(() {
      db = baseDeTest();
      echeances = DriftEcheanceRepository(db);
      gestion = GestionPreferencesRappels(
        transactions: DriftTransactions(db),
        reglages: DriftReglagesRepository(db),
        echeances: echeances,
      );
    });
    tearDown(() => db.close());

    test('lecture par défaut, enregistrement, réglage abîmé', () async {
      expect(await gestion.lire(), const PreferencesRappels());
      const choisies = PreferencesRappels(delaisParDefaut: [7]);
      await gestion.enregistrer(choisies);
      expect(await gestion.lire(), choisies);

      await DriftReglagesRepository(
        db,
      ).ecrire(ClesReglages.preferencesRappels, '{abîmé');
      expect(await gestion.lire(), const PreferencesRappels());
    });

    test('nouveaux biens : rappels des préférences', () async {
      await gestion.enregistrer(
        const PreferencesRappels(delaisParDefaut: [15, 0]),
      );
      await GestionBiens(
        transactions: DriftTransactions(db),
        biens: DriftBienRepository(db),
        baux: DriftBailRepository(db),
        echeances: echeances,
        rappelsParDefaut: () async => (await gestion.lire()).delaisParDefaut,
      ).creer(
        bien: unBien(),
        bail: unBail(debut: DateTime(2023, 9, 1)),
        aujourdhui: DateTime(2026, 9, 25),
      );
      final rappels = await echeances.tousLesRappels();
      expect(rappels, isNotEmpty);
      expect(rappels.map((r) => r.joursAvant).toSet(), {15, 0});

      // Appliquer d'autres délais à toutes les échéances à faire.
      final nombre = await gestion.appliquerAuxEcheancesAFaire([3]);
      expect(nombre, (await echeances.aFaire()).length);
      expect(
        (await echeances.tousLesRappels()).map((r) => r.joursAvant).toSet(),
        {3},
      );
    });
  });
}
