
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class AddUserUseCase {
  final UserRepository repository;

  AddUserUseCase(this.repository);

  Future<void> call(UserEntity user) => repository.addUser(user);
}
