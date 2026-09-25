import 'package:bailleur_app/data/local/database.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';

/// Base SQLite en mémoire, neuve pour chaque test.
AppDatabase baseDeTest() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}
