import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  // This assumes the service is a singleton and initialized at startup.
  return NotificationService();
});