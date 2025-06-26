
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> addUser(UserEntity user) async {
    final model = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      type: user.type,
    );
    await localDataSource.addUser(model);
  }

  @override
  Future<UserEntity?> loginUser(String email, String password) async {
    return await localDataSource.loginUser(email, password);
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    return await localDataSource.getUsers();
  }
}
