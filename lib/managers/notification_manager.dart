import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/work_day.dart';
import 'work_data_manager.dart';

class NotificationManager extends ChangeNotifier {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 18, minute: 0);

  bool get notificationsEnabled => _notificationsEnabled;
  TimeOfDay get notificationTime => _notificationTime;

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));

    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Load saved settings
    await _loadSettings();
  }

  Future<void> _onNotificationTap(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      final dataManager = WorkDataManager();
      final today = DateTime.now();

      switch (payload) {
        case 'office':
          await dataManager.setWorkType(today, WorkType.office);
          break;
        case 'remote':
          await dataManager.setWorkType(today, WorkType.remote);
          break;
        case 'dayOff':
          await dataManager.setWorkType(today, WorkType.dayOff);
          break;
      }
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _saveSettings();

    if (enabled) {
      await requestPermission();
    } else {
      await cancelNotifications();
    }
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    notifyListeners();
    await _saveSettings();
    if (_notificationsEnabled) {
      await scheduleNotification();
    }
  }

  Future<bool> requestPermission() async {
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final iosPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    bool granted = false;

    if (androidPlugin != null) {
      granted = await androidPlugin.requestNotificationsPermission() ?? false;
    }

    if (iosPlugin != null) {
      granted = await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    if (granted) {
      _notificationsEnabled = true;
      notifyListeners();
      await scheduleNotification();
    } else {
      _notificationsEnabled = false;
      notifyListeners();
    }

    return granted;
  }

  Future<void> scheduleNotification() async {
    if (!_notificationsEnabled) return;

    await cancelNotifications();

    const androidDetails = AndroidNotificationDetails(
      'daily_work_reminder',
      'Daily Work Reminder',
      channelDescription: 'Daily reminder to log your work location',
      importance: Importance.high,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('office', 'Biuro 🏢'),
        AndroidNotificationAction('remote', 'Zdalnie 🏠'),
        AndroidNotificationAction('dayOff', 'Urlop 🌴'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'WORK_REMINDER',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _notificationTime.hour,
      _notificationTime.minute,
    );

    // If the scheduled time is in the past, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      'Be selfish',
      'Czy pracowałeś dzisiaj w biurze?',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotifications() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancel(0);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setInt('notificationHour', _notificationTime.hour);
    await prefs.setInt('notificationMinute', _notificationTime.minute);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    final hour = prefs.getInt('notificationHour') ?? 18;
    final minute = prefs.getInt('notificationMinute') ?? 0;
    _notificationTime = TimeOfDay(hour: hour, minute: minute);
    notifyListeners();
  }
}

