import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  // Метод копіювання для зручного редагування
  CategoryModel copyWith({
    String? id,
    String? name,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}