import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> box;

  UserLocalDataSourceImpl(this.box);

  @override
  Future<void> saveUser(UserModel user) async {
    await box.put('user', user); // static key since single user
  }

  @override
  Future<UserModel?> getUser() async {
    return box.get('user');
  }

  @override
  Future<void> deleteUser() async {
    await box.delete('user');
  }
}
