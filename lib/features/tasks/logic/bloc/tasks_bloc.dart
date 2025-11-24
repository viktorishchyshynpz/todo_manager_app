import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _repository;
  final NotificationService _notificationService = NotificationService.instance;
  StreamSubscription? _tasksSubscription;

  TasksBloc({required TasksRepository repository})
      : _repository = repository,
        super(const TasksState()) {
    on<LoadTasks>(_onLoadTasks);
    on<TasksUpdated>(_onTasksUpdated);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));

    _tasksSubscription?.cancel();

    try {
      _tasksSubscription = _repository.getTasksStream().listen(
              (tasks) {
            add(TasksUpdated(tasks));
          },
          onError: (error) {
            // Error handling
          }
      );
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TasksState> emit) {
    emit(state.copyWith(
      status: TasksStatus.success,
      tasks: event.tasks,
    ));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    try {
      await _repository.addTask(event.task);
      // Плануємо сповіщення
      await _notificationService.scheduleTaskNotifications(event.task);
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    try {
      await _repository.updateTask(event.task);
      // Оновлюємо сповіщення
      await _notificationService.scheduleTaskNotifications(event.task);
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    // Знаходимо завдання для скасування сповіщення
    final taskToDelete = state.tasks.firstWhere((t) => t.id == event.taskId, orElse: () => throw Exception("Task not found"));

    emit(state.copyWith(status: TasksStatus.loading));
    try {
      await _repository.deleteTask(event.taskId);
      // Скасовуємо сповіщення
      await _notificationService.cancelTaskNotifications(taskToDelete);
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}