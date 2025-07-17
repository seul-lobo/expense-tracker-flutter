import 'package:hive/hive.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<void> saveCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>> getCategories();
  Future<void> updateCategory(CategoryModel category, int index);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Box<CategoryModel> box;

  CategoryLocalDataSourceImpl(this.box);

  @override
  Future<void> saveCategories(List<CategoryModel> categories) async {
    await box.clear();
    for (var cat in categories) {
      await box.add(cat);
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return box.values.toList();
  }

  @override
  Future<void> updateCategory(CategoryModel category, int index) async {
    await box.putAt(index, category);
  }
}
