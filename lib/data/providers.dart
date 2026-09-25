// Injection des dépendances (Riverpod).
//
// Les écrans ne connaissent que les interfaces du domaine : pour brancher
// une autre source de données (cloud, tests), il suffit de surcharger ces
// providers.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/repositories.dart';
import 'local/database.dart';
import 'photos/photo_service.dart';
import 'repositories/drift_repositories.dart';

/// Dossier Documents de l'application, résolu au démarrage (voir main.dart).
final dossierDocumentsProvider = Provider<Directory>(
  (ref) => throw UnimplementedError('À fournir au démarrage.'),
);

final photoServiceProvider = Provider<PhotoService>(
  (ref) => PhotoService(ref.watch(dossierDocumentsProvider)),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final transactionsProvider = Provider<Transactions>(
  (ref) => DriftTransactions(ref.watch(databaseProvider)),
);

final bailleurRepositoryProvider = Provider<BailleurRepository>(
  (ref) => DriftBailleurRepository(ref.watch(databaseProvider)),
);

final bienRepositoryProvider = Provider<BienRepository>(
  (ref) => DriftBienRepository(ref.watch(databaseProvider)),
);

final bailRepositoryProvider = Provider<BailRepository>(
  (ref) => DriftBailRepository(ref.watch(databaseProvider)),
);

final echeanceRepositoryProvider = Provider<EcheanceRepository>(
  (ref) => DriftEcheanceRepository(ref.watch(databaseProvider)),
);

final artisanRepositoryProvider = Provider<ArtisanRepository>(
  (ref) => DriftArtisanRepository(ref.watch(databaseProvider)),
);

final financeRepositoryProvider = Provider<FinanceRepository>(
  (ref) => DriftFinanceRepository(ref.watch(databaseProvider)),
);

final revisionRepositoryProvider = Provider<RevisionRepository>(
  (ref) => DriftRevisionRepository(ref.watch(databaseProvider)),
);

final indiceIrlRepositoryProvider = Provider<IndiceIrlRepository>(
  (ref) => DriftIndiceIrlRepository(ref.watch(databaseProvider)),
);

final reglagesRepositoryProvider = Provider<ReglagesRepository>(
  (ref) => DriftReglagesRepository(ref.watch(databaseProvider)),
);
