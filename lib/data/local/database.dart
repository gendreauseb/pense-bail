import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/entities.dart';
import 'convertisseur_jour.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Bailleurs,
    Biens,
    Baux,
    Locataires,
    Echeances,
    Rappels,
    Artisans,
    Interventions,
    MouvementsFinanciers,
    EncaissementsLoyers,
    RevisionsLoyers,
    IndicesIrl,
    Reglages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: nomFichier));

  /// Nom du fichier SQLite (sans extension) dans le dossier de l'application.
  static const nomFichier = 'bailleur';

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _creerIndex();
    },
    onUpgrade: (m, de, vers) async {
      // Version 2 : date de révision prévue, pour le courrier.
      if (de < 2) {
        await m.addColumn(revisionsLoyers, revisionsLoyers.datePrevue);
      }
      // Version 3 : complément d'adresse (bâtiment, résidence…).
      if (de < 3) {
        await m.addColumn(bailleurs, bailleurs.complementAdresse);
        await m.addColumn(biens, biens.complementAdresse);
      }
      // Version 4 : courrier de révision inclus (version gratuite).
      if (de < 4) {
        await m.addColumn(revisionsLoyers, revisionsLoyers.courrierInclus);
      }
      // Version 5 : dates calendaires sans fuseau horaire (AAAA-MM-JJ).
      if (de < 5) await normaliserJours();
    },
    beforeOpen: (details) async {
      // Indispensable pour les suppressions en cascade.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Réécrit les dates calendaires au format `AAAA-MM-JJ` : les anciennes
  /// valeurs (`2026-10-15T00:00:00.000+02:00`, schéma 4 et avant) gardent
  /// leurs 10 premiers caractères, qui sont le jour saisi. Sert à la mise à
  /// jour du schéma et à la restauration d'une ancienne sauvegarde.
  Future<void> normaliserJours() async {
    for (final table in allTables) {
      for (final colonne in table.$columns) {
        // Seules les dates calendaires sont des DateTime convertis
        // (ConvertisseurJour) ; creeLe et modifieLe restent des instants.
        if (colonne is! GeneratedColumnWithTypeConverter ||
            colonne.converter is! TypeConverter<DateTime?, String?>) {
          continue;
        }
        final nom = '"${colonne.name}"';
        await customUpdate(
          'UPDATE "${table.actualTableName}" SET $nom = substr($nom, 1, 10) '
          'WHERE length($nom) > 10',
          updates: {table},
          updateKind: UpdateKind.update,
        );
      }
    }
  }

  Future<void> _creerIndex() async {
    await customStatement(
      'CREATE INDEX idx_echeances_date ON echeances (statut, date)',
    );
    await customStatement(
      'CREATE INDEX idx_echeances_bien ON echeances (bien_id)',
    );
    await customStatement(
      'CREATE INDEX idx_baux_bien ON baux (bien_id, actif)',
    );
    await customStatement(
      'CREATE INDEX idx_mouvements_bien ON mouvements_financiers (bien_id, date)',
    );
    await customStatement(
      'CREATE INDEX idx_interventions_bien ON interventions (bien_id)',
    );
  }
}
