import 'package:hive/hive.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? imagePath;

  @HiveField(2)
  final List<String> selectedCategories; // ✅ NEW FIELD

  UserModel({
    required this.name,
    this.imagePath,
    this.selectedCategories = const [],
  });

  // Model ➝ Entity
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      profileImagePath: imagePath ?? '',
      selectedCategories: selectedCategories,
    );
  }

  // Entity ➝ Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      imagePath: entity.profileImagePath,
      selectedCategories: entity.selectedCategories,
    );
  }
}

