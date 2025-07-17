import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_state.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/repositories/category_repository.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial());

  Future<void> loadCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await _repository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError("Failed to load categories"));
    }
  }

  Future<void> saveCategories(List<CategoryEntity> categories) async {
    try {
      await _repository.saveCategories(categories);
      await loadCategories(); // Refresh
    } catch (e) {
      emit(CategoryError("Failed to save categories"));
    }
  }

  Future<void> updateCategory(CategoryEntity category, int index) async {
    try {
      await _repository.updateCategory(category, index);
      await loadCategories(); // Refresh
    } catch (e) {
      emit(CategoryError("Failed to update category"));
    }
  }
}
