import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _repository;
  StreamSubscription? _tasksSubscription;

  TasksBloc({required TasksRepository repository})
      : _repository = repository,
        super(const TasksState()) {
    on<LoadTasks>(_onLoadTasks);
    on<TasksUpdated>(_onTasksUpdated); // Нова подія (внутрішня)
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));

    // Відписуємося від попереднього потоку, якщо він був
    _tasksSubscription?.cancel();

    try {
      // Підписуємося на потік з Firestore
      _tasksSubscription = _repository.getTasksStream().listen(
              (tasks) {
            add(TasksUpdated(tasks)); // Коли приходять дані, викликаємо подію
          },
          onError: (error) {
            // Обробка помилок стрима
            // Можна додати подію TasksError(error)
          }
      );
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  // Обробник нової події
  void _onTasksUpdated(TasksUpdated event, Emitter<TasksState> emit) {
    emit(state.copyWith(
      status: TasksStatus.success,
      tasks: event.tasks,
    ));
  }

  // Add/Update/Delete залишаються майже такими ж,
  // але можна прибрати add(LoadTasks()), бо Stream оновиться сам!

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    try {
      await _repository.addTask(event.task);
      // Не треба викликати LoadTasks, Firestore надішле оновлення автоматично
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  // Аналогічно для update і delete - просто викликаємо репозиторій
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    // Оптимістичне оновлення можна залишити, або прибрати,
    // бо Firestore працює дуже швидко і має офлайн кеш.
    try {
      await _repository.updateTask(event.task);
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      await _repository.deleteTask(event.taskId);
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