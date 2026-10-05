import 'dart:io';

import 'package:pense_bail/data/local/convertisseur_jour.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

// Les dates calendaires ne dépendent pas du fuseau horaire du téléphone :
// une échéance du 15/10 reste au 15/10 partout (audit A2-03).

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  group('ConvertisseurJour', () {
    const c = ConvertisseurJour();

    test('enregistre le jour seul', () {
      expect(c.toSql(DateTime(2026, 10, 15)), '2026-10-15');
      expect(c.toSql(DateTime(2026, 3, 5, 23, 59)), '2026-03-05');
    });

    test(
      "relit les anciennes valeurs au jour saisi, quel que soit le décalage",
      () {
        for (final ancienne in [
          '2026-10-15T00:00:00.000+14:00',
          '2026-10-15T00:00:00.000-10:00',
          '2026-10-15T00:00:00.000+02:00',
          '2026-10-15T00:00:00.000Z',
          '2026-10-15',
        ]) {
          expect(c.fromSql(ancienne), DateTime(2026, 10, 15), reason: ancienne);
        }
      },
    );

    test('refuse une valeur illisible', () {
      expect(() => c.fromSql('15/10/2026'), throwsFormatException);
    });
  });

  group('base', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    Future<String?> brut(String table, String colonne) async {
      final ligne = await db
          .customSelect('SELECT "$colonne" AS v FROM "$table"')
          .getSingle();
      return ligne.data['v'] as String?;
    }

    test('un début de bail est enregistré sans heure ni fuseau', () async {
      await DriftBienRepository(db).enregistrer(unBien());
      await DriftBailRepository(
        db,
      ).enregistrer(unBail(debut: DateTime(2023, 9, 1)));
      expect(await brut('baux', 'date_debut'), '2023-09-01');
      // Les horodatages restent des instants.
      expect(await brut('baux', 'cree_le'), startsWith('2026-01-01T'));
    });

    test("une échéance de l'ancien format est relue au bon jour", () async {
      await db.customStatement(
        "INSERT INTO echeances (id, type, titre, date, statut, automatique, "
        "cree_le, modifie_le) VALUES ('e1', 'personnalisee', 'Test', "
        "'2026-10-15T00:00:00.000+14:00', 'aFaire', 0, "
        "'2026-01-01T10:00:00.000+02:00', '2026-01-01T10:00:00.000+02:00')",
      );
      final echeance = (await DriftEcheanceRepository(db).parId('e1'))!;
      expect(echeance.date, DateTime(2026, 10, 15));
    });

    test("filtre par année : du 1er janvier au 31 décembre", () async {
      await DriftBienRepository(db).enregistrer(unBien());
      final finances = DriftFinanceRepository(db);
      for (final (id, date) in [
        ('veille', DateTime(2025, 12, 31)),
        ('premier', DateTime(2026, 1, 1)),
        ('dernier', DateTime(2026, 12, 31)),
        ('lendemain', DateTime(2027, 1, 1)),
      ]) {
        await finances.enregistrerMouvement(
          MouvementFinancier(
            id: id,
            bienId: 'bien-1',
            date: date,
            montantCentimes: 1000,
            categorie: CategorieMouvement.travaux,
            creeLe: date,
            modifieLe: date,
          ),
        );
      }
      final de2026 = await finances.mouvements('bien-1', annee: 2026);
      expect(de2026.map((m) => m.id), ['dernier', 'premier']);
    });
  });

  test('mise à jour du schéma 4 : dates réécrites sans fuseau', () async {
    final dossier = await Directory.systemTemp.createTemp('pense_bail_v4');
    addTearDown(() => dossier.delete(recursive: true));
    final fichier = File('${dossier.path}/base.sqlite');

    // Base du schéma 4 : même structure, dates avec décalage horaire.
    final v4 = AppDatabase(NativeDatabase(fichier));
    await v4.customStatement(
      "INSERT INTO echeances (id, type, titre, date, date_initiale, statut, "
      "faite_le, automatique, cree_le, modifie_le) VALUES ('e1', "
      "'personnalisee', 'Test', '2026-10-15T00:00:00.000+14:00', "
      "'2026-10-01T00:00:00.000-10:00', 'faite', "
      "'2026-10-16T00:00:00.000+02:00', 0, "
      "'2026-01-01T10:00:00.000+02:00', '2026-01-01T10:00:00.000+02:00')",
    );
    await v4.customStatement('PRAGMA user_version = 4');
    await v4.close();

    final db = AppDatabase(NativeDatabase(fichier));
    addTearDown(db.close);
    final ligne = await db
        .customSelect(
          'SELECT date, date_initiale, faite_le, cree_le FROM echeances',
        )
        .getSingle();
    expect(ligne.data, {
      'date': '2026-10-15',
      'date_initiale': '2026-10-01',
      'faite_le': '2026-10-16',
      'cree_le': '2026-01-01T10:00:00.000+02:00',
    });
    final echeance = (await DriftEcheanceRepository(db).parId('e1'))!;
    expect(echeance.date, DateTime(2026, 10, 15));
    expect(echeance.dateInitiale, DateTime(2026, 10, 1));
    expect(echeance.faiteLe, DateTime(2026, 10, 16));
  });
}
