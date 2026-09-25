import 'dart:async';

import 'package:bailleur_app/core/format/formats.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Exécuté avant chaque fichier de test : formats français, comme dans
/// main.dart.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  Intl.defaultLocale = Formats.locale;
  await initializeDateFormatting(Formats.locale);
  await testMain();
}
