// Injection des dépendances (Riverpod).
//
// Les écrans ne connaissent que les interfaces du domaine : pour brancher
// une autre source de données (cloud, tests), il suffit de surcharger ces
// providers.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../domain/entities/entities.dart';
import '../domain/repositories/repositories.dart';
import '../domain/usecases/gestion_biens.dart';
import '../domain/usecases/gestion_echeances.dart';
import '../domain/usecases/preferences_rappels.dart';
import '../domain/usecases/reviser_loyer.dart';
import 'irl/service_indices_irl.dart';
import 'local/database.dart';
import 'notifications/service_notifications.dart';
import 'photos/photo_service.dart';
import 'repositories/drift_repositories.dart';
import 'sauvegarde/service_sauvegarde.dart';

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

final gestionBiensProvider = Provider<GestionBiens>(
  (ref) => GestionBiens(
    transactions: ref.watch(transactionsProvider),
    biens: ref.watch(bienRepositoryProvider),
    baux: ref.watch(bailRepositoryProvider),
    echeances: ref.watch(echeanceRepositoryProvider),
    rappelsParDefaut: () async =>
        (await ref.read(gestionPreferencesRappelsProvider).lire())
            .delaisParDefaut,
  ),
);

final gestionPreferencesRappelsProvider = Provider<GestionPreferencesRappels>(
  (ref) => GestionPreferencesRappels(
    transactions: ref.watch(transactionsProvider),
    reglages: ref.watch(reglagesRepositoryProvider),
    echeances: ref.watch(echeanceRepositoryProvider),
  ),
);

/// Préférences de rappel, mises à jour à chaque modification.
final preferencesRappelsProvider = StreamProvider<PreferencesRappels>(
  (ref) => ref.watch(gestionPreferencesRappelsProvider).surveiller(),
);

final reviserLoyerProvider = Provider<ReviserLoyer>(
  (ref) => ReviserLoyer(
    transactions: ref.watch(transactionsProvider),
    biens: ref.watch(bienRepositoryProvider),
    baux: ref.watch(bailRepositoryProvider),
    revisions: ref.watch(revisionRepositoryProvider),
    echeances: ref.watch(echeanceRepositoryProvider),
    gestionEcheances: ref.watch(gestionEcheancesProvider),
  ),
);

// ---------------------------------------------------------------------------
// Indices IRL
// ---------------------------------------------------------------------------

/// Client HTTP (remplacé dans les tests : aucun appel réseau réel).
final clientHttpProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Chemin de la table IRL embarquée.
const cheminTableIrl = 'assets/irl/irl.json';

final serviceIndicesIrlProvider = Provider<ServiceIndicesIrl>(
  (ref) => ServiceIndicesIrl(
    indices: ref.watch(indiceIrlRepositoryProvider),
    reglages: ref.watch(reglagesRepositoryProvider),
    lireTableEmbarquee: () => rootBundle.loadString(cheminTableIrl),
    client: ref.watch(clientHttpProvider),
  ),
);

/// Table des indices (du plus récent au plus ancien), après import de la
/// table embarquée.
final indicesIrlFluxProvider = StreamProvider<List<IndiceIrl>>((ref) async* {
  await ref.watch(serviceIndicesIrlProvider).importerTableEmbarquee();
  yield* ref.watch(indiceIrlRepositoryProvider).surveillerTous();
});

final serviceSauvegardeProvider = Provider<ServiceSauvegarde>(
  (ref) => ServiceSauvegarde(
    db: ref.watch(databaseProvider),
    documents: ref.watch(dossierDocumentsProvider),
  ),
);

/// Date de la dernière vérification réussie auprès de l'INSEE.
final derniereMiseAJourIrlProvider = FutureProvider.autoDispose<DateTime?>(
  (ref) => ref.watch(serviceIndicesIrlProvider).derniereMiseAJour(),
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

// ---------------------------------------------------------------------------
// Flux de la fiche d'un bien
// ---------------------------------------------------------------------------

final bienFluxProvider = StreamProvider.autoDispose.family<Bien?, String>(
  (ref, id) => ref.watch(bienRepositoryProvider).surveiller(id),
);

final bailActifFluxProvider = StreamProvider.autoDispose.family<Bail?, String>(
  (ref, bienId) =>
      ref.watch(bailRepositoryProvider).surveillerBailActif(bienId),
);

final locatairesFluxProvider = StreamProvider.autoDispose
    .family<List<Locataire>, String>(
      (ref, bailId) =>
          ref.watch(bailRepositoryProvider).surveillerLocataires(bailId),
    );

/// Toutes les échéances d'un bien (faites comprises), triées par date.
final echeancesBienFluxProvider = StreamProvider.autoDispose
    .family<List<Echeance>, String>(
      (ref, bienId) =>
          ref.watch(echeanceRepositoryProvider).surveillerParBien(bienId),
    );

/// Journal d'un bien pour une année : clé (bienId, année).
final mouvementsFluxProvider = StreamProvider.autoDispose
    .family<List<MouvementFinancier>, (String, int)>(
      (ref, cle) => ref
          .watch(financeRepositoryProvider)
          .surveillerMouvements(cle.$1, annee: cle.$2),
    );

/// Cases « Loyer reçu » d'un bien pour une année : clé (bienId, année).
final encaissementsFluxProvider = StreamProvider.autoDispose
    .family<List<EncaissementLoyer>, (String, int)>(
      (ref, cle) => ref
          .watch(financeRepositoryProvider)
          .surveillerEncaissements(cle.$1, cle.$2),
    );

final artisansFluxProvider = StreamProvider<List<Artisan>>(
  (ref) => ref.watch(artisanRepositoryProvider).surveillerTous(),
);

final interventionsFluxProvider = StreamProvider.autoDispose
    .family<List<Intervention>, String>(
      (ref, bienId) =>
          ref.watch(artisanRepositoryProvider).surveillerInterventions(bienId),
    );

/// Journal complet d'un bien (toutes années).
final mouvementsBienFluxProvider = StreamProvider.autoDispose
    .family<List<MouvementFinancier>, String>(
      (ref, bienId) =>
          ref.watch(financeRepositoryProvider).surveillerMouvements(bienId),
    );

final artisanProvider = FutureProvider.autoDispose.family<Artisan?, String>(
  (ref, id) => ref.watch(artisanRepositoryProvider).parId(id),
);

/// Révisions de loyer du bien, de la plus récente à la plus ancienne.
final historiqueRevisionsFluxProvider =
    StreamProvider.family<List<RevisionLoyer>, String>(
      (ref, bienId) =>
          ref.watch(revisionRepositoryProvider).surveillerHistorique(bienId),
    );

final revisionProvider = FutureProvider.autoDispose
    .family<RevisionLoyer?, String>(
      (ref, id) => ref.watch(revisionRepositoryProvider).parId(id),
    );
