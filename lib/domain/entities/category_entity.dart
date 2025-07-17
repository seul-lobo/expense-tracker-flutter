class CategoryEntity {
  final String name;
  final String iconCode;
  final int colorValue; // Changed to int

  final bool isSelected;

  CategoryEntity({
    required this.name,
    required this.iconCode,
    required this.colorValue,
    this.isSelected = false,
  });
}
