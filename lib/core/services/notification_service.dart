/// Abstract interface for scheduling and managing local notifications.
///
/// Implementation: [FlutterNotificationService].
abstract class NotificationService {
  /// Initializes the notification plugin and timezone data.
  /// Must be called once during app startup before scheduling notifications.
  Future<void> initLocalNotif();

  /// Schedules a daily repeating notification at [hour]:[minute].
  ///
  /// [id] must be unique per prayer. If the time has already passed today
  /// the notification is automatically scheduled for tomorrow.
  Future<void> scheduleNotification(
    int id,
    int hour,
    int minute, {
    required String title,
    required String body,
  });

  /// Cancels the notification with the given [id].
  Future<void> cancelNotification(int id);

  /// Cancels all pending notifications.
  Future<void> cancelAllNotifications();

  /// Returns all currently pending/scheduled notifications.
  Future<List<dynamic>> checkScheduledNotifications();
}
