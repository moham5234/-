
class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String type;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.type,
  });
}
