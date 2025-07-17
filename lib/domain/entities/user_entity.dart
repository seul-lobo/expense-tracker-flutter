class UserEntity {
  final String name;
  final String profileImagePath;
  final List<String> selectedCategories;

  UserEntity({
    required this.name,
    required this.profileImagePath,
    required this.selectedCategories,
  });
}
