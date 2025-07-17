import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveCategories(List<CategoryEntity> categories) {
    final models = categories.map((e) {
      return CategoryModel(
        name: e.name,
        iconCode: e.iconCode,
        colorValue: e.colorValue, // ✅ mapped correctly
        isSelected: e.isSelected,
      );
    }).toList();
    return localDataSource.saveCategories(models);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await localDataSource.getCategories();
    return models
        .map(
          (m) => CategoryEntity(
            name: m.name,
            iconCode: m.iconCode,
            colorValue: m.colorValue,
            isSelected: m.isSelected,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateCategory(CategoryEntity category, int index) {
    final model = CategoryModel(
      name: category.name,
      iconCode: category.iconCode,
      colorValue: category.colorValue,
      isSelected: category.isSelected,
    );
    return localDataSource.updateCategory(model, index);
  }
}
