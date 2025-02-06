import 'dart:developer';

import 'package:chat_location/pages/index.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification Controller
class NotificationController extends Notifier<FlutterLocalNotificationsPlugin> {
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  @override
  FlutterLocalNotificationsPlugin build() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _initializeNotifications();
    return _localNotificationsPlugin;
  }

  /// 초기화
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(NotificationResponse respoonse) {
    final String payload = respoonse.payload ?? "";
    if (respoonse.payload != null || respoonse.payload!.isNotEmpty) {
      streamController.add(payload);
    }
  }

  /// 알림 표시
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(id, title, body, notificationDetails,
        payload: 'chatMessage');
  }
}

/// Notification Controller Provider
final notificationControllerProvider =
    NotifierProvider<NotificationController, FlutterLocalNotificationsPlugin>(
  () => NotificationController(),
);
