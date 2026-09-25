import 'dart:io';

import 'package:bailleur_app/app/app.dart';
import 'package:bailleur_app/app/etat_app.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/notifications/service_notifications.dart';
import 'package:bailleur_app/data/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Date du jour figée pour des tests reproductibles.
class AujourdhuiFixe extends Aujourdhui {
  AujourdhuiFixe(this.date);
  final DateTime date;

  @override
  DateTime build() => date;
}

/// L'application complète sur une base en mémoire, sans notifications.
Widget appDeTest({
  required AppDatabase db,
  bool onboardingTermine = true,
  DateTime? aujourdhui,
  ServiceNotifications notifications = const NotificationsInactives(),
  List<Override> autres = const [],
}) => ProviderScope(
  overrides: [
    databaseProvider.overrideWithValue(db),
    dossierDocumentsProvider.overrideWithValue(Directory.systemTemp),
    onboardingTermineAuDemarrageProvider.overrideWithValue(onboardingTermine),
    serviceNotificationsProvider.overrideWithValue(notifications),
    if (aujourdhui != null)
      aujourdhuiProvider.overrideWith(() => AujourdhuiFixe(aujourdhui)),
    ...autres,
  ],
  child: const BailleurApp(),
);
