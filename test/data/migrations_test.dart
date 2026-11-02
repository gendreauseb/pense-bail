import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'migrations/schemas/schema.dart';

// Mise à jour de la base depuis chaque version du schéma (audit A1-01).
// Les schémas de référence (drift_schemas/) viennent de l'historique git.
// Après toute modification de lib/data/local/tables.dart (nouvelle version N) :
//   dart run drift_dev schema dump lib/data/local/database.dart drift_schemas/drift_schema_vN.json
//   dart run drift_dev schema generate drift_schemas/ test/data/migrations/schemas/

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  final verifier = SchemaVerifier(GeneratedHelper());
  const anciennes = [1, 2, 3, 4, 5, 6];

  test('le schéma actuel a sa référence dans drift_schemas/', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    expect(GeneratedHelper.versions, [...anciennes, db.schemaVersion]);
  });

  for (final version in anciennes) {
    test('mise à jour du schéma $version : structure identique à une '
        'installation neuve', () async {
      final schema = await verifier.schemaAt(version);
      addTearDown(schema.close);
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, GeneratedHelper.versions.last);
    });
  }

  test('mise à jour du schéma 1 : données conservées', () async {
    final schema = await verifier.schemaAt(1);
    addTearDown(schema.close);
    // Données telles que les écrivait la première version : dates avec
    // heure et décalage horaire.
    const cree = "'2026-09-25T10:00:00.000+02:00'";
    schema.rawDatabase.execute(
      "INSERT INTO bailleurs (id, prenom, nom, rue, code_postal, ville, "
      "telephone, email, cree_le, modifie_le) VALUES ('moi', 'Claire', "
      "'Martin', '3 rue des Lilas', '44000', 'Nantes', '', '', $cree, $cree)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO biens (id, nom, type_logement, type_location, rue, "
      "code_postal, ville, loyer_hc_centimes, charges_centimes, ordre, "
      "date_dpe, cree_le, modifie_le) VALUES ('b1', 'Studio', 'appartement', "
      "'longueDuree', '8 quai de la Fosse', '44000', 'Nantes', 52000, 4000, "
      "0, '2020-03-05T00:00:00.000+01:00', $cree, $cree)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO baux (id, bien_id, type_bail, date_debut, actif, "
      "duree_mois, date_revision, irl_trimestre, irl_annee, irl_valeur, "
      "cree_le, modifie_le) VALUES ('bail1', 'b1', 'vide', "
      "'2023-09-01T00:00:00.000+02:00', 1, 36, "
      "'2024-09-01T00:00:00.000+02:00', 2, 2023, 140.59, $cree, $cree)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO echeances (id, bien_id, type, titre, date, statut, "
      "automatique, cree_le, modifie_le) VALUES ('e1', 'b1', 'personnalisee', "
      "'Test', '2026-10-15T00:00:00.000+14:00', 'aFaire', 0, $cree, $cree)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO revisions_loyers (id, bien_id, bail_id, date_effet, "
      "ancien_loyer_centimes, nouveau_loyer_centimes, ancien_irl_trimestre, "
      "ancien_irl_annee, ancien_irl_valeur, nouvel_irl_trimestre, "
      "nouvel_irl_annee, nouvel_irl_valeur, cree_le) VALUES ('r1', 'b1', "
      "'bail1', '2024-09-01T00:00:00.000+02:00', 52000, 53000, 2, 2023, "
      "140.59, 2, 2024, 145.17, $cree)",
    );

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, GeneratedHelper.versions.last);

    final bailleur = (await DriftBailleurRepository(db).obtenir())!;
    expect(bailleur.prenom, 'Claire');
    expect(bailleur.complementAdresse, isNull);

    final bien = (await DriftBienRepository(db).parId('b1'))!;
    expect(bien.nom, 'Studio');
    expect(bien.loyerHcCentimes, 52000);
    expect(bien.complementAdresse, isNull);
    expect(bien.dateDpe, DateTime(2020, 3, 5));

    final bail = (await DriftBailRepository(db).bailActif('b1'))!;
    expect(bail.dateDebut, DateTime(2023, 9, 1));
    expect(bail.dateRevision, DateTime(2024, 9, 1));
    // Schéma 6 : la clause de révision est inconnue pour les baux existants.
    expect(bail.clauseRevision, isNull);

    final echeance = (await DriftEcheanceRepository(db).parId('e1'))!;
    expect(echeance.date, DateTime(2026, 10, 15));

    final revision = (await DriftRevisionRepository(db).parId('r1'))!;
    expect(revision.dateEffet, DateTime(2024, 9, 1));
    expect(revision.nouveauLoyerCentimes, 53000);
    // Schéma 2 : pas de date prévue pour les révisions antérieures.
    expect(revision.datePrevue, isNull);
    // Schéma 4 : le courrier était inclus avant la version gratuite.
    expect(revision.courrierInclus, isTrue);

    // Schéma 5 : dates calendaires réécrites sans heure ni fuseau,
    // horodatages inchangés.
    final brut = await db
        .customSelect('SELECT date_debut, cree_le FROM baux')
        .getSingle();
    expect(brut.data, {
      'date_debut': '2023-09-01',
      'cree_le': '2026-09-25T10:00:00.000+02:00',
    });
  });
}
