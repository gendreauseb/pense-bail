// Injection des dépendances (Riverpod).
//
// Les écrans ne connaissent que les interfaces du domaine : pour brancher
// une autre source de données (cloud, tests), il suffit de surcharger ces
// providers.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/entities.dart';
import '../domain/repositories/repositories.dart';
import '../domain/usecases/gestion_echeances.dart';
import 'local/database.dart';
import 'notifications/service_notifications.dart';
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

// ---------------------------------------------------------------------------
// Cas d'usage
// ---------------------------------------------------------------------------

final gestionEcheancesProvider = Provider<GestionEcheances>(
  (ref) => GestionEcheances(
    transactions: ref.watch(transactionsProvider),
    echeances: ref.watch(echeanceRepositoryProvider),
  ),
);

/// Notifications locales. Fourni au démarrage (voir main.dart) ; inactif
/// par défaut (tests).
final serviceNotificationsProvider = Provider<ServiceNotifications>(
  (ref) => const NotificationsInactives(),
);

// ---------------------------------------------------------------------------
// Flux de données (mis à jour automatiquement à chaque modification)
// ---------------------------------------------------------------------------

final bailleurFluxProvider = StreamProvider<Bailleur?>(
  (ref) => ref.watch(bailleurRepositoryProvider).surveiller(),
);

final biensFluxProvider = StreamProvider<List<Bien>>(
  (ref) => ref.watch(bienRepositoryProvider).surveillerTous(),
);

final bauxActifsFluxProvider = StreamProvider<List<Bail>>(
  (ref) => ref.watch(bailRepositoryProvider).surveillerBauxActifs(),
);

/// Échéances à faire, triées par date, tous biens confondus.
final echeancesAFaireFluxProvider = StreamProvider<List<Echeance>>(
  (ref) => ref.watch(echeanceRepositoryProvider).surveillerAFaire(),
);

final rappelsEcheanceProvider = FutureProvider.autoDispose
    .family<List<Rappel>, String>(
      (ref, echeanceId) =>
          ref.watch(echeanceRepositoryProvider).rappels(echeanceId),
    );

final echeanceProvider = FutureProvider.autoDispose.family<Echeance?, String>(
  (ref, id) => ref.watch(echeanceRepositoryProvider).parId(id),
);
