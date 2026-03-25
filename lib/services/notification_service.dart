import 'package:flutter/material.dart'; // For TimeOfDay
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Using 'settings' named parameter as requested by error
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    await Permission.notification.request();
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    int offsetMinutes = 0,
    int? silentStart,
    int? silentEnd,
  }) async {
    await flutterLocalNotificationsPlugin.cancelAll();

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).subtract(Duration(minutes: offsetMinutes));

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Check silent hours
    if (silentStart != null && silentEnd != null) {
      final hour = scheduledDate.hour;
      bool isSilent = false;
      if (silentStart < silentEnd) {
        isSilent = hour >= silentStart && hour < silentEnd;
      } else {
        // e.g. 22:00 to 06:00
        isSilent = hour >= silentStart || hour < silentEnd;
      }

      if (isSilent) {
        debugPrint(
          'Skipping notification: falling within silent hours ($silentStart-$silentEnd)',
        );
        return;
      }
    }

    // Checking error: "The named parameter 'id' is required", "scheduledDate is required"...
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Kaza Reminder',
      body: 'Time to log your prayers!',
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Reminds you to track prayers daily',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation: UiLocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
