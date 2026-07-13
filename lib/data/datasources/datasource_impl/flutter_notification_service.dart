import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/datasources/notification_service.dart';

/// [NotificationService] implementation that delegates to the
/// [LocalNotificationService] mixin via the global [C] alias.
///
/// Registered in GetIt as the concrete [NotificationService] singleton.
class FlutterNotificationService implements NotificationService {
  @override
  Future<void> scheduleNotification(
    int id,
    int hour,
    int minute, {
    required String title,
    required String body,
  }) async {
    await C.scheduleNotification(id, hour, minute, title: title, body: body);
  }

  @override
  Future<void> cancelNotification(int id) async {
    await C.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }

  @override
  Future<List<dynamic>> checkScheduledNotifications() async {
    return await C.checkScheduledNotifications();
  }
}
