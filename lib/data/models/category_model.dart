import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 3)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String iconCode; // Store icon as string or code

  @HiveField(2)
  final int colorValue;

  @HiveField(3)
  final bool isSelected;

  CategoryModel({
    required this.name,
    required this.iconCode,
    required this.colorValue,
    this.isSelected = false,
  });
}
