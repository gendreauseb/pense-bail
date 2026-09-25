import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_donnees;
import 'package:timezone/timezone.dart' as tz;

import '../../app/design/app_colors.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/planification_rappels.dart';
import '../local/database.dart';

/// Rappels sur le téléphone (notifications locales).
abstract interface class ServiceNotifications {
  /// Les notifications sont-elles autorisées par l'utilisateur ?
  Future<bool> sontAutorisees();

  /// Affiche la demande d'autorisation du système. Retourne le résultat.
  Future<bool> demanderAutorisation();

  /// Reprogramme toutes les notifications à partir de la base.
  Future<void> synchroniser();
}

/// Implémentation inactive (tests, plateformes non gérées).
class NotificationsInactives implements ServiceNotifications {
  const NotificationsInactives({this.autorisees = true});
  final bool autorisees;

  @override
  Future<bool> sontAutorisees() async => autorisees;

  @override
  Future<bool> demanderAutorisation() async => autorisees;

  @override
  Future<void> synchroniser() async {}
}

/// Implémentation avec flutter_local_notifications.
class NotificationsLocales implements ServiceNotifications {
  NotificationsLocales({
    required this._db,
    required this._echeances,
    required this._biens,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final AppDatabase _db;
  final EcheanceRepository _echeances;
  final BienRepository _biens;
  final FlutterLocalNotificationsPlugin _plugin;

  StreamSubscription<void>? _abonnement;
  Timer? _minuterie;

  static final _canal = AndroidNotificationDetails(
    'rappels_echeances',
    'Rappels d\'échéances',
    channelDescription:
        'Vous prévient avant une révision de loyer, une fin de bail, '
        'une taxe…',
    icon: 'ic_notification',
    color: AppColors.clair.primary,
  );
  static final _details = NotificationDetails(
    android: _canal,
    iOS: const DarwinNotificationDetails(),
  );
  static const _delaiSynchronisation = Duration(milliseconds: 800);

  /// À appeler une fois au démarrage. [onOuverture] reçoit l'identifiant de
  /// l'échéance quand l'utilisateur touche une notification.
  /// Retourne l'échéance à ouvrir si l'app a été lancée par une notification.
  Future<String?> initialiser({
    required void Function(String echeanceId) onOuverture,
  }) async {
    tz_donnees.initializeTimeZones();
    try {
      final fuseau = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(fuseau.identifier));
    } catch (e) {
      debugPrint('Fuseau horaire introuvable, Europe/Paris utilisé : $e');
      tz.setLocalLocation(tz.getLocation('Europe/Paris'));
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        // L'autorisation est demandée plus tard, au bon moment.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (reponse) {
        final id = reponse.payload;
        if (id != null) onOuverture(id);
      },
    );

    // Reprogrammation automatique à chaque changement en base.
    _abonnement = _db
        .tableUpdates(
          TableUpdateQuery.onAllTables([_db.echeances, _db.rappels, _db.biens]),
        )
        .listen((_) => _planifierSynchronisation());
    unawaited(synchroniser());

    final lancement = await _plugin.getNotificationAppLaunchDetails();
    return (lancement?.didNotificationLaunchApp ?? false)
        ? lancement?.notificationResponse?.payload
        : null;
  }

  void _planifierSynchronisation() {
    _minuterie?.cancel();
    _minuterie = Timer(_delaiSynchronisation, synchroniser);
  }

  @override
  Future<bool> sontAutorisees() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final options = await ios?.checkPermissions();
    return options?.isEnabled ?? false;
  }

  @override
  Future<bool> demanderAutorisation() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  @override
  Future<void> synchroniser() async {
    try {
      final echeances = await _echeances.aFaire();
      final rappels = await _echeances.tousLesRappels();
      final biens = await _biens.tous();
      final plan = PlanificationRappels.planifier(
        echeances: echeances,
        rappels: rappels,
        nomsBiens: {for (final b in biens) b.id: b.nom},
        maintenant: DateTime.now(),
      );

      await _plugin.cancelAllPendingNotifications();
      for (final r in plan) {
        await _plugin.zonedSchedule(
          id: r.id,
          title: r.titre,
          body: r.corps,
          payload: r.echeanceId,
          scheduledDate: tz.TZDateTime(
            tz.local,
            r.quand.year,
            r.quand.month,
            r.quand.day,
            r.quand.hour,
            r.quand.minute,
          ),
          notificationDetails: _details,
          // Heure approximative : pas besoin de l'autorisation « alarmes
          // exactes » (quelques minutes d'écart n'ont pas d'importance).
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('Programmation des rappels impossible : $e');
    }
  }

  void fermer() {
    _minuterie?.cancel();
    _abonnement?.cancel();
  }
}
