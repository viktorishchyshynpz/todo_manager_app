import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Map<String, Object> _filterNull(Map<String, dynamic> map) {
    map.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));
    return map.cast<String, Object>();
  }

  // --- Авторизація ---
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // --- Завдання ---
  Future<void> logTaskCreated({
    required String title,
    String? category,
    String? status,
    String? due,
  }) async {
    await _analytics.logEvent(
      name: 'task_created',
      parameters: _filterNull({
        'title': title,
        'category': category,
        'status': status,
        'due': due,
      }),
    );
  }

  Future<void> logTaskUpdated({
    required String title,
    String? category,
    String? status,
    String? due,
  }) async {
    await _analytics.logEvent(
      name: 'task_updated',
      parameters: _filterNull({
        'title': title,
        'category': category,
        'status': status,
        'due': due,
      }),
    );
  }

  Future<void> logTaskDeleted({
    required String title,
    String? category,
    String? status,
  }) async {
    await _analytics.logEvent(
      name: 'task_deleted',
      parameters: _filterNull({
        'title': title,
        'category': category,
        'status': status,
      }),
    );
  }

  // --- Категорії ---
  Future<void> logCategoryCreated(String name) async {
    await _analytics.logEvent(
      name: 'category_created',
      parameters: {'name': name},
    );
  }

  Future<void> logCategoryUpdated({
    required String oldName,
    required String newName,
  }) async {
    await _analytics.logEvent(
      name: 'category_updated',
      parameters: {
        'old_name': oldName,
        'new_name': newName,
      },
    );
  }

  Future<void> logCategoryDeleted(String name) async {
    await _analytics.logEvent(
      name: 'category_deleted',
      parameters: {'name': name},
    );
  }
}