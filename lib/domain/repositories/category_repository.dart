import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<void> saveCategories(List<CategoryEntity> categories);
  Future<List<CategoryEntity>> getCategories();
  Future<void> updateCategory(CategoryEntity category, int index);
}
