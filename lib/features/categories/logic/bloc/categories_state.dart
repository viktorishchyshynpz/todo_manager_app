import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';

enum CategoriesStatus { initial, loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> categories;
  final String? errorMessage;

  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? categories,
    String? errorMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, errorMessage];
}