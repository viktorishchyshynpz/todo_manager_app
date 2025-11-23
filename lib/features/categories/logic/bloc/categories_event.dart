import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoriesEvent {}

class AddCategory extends CategoriesEvent {
  final String name;
  const AddCategory(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateCategory extends CategoriesEvent {
  final CategoryModel category;
  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoriesUpdated extends CategoriesEvent {
  final List<CategoryModel> categories;
  const CategoriesUpdated(this.categories);
  @override
  List<Object?> get props => [categories];
}

class DeleteCategory extends CategoriesEvent {
  final String id;
  const DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}