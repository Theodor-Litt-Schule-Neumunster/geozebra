import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class NotificationsProvider {
  static final NotificationsProvider _instance = NotificationsProvider._internal();
  factory NotificationsProvider() => _instance;
  NotificationsProvider._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (!kIsWeb) {
      // Mobile initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          debugPrint('Notification clicked');
        },
      );
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      // Web notification
      if (html.Notification.permission == 'granted' || 
          await html.Notification.requestPermission() == 'granted') {
        html.Notification(title, body: body);
      }
    } else {
      // Mobile notification
      try {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'default_channel', // channel Id
          'Default Channel', // channel Name
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        await flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          platformChannelSpecifics,
        );
      } catch (e) {
        debugPrint('Error showing notification: $e');
      }
    }
  }
}
