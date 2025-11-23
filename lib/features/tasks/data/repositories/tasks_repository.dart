import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TasksRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TasksRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Допоміжний метод для отримання шляху до колекції завдань поточного юзера
  CollectionReference _getTasksCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  // Отримання потоку даних (Real-time updates)
  Stream<List<TaskModel>> getTasksStream() {
      return _getTasksCollection()
          .orderBy('dueDate', descending: false) // Сортування (опціонально)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
      });
  }

  Future<void> addTask(TaskModel task) async {
    // Firestore сам згенерує ID, якщо ми використаємо .add(),
    // але у нас в моделі вже є ID (UUID), тому використовуємо .doc(id).set()
    await _getTasksCollection().doc(task.id).set(task.toFirestore());
  }

  Future<void> updateTask(TaskModel task) async {
    await _getTasksCollection().doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String id) async {
    await _getTasksCollection().doc(id).delete();
  }
}