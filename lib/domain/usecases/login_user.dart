
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class LoginUserUseCase {
  final UserRepository repository;

  LoginUserUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) =>
      repository.loginUser(email, password);
}
