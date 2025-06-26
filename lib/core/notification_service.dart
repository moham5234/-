import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  static void initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'appointments_channel',
          channelName: 'مواعيد',
          channelDescription: 'إشعارات مواعيد التطبيق',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          ledColor: Colors.white,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      ],
    );
  }

  void scheduleNotificationBeforeOneHour({
    required int id,
    required String title,
    required String body,
    required DateTime appointmentDateTime,
  }) {
    final notificationTime = appointmentDateTime.subtract(const Duration(hours: 1));

    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'appointments_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: notificationTime.year,
        month: notificationTime.month,
        day: notificationTime.day,
        hour: notificationTime.hour,
        minute: notificationTime.minute,
        second: notificationTime.second,
        millisecond: 0,
        repeats: false,
      ),
    );
  }
}
