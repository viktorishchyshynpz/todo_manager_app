import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category_model.dart';

class CategoriesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CategoriesRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Шлях до колекції категорій поточного юзера
  CollectionReference _getCategoriesCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('users').doc(userId).collection('categories');
  }

  // Отримання потоку категорій (Real-time)
  Stream<List<CategoryModel>> getCategoriesStream() {
    try {
      return _getCategoriesCollection()
          .orderBy('name') // Сортуємо за алфавітом
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  // Метод для сумісності зі старим кодом (якщо десь використовується Future)
  // Але краще переходити на Stream
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _getCategoriesCollection().get();
    return snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();
  }

  Future<void> addCategory(String name) async {
    // Додаємо нову категорію (Firestore згенерує ID)
    await _getCategoriesCollection().add({'name': name});
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _getCategoriesCollection().doc(category.id).update(category.toFirestore());
  }

  Future<void> deleteCategory(String id) async {
    await _getCategoriesCollection().doc(id).delete();
  }
}