
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> addUser(UserEntity user);
  Future<UserEntity?> loginUser(String email, String password);
  Future<List<UserEntity>> getAllUsers();
}
