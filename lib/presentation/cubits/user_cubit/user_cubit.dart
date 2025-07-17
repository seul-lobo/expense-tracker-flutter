import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit(this.repository) : super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());
    try {
      final box = await Hive.openBox<UserModel>('user');
      if (box.isNotEmpty) {
        final userModel = box.getAt(0);
        if (userModel != null) {
          print('🧠 User loaded: ${userModel.name}');
          print('🖼️  ImagePath: ${userModel.imagePath}');
          print('📦 Selected Categories: ${userModel.selectedCategories}');
          emit(UserLoaded(userModel.toEntity()));
        } else {
          emit(const UserError('No user found.'));
        }
      } else {
        emit(const UserError('No user found.'));
      }
    } catch (e) {
      emit(UserError('Failed to load user: $e'));
    }
  }

  Future<void> saveUser(UserEntity user) async {
    emit(UserLoading());
    try {
      final box = await Hive.openBox<UserModel>('user');
      final model = UserModel.fromEntity(user);
      if (box.isEmpty) {
        await box.add(model);
        print('User added: ${model.name}, ImagePath: ${model.imagePath}');
        print('📦 Selected Categories: ${model.selectedCategories}');
      } else {
        await box.putAt(0, model);
        print('User updated: ${model.name}, ImagePath: ${model.imagePath}');
        print('📦 Selected Categories: ${model.selectedCategories}');
      }
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Failed to save user: $e'));
    }
  }

  Future<void> deleteUser() async {
    emit(UserLoading());
    try {
      final box = await Hive.openBox<UserModel>('user');
      await box.clear();
      print('User box cleared');
      emit(UserInitial());
    } catch (e) {
      emit(UserError('Failed to delete user: $e'));
    }
  }
}
