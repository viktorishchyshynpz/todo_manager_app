import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TasksRepository {
  final List<TaskModel> _mockTasks = [
    TaskModel(
      id: const Uuid().v4(),
      title: 'Finish Lab 5',
      description: 'Implement BLoC pattern',
      categoryName: 'Study',
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    TaskModel(
      id: const Uuid().v4(),
      title: 'Buy groceries',
      description: 'Milk, Bread, Eggs',
      categoryName: 'Home',
      status: TaskStatus.new_,
      dueDate: DateTime.now().add(const Duration(hours: 5)),
    ),
  ];

  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_mockTasks);
  }

  Future<void> addTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTasks.add(task);
  }

  Future<void> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _mockTasks[index] = task;
    }
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTasks.removeWhere((t) => t.id == id);
  }
}