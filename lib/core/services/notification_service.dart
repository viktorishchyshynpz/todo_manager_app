import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../features/tasks/data/models/task_model.dart';
import '../../features/settings/data/repositories/settings_repository.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late final SettingsRepository _settingsRepository;
  bool _isInitialized = false;

  Future<void> initialize(SettingsRepository settingsRepository) async {
    if (_isInitialized) return;
    _settingsRepository = settingsRepository;

    // 1. Локальні сповіщення
    // Використовуємо дефолтну іконку, яку Android сам знайде в ресурсах
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Тут можна додати навігацію до конкретного завдання
        print("🔔 Notification clicked: ${details.payload}");
      },
    );

    // 2. Часові пояси (Ініціалізуємо базу даних тут, або в main)
    await _initTimezones();

    // 3. Дозволи (Android 13+)
    final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    // 4. Пуш сповіщення
    await _initPushNotifications();

    _isInitialized = true;
  }

  Future<void> _initTimezones() async {
    try {
      tz_data.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print('Error initializing timezone: $e');
      // Фолбек на UTC
      try { tz.setLocalLocation(tz.getLocation('UTC')); } catch (_) {}
    }
  }

  // --- SCHEDULING LOGIC ---

  Future<void> scheduleTaskNotifications(TaskModel task) async {
    // Перевіряємо налаштування
    if (!_settingsRepository.getEmailEnabled()) return;

    // Не плануємо для виконаних або без дати
    if (task.dueDate == null || task.status == TaskStatus.completed || task.status == TaskStatus.canceled) {
      await cancelTaskNotifications(task);
      return;
    }

    final dueDate = task.dueDate!;
    final now = DateTime.now();

    final id24h = task.notificationId;
    final id1h = task.notificationId + 1;

    // 1. Нагадування за 24 години
    final scheduledDate24h = dueDate.subtract(const Duration(days: 1));
    if (scheduledDate24h.isAfter(now)) {
      await _scheduleSingle(
        id: id24h,
        title: 'Нагадування про завдання',
        body: 'Завтра дедлайн: "${task.title}" о ${task.dueDate!.hour}:${task.dueDate!.minute.toString().padLeft(2, '0')}',
        date: scheduledDate24h,
        taskId: task.id,
      );
    }

    // 2. Нагадування за 1 годину
    final scheduledDate1h = dueDate.subtract(const Duration(hours: 1));
    if (scheduledDate1h.isAfter(now)) {
      await _scheduleSingle(
        id: id1h,
        title: 'Дедлайн близько!',
        body: 'Залишилась 1 година: "${task.title}"',
        date: scheduledDate1h,
        taskId: task.id,
      );
    }
  }

  Future<void> _scheduleSingle({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    required String taskId,
  }) async {
    try {
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(date, tz.local), // Конвертуємо в локальний час
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'todo_reminders_channel', // Стабільний ID каналу
            'Task Reminders',
            channelDescription: 'Notifications for task deadlines',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Дозволяє будити телефон
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: taskId,
      );
      print("✅ Scheduled ID $id at $date");
    } catch (e) {
      print('❌ Error scheduling: $e');
    }
  }

  Future<void> cancelTaskNotifications(TaskModel task) async {
    await _localNotifications.cancel(task.notificationId);
    await _localNotifications.cancel(task.notificationId + 1);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // --- PUSH LOGIC ---

  Future<void> _initPushNotifications() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null && _settingsRepository.getPushEnabled()) {
            _showForegroundNotification(message);
          }
        });
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      }
    } catch (e) {
      print('Error init push: $e');
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'push_channel',
          'Push Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> togglePushNotifications(bool isEnabled) async {
    if (isEnabled) {
      await _firebaseMessaging.subscribeToTopic('general');
    } else {
      await _firebaseMessaging.unsubscribeFromTopic('general');
    }
  }
}