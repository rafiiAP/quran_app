import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();

  LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _instance;
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (Platform.isIOS) {
      await requestNotificationPermission();
    }
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    InitializationSettings settings = const InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> requestNotificationPermission() async {
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (granted != null && granted) {
      C.showLog(log: "--Izin notifikasi diberikan.");
    } else {
      C.showLog(log: "--Izin notifikasi ditolak.");
    }
  }

  // static Future<void> showNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  // }) async {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'channel_id',
  //     'channel_name',
  //     channelDescription: 'Channel Description',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );

  //   const NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);

  //   await _notificationsPlugin.show(id, title, body, details);
  // }

  static Future<void> scheduleNotification(
    int id,
    int hour,
    int minute, {
    String? body,
    String? title,
  }) async {
    final detroit = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(detroit);
    tz.TZDateTime scheduledTime;
    scheduledTime = tz.TZDateTime(
      detroit,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    C.showLog(log: '--🎯 TZDateTime (detroit): ${scheduledTime.toString()}');
    C.showLog(log: '--🕒 Sekarang (detroit): ${now.toString()}');

    if (scheduledTime.isBefore(now)) {
      //kalau sudah lewat maka dijadwalkan untuk besoknya
      scheduledTime = tz.TZDateTime(
        detroit,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
      C.showLog(log: "Waktu sudah lewat, tidak bisa menjadwalkan notifikasi.");
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Scheduled Notification',
      channelDescription: 'Notifikasi terjadwal setiap hari',
      importance: Importance.high,
      priority: Priority.high,
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future? checkScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await FlutterLocalNotificationsPlugin().pendingNotificationRequests();

    for (var notif in pendingNotifications) {
      C.showLog(log: '--📅 Notifikasi ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}, ${notif.payload}');
    }

    if (pendingNotifications.isEmpty) {
      C.showLog(log: "--🚫 Tidak ada notifikasi yang terjadwal.");
      return null;
    } else {
      return pendingNotifications;
    }
  }
}
