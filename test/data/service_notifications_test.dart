import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/notifications/service_notifications.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/usecases/gestion_biens.dart';
import 'package:pense_bail/domain/usecases/preferences_rappels.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_donnees;
import 'package:timezone/timezone.dart' as tz;

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';
import '../helpers/lanceur_app.dart';

/// Retient les notifications programmées (échéance de chacune).
class _PluginFactice implements FlutterLocalNotificationsPlugin {
  final programmees = <String>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    switch (invocation.memberName) {
      case #cancelAllPendingNotifications:
        programmees.clear();
      case #zonedSchedule:
        programmees.add(invocation.namedArguments[#payload] as String);
    }
    return Future<void>.value();
  }
}

/// Version gratuite : pas de notification pour les biens en lecture seule.
void main() {
  late AppDatabase db;
  late _PluginFactice plugin;
  late DriftEcheanceRepository echeances;

  setUpAll(() {
    tz_donnees.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Paris'));
  });

  setUp(() async {
    db = baseDeTest();
    plugin = _PluginFactice();
    echeances = DriftEcheanceRepository(db);
    final aujourdhui = DateTime.now();
    final gestion = GestionBiens(
      transactions: DriftTransactions(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: echeances,
      droits: () async => Droits.premium,
    );
    // « studio », le plus ancien, reste actif en version gratuite.
    for (final (id, creeLe) in [
      ('studio', DateTime(2025)),
      ('t2', DateTime(2026)),
    ]) {
      await gestion.creer(
        bien: unBien(id: id, creeLe: creeLe),
        bail: unBail(id: 'bail-$id', bienId: id, debut: DateTime(2024, 3, 1)),
        aujourdhui: aujourdhui,
      );
    }
  });
  tearDown(() => db.close());

  Future<Set<String?>> biensNotifies(Droits droits) async {
    final service = NotificationsLocales(
      db: db,
      echeances: echeances,
      biens: DriftBienRepository(db),
      preferences: GestionPreferencesRappels(
        transactions: DriftTransactions(db),
        reglages: DriftReglagesRepository(db),
        echeances: echeances,
      ).lire,
      droits: () => DroitsFixes(droits),
      plugin: plugin,
    );
    await service.synchroniser();
    return {
      for (final id in plugin.programmees) (await echeances.parId(id))!.bienId,
    };
  }

  test('Premium : tous les biens sont notifiés', () async {
    expect(await biensNotifies(Droits.premium), containsAll(['studio', 't2']));
  });

  test('version gratuite : seulement le bien actif', () async {
    final notifies = await biensNotifies(Droits.gratuit);
    expect(notifies, contains('studio'));
    expect(notifies, isNot(contains('t2')));
  });
}
