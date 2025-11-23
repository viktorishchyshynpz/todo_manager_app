import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/categories_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository _repository;
  StreamSubscription? _categoriesSubscription;

  CategoriesBloc({required CategoriesRepository repository})
      : _repository = repository,
        super(const CategoriesState()) {
    on<LoadCategories>(_onLoadCategories);
    on<CategoriesUpdated>(_onCategoriesUpdated); // Нова подія
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    await _categoriesSubscription?.cancel();

    try {
      _categoriesSubscription = _repository.getCategoriesStream().listen(
            (categories) => add(CategoriesUpdated(categories)),
        onError: (error) => print(error), // Або обробка помилки
      );
    } catch (e) {
      emit(state.copyWith(status: CategoriesStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onCategoriesUpdated(
      CategoriesUpdated event, Emitter<CategoriesState> emit) {
    emit(state.copyWith(
      status: CategoriesStatus.success,
      categories: event.categories,
    ));
  }

  Future<void> _onAddCategory(
      AddCategory event, Emitter<CategoriesState> emit) async {
    try {
      await _repository.addCategory(event.name);
      // Не треба emit, бо стрім оновить список сам
    } catch (e) {
      emit(state.copyWith(status: CategoriesStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategory event, Emitter<CategoriesState> emit) async {
    try {
      await _repository.updateCategory(event.category);
    } catch (e) {
      emit(state.copyWith(status: CategoriesStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoriesState> emit) async {
    try {
      await _repository.deleteCategory(event.id);
    } catch (e) {
      emit(state.copyWith(status: CategoriesStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}