import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/entities.dart';
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
  int get schemaVersion => 3;

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
    },
    beforeOpen: (details) async {
      // Indispensable pour les suppressions en cascade.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

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
