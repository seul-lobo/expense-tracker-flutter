import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/user_local_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveUser(UserEntity user) {
    final model = UserModel.fromEntity(user); // ⬅️ Uses selectedCategories too
    return localDataSource.saveUser(model);
  }

  @override
  Future<UserEntity?> getUser() async {
    final model = await localDataSource.getUser();
    if (model == null) return null;
    return model.toEntity();
  }

  @override
  Future<void> deleteUser() {
    return localDataSource.deleteUser();
  }
}

