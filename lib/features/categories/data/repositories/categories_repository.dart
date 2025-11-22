import 'package:uuid/uuid.dart'; // Додай 'uuid: ^4.0.0' в pubspec.yaml
import '../models/category_model.dart';

class CategoriesRepository {
  // Імітація бази даних
  final List<CategoryModel> _mockCategories = [
    const CategoryModel(id: '1', name: 'Work'),
    const CategoryModel(id: '2', name: 'Study'),
    const CategoryModel(id: '3', name: 'Home'),
  ];

  Future<List<CategoryModel>> getCategories() async {
    // Імітація затримки
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockCategories);
  }

  Future<void> addCategory(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newCategory = CategoryModel(
      id: const Uuid().v4(),
      name: name,
    );
    _mockCategories.add(newCategory);
  }

  Future<void> updateCategory(CategoryModel category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockCategories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _mockCategories[index] = category;
    }
  }

  Future<void> deleteCategory(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCategories.removeWhere((c) => c.id == id);
  }
}