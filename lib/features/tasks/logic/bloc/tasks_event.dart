import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final TaskModel task;
  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TasksEvent {
  final TaskModel task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class TasksUpdated extends TasksEvent {
  final List<TaskModel> tasks;
  const TasksUpdated(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class DeleteTask extends TasksEvent {
  final String taskId;
  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}