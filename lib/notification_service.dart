import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyReminder() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminders',
        channelDescription: 'Channel for daily expense reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    final scheduledTime = _nextInstanceOf8PM();

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Daily Reminder',
        'Did you remember to record today\'s expenses?',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Daily Reminder',
        'Did you remember to record today\'s expenses?',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> showBudgetAlert(String categoryName, int percentage) async {
    await _flutterLocalNotificationsPlugin.show(
      categoryName.hashCode,
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

  Future<void> showRecurringNotification(String templateName, String amountString) async {
    await _flutterLocalNotificationsPlugin.show(
      templateName.hashCode,
      'Recurring Transaction Created',
      'Auto-created transaction for "$templateName" of $amountString.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'recurring_channel',
          'Recurring Transactions',
          channelDescription: 'Channel for recurring transaction alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
