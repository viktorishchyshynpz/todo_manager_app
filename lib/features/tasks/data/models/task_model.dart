import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

enum TaskStatus { new_, inProgress, completed, canceled }

extension TaskStatusX on TaskStatus {
  String toLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case TaskStatus.new_: return l10n.statusNew;
      case TaskStatus.inProgress: return l10n.statusInProgress;
      case TaskStatus.completed: return l10n.statusCompleted;
      case TaskStatus.canceled: return l10n.statusCanceled;
    }
  }
}

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? categoryName;
  final TaskStatus status;
  final DateTime? dueDate;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.categoryName,
    this.status = TaskStatus.new_,
    this.dueDate,
  });

  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now()) && status != TaskStatus.completed;
  }

  // Унікальний ID для сповіщень
  int get notificationId => id.hashCode;

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      categoryName: data['categoryName'],
      status: TaskStatus.values.firstWhere(
            (e) => e.name == (data['status'] ?? 'new_'),
        orElse: () => TaskStatus.new_,
      ),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'categoryName': categoryName,
      'status': status.name,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
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