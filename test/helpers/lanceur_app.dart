import 'dart:io';

import 'package:pense_bail/app/app.dart';
import 'package:pense_bail/app/etat_app.dart';
import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/notifications/service_notifications.dart';
import 'package:pense_bail/data/providers.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/repositories/repositories.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Date du jour figée pour des tests reproductibles.
class AujourdhuiFixe extends Aujourdhui {
  AujourdhuiFixe(this.date);
  final DateTime date;

  @override
  DateTime build() => date;
}

/// Réseau indisponible : aucun appel réel pendant les tests.
final reseauIndisponible = MockClient(
  (_) async => http.Response('', HttpStatus.serviceUnavailable),
);

/// Droits fixés pour un test (version gratuite ou Premium).
class DroitsFixes implements SourceDroits {
  const DroitsFixes(this.droits);
  final Droits droits;

  @override
  Stream<Droits> surveiller() => Stream.value(droits);
}

/// L'application complète sur une base en mémoire, sans notifications ni
/// réseau. Premium par défaut : toutes les fonctionnalités sont ouvertes.
///
/// [estBeta] : version bêta réelle, les droits viennent alors du réglage
/// simulé (DroitsBeta) et [droits] est ignoré.
Widget appDeTest({
  required AppDatabase db,
  bool onboardingTermine = true,
  DateTime? aujourdhui,
  Droits droits = Droits.premium,
  bool estBeta = false,
  ServiceNotifications notifications = const NotificationsInactives(),
  List<Override> autres = const [],
}) => ProviderScope(
  overrides: [
    databaseProvider.overrideWithValue(db),
    dossierDocumentsProvider.overrideWithValue(Directory.systemTemp),
    onboardingTermineAuDemarrageProvider.overrideWithValue(onboardingTermine),
    serviceNotificationsProvider.overrideWithValue(notifications),
    clientHttpProvider.overrideWithValue(reseauIndisponible),
    if (estBeta)
      estBetaProvider.overrideWithValue(true)
    else
      sourceDroitsProvider.overrideWithValue(DroitsFixes(droits)),
    if (aujourdhui != null)
      aujourdhuiProvider.overrideWith(() => AujourdhuiFixe(aujourdhui)),
    ...autres,
  ],
  child: const BailleurApp(),
);
