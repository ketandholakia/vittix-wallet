import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_notification'); // Use your notification icon name

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    // Request permissions for Android 13+
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyReminder() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Daily Reminder',
      'Did you remember to record today\'s expenses?',
      _nextInstanceOf8PM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Channel for daily expense reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at the same time
    );
  }

  Future<void> showBudgetAlert(String categoryName, int percentage) async {
    await _flutterLocalNotificationsPlugin.show(
      categoryName.hashCode, // Use a unique ID based on the category
      'Budget Alert',
      'You have spent $percentage% of your budget for $categoryName.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alert_channel',
          'Budget Alerts',
          channelDescription: 'Channel for budget threshold alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20); // 8 PM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}