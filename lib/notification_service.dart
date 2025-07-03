import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  int notificationCount = 0; // Kuhesabu notifications mpya

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      importance: Importance.max,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);

    notificationCount++; // Ongeza idadi ya notifications mpya
    await _notificationsPlugin.show(0, title, body, details);
  }

  int getNotificationCount() => notificationCount; // Kurudisha idadi ya notifications mpya
}