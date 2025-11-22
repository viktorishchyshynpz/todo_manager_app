import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _repository;

  TasksBloc({required TasksRepository repository})
      : _repository = repository,
        super(const TasksState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      final tasks = await _repository.getTasks();
      emit(state.copyWith(status: TasksStatus.success, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    // Для додавання можна залишити loading, або теж зробити оптимістично
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      await _repository.addTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  // --- ОПТИМІСТИЧНЕ ОНОВЛЕННЯ (МИТТЄВЕ) ---
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    // 1. Створюємо новий список завдань локально, замінюючи змінене завдання
    final updatedTasks = state.tasks.map((t) {
      return t.id == event.task.id ? event.task : t;
    }).toList();

    // 2. Одразу емітимо новий стан БЕЗ статусу loading
    // Користувач бачить зміни миттєво
    emit(state.copyWith(
      tasks: updatedTasks,
      status: TasksStatus.success,
    ));

    try {
      // 3. Відправляємо запит в репозиторій (у "фон")
      await _repository.updateTask(event.task);

      // Нам не потрібно викликати add(LoadTasks()), бо список вже актуальний
    } catch (e) {
      // 4. Якщо помилка — відкочуємо зміни (перезавантажуємо реальні дані з сервера)
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: "Failed to update: ${e.toString()}"));
      add(LoadTasks());
    }
  }

  // --- ОПТИМІСТИЧНЕ ВИДАЛЕННЯ (МИТТЄВЕ) ---
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    // 1. Видаляємо завдання з локального списку
    final updatedTasks = state.tasks.where((t) => t.id != event.taskId).toList();

    // 2. Оновлюємо UI миттєво
    emit(state.copyWith(
      tasks: updatedTasks,
      status: TasksStatus.success,
    ));

    try {
      // 3. Видаляємо в репозиторії
      await _repository.deleteTask(event.taskId);
    } catch (e) {
      // 4. Відкат у разі помилки
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: "Failed to delete: ${e.toString()}"));
      add(LoadTasks());
    }
  }
}

/*import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _repository;

  TasksBloc({required TasksRepository repository})
      : _repository = repository,
        super(const TasksState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      final tasks = await _repository.getTasks();
      emit(state.copyWith(status: TasksStatus.success, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      await _repository.addTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      await _repository.updateTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));
    try {
      await _repository.deleteTask(event.taskId);
      add(LoadTasks());
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }
}*/