import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// [NotificationService] implementation using flutter_local_notifications.
///
/// Registered in GetIt as the concrete [NotificationService] singleton.
class FlutterNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the local notification plugin and timezone data.
  @override
  Future<void> initLocalNotif() async {
    if (Platform.isIOS) {
      await _requestIOSNotificationPermission();
    }
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> _requestIOSNotificationPermission() async {
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (granted != null && granted) {
      _log('--Izin notifikasi diberikan.');
    } else {
      _log('--Izin notifikasi ditolak.');
    }
  }

  @override
  Future<void> scheduleNotification(
    int id,
    int hour,
    int minute, {
    required String title,
    required String body,
  }) async {
    final tzlocal = await FlutterTimezone.getLocalTimezone();
    final local = tz.getLocation(tzlocal);

    final tz.TZDateTime now = tz.TZDateTime.now(local);
    tz.TZDateTime scheduledTime;
    scheduledTime = tz.TZDateTime(
      local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    _log('--schedule = $scheduledTime - now = $now');

    if (scheduledTime.isBefore(now)) {
      scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
      _log('Waktu sudah lewat, tidak bisa menjadwalkan notifikasi.');
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'adzan_channel',
      'Notifikasi Adzan',
      channelDescription: 'Notifikasi terjadwal setiap hari',
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('adzan'),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adzan.aiff',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  @override
  Future<List<dynamic>> checkScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    for (final PendingNotificationRequest notif in pendingNotifications) {
      _log(
        '--📅 Notifikasi ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}, ${notif.payload}',
      );
    }

    if (pendingNotifications.isEmpty) {
      _log('--🚫 Tidak ada notifikasi yang terjadwal.');
    }

    return pendingNotifications;
  }

  void _log(dynamic message) {
    if (config.lShowLog) dev.log('$message');
  }
}
