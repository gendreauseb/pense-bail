import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/etat_app.dart';
import 'app/licences.dart';
import 'core/config/cles_reglages.dart';
import 'core/format/formats.dart';
import 'data/local/database.dart';
import 'data/notifications/service_notifications.dart';
import 'data/providers.dart';
import 'data/repositories/drift_repositories.dart';
import 'domain/usecases/preferences_rappels.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  enregistrerLicencesPolices();
  Intl.defaultLocale = Formats.locale;
  await initializeDateFormatting(Formats.locale);

  final db = AppDatabase();
  final onboardingTermine =
      await DriftReglagesRepository(db).lire(ClesReglages.onboardingTermine) ==
      'true';
  final documents = await getApplicationDocumentsDirectory();
  final preferences = GestionPreferencesRappels(
    transactions: DriftTransactions(db),
    reglages: DriftReglagesRepository(db),
    echeances: DriftEcheanceRepository(db),
  );
  final notifications = NotificationsLocales(
    db: db,
    echeances: DriftEcheanceRepository(db),
    biens: DriftBienRepository(db),
    preferences: preferences.lire,
  );

  final conteneur = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      dossierDocumentsProvider.overrideWithValue(documents),
      onboardingTermineAuDemarrageProvider.overrideWithValue(onboardingTermine),
      serviceNotificationsProvider.overrideWithValue(notifications),
    ],
  );

  void ouvrirEcheance(String id) =>
      conteneur.read(echeanceAOuvrirProvider.notifier).ouvrir(id);

  final lanceeParNotification = await notifications.initialiser(
    onOuverture: ouvrirEcheance,
  );
  if (lanceeParNotification != null) ouvrirEcheance(lanceeParNotification);

  runApp(
    UncontrolledProviderScope(container: conteneur, child: const BailleurApp()),
  );
}
