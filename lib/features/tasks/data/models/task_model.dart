import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

enum TaskStatus { new_, inProgress, completed, canceled }

extension TaskStatusX on TaskStatus {
  String toLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case TaskStatus.new_:
        return l10n.statusNew;
      case TaskStatus.inProgress:
        return l10n.statusInProgress;
      case TaskStatus.completed:
        return l10n.statusCompleted;
      case TaskStatus.canceled:
        return l10n.statusCanceled;
    }
  }
}

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String? description;     // Може бути null
  final String? categoryName;    // Може бути null
  final TaskStatus status;       // Залишимо обов'язковим, але з дефолтним значенням
  final DateTime? dueDate;       // Може бути null

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.categoryName,
    this.status = TaskStatus.new_, // Значення за замовчуванням
    this.dueDate,
  });

  // Зручний метод для перевірки, чи прострочене завдання
  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now()) && status != TaskStatus.completed;
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryName,
    TaskStatus? status,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [id, title, description, categoryName, status, dueDate];
}