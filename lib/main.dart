import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/etat_app.dart';
import 'core/config/cles_reglages.dart';
import 'core/format/formats.dart';
import 'data/local/database.dart';
import 'data/providers.dart';
import 'data/repositories/drift_repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = Formats.locale;
  await initializeDateFormatting(Formats.locale);

  final db = AppDatabase();
  final onboardingTermine =
      await DriftReglagesRepository(db).lire(ClesReglages.onboardingTermine) ==
      'true';
  final documents = await getApplicationDocumentsDirectory();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        dossierDocumentsProvider.overrideWithValue(documents),
        onboardingTermineAuDemarrageProvider.overrideWithValue(
          onboardingTermine,
        ),
      ],
      child: const BailleurApp(),
    ),
  );
}
