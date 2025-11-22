import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/categories_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository _repository;

  CategoriesBloc({required CategoriesRepository repository})
      : _repository = repository,
        super(const CategoriesState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        status: CategoriesStatus.success,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddCategory(
      AddCategory event, Emitter<CategoriesState> emit) async {
    // Оптимістичне оновлення: можна показати завантаження, або ні
    // Для простоти показуємо завантаження
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      await _repository.addCategory(event.name);
      // Перезавантажуємо список
      add(LoadCategories());
    } catch (e) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategory event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      await _repository.updateCategory(event.category);
      add(LoadCategories());
    } catch (e) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      await _repository.deleteCategory(event.id);
      add(LoadCategories());
    } catch (e) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}