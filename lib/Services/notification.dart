import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    // Request notification permission for Android
    if (await Permission.notification.request().isGranted) {
      // Permission granted, proceed with initialization
      var initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher'); // Specify launcher icon

      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      try {
        await _notificationsPlugin.initialize(
          initializationSettings,
        );
      } catch (e) {
        print('Error initializing notifications: $e');
      }
    } else {
      // Permission denied, handle it appropriately (e.g., show a dialog)
      print("Notification permission denied");
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String payload = 'item x',
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId', // id for the channel
      'channelName', // name of the channel
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
