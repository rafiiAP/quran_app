part of 'main_function.dart';

mixin LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotif() async {
    if (Platform.isIOS) {
      await requestNotificationPermission();
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

  Future<void> requestNotificationPermission() async {
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
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

  Future<void> scheduleNotification(
    final int id,
    final int hour,
    final int minute, {
    final String? body,
    final String? title,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime;
    scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      //kalau sudah lewat maka dijadwalkan untuk besoknya
      scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
      C.showLog(log: "Waktu sudah lewat, tidak bisa menjadwalkan notifikasi.");
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(final int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> checkScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await FlutterLocalNotificationsPlugin().pendingNotificationRequests();

    for (final PendingNotificationRequest notif in pendingNotifications) {
      C.showLog(
          log:
              '--📅 Notifikasi ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}, ${notif.payload}');
    }

    if (pendingNotifications.isEmpty) {
      C.showLog(log: "--🚫 Tidak ada notifikasi yang terjadwal.");
    }

    return pendingNotifications; // Tidak lagi mengembalikan null
  }
}
