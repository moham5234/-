
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    int? id,
    required String name,
    required String email,
    required String password,
    required String type,
  }) : super(id: id, name: name, email: email, password: password,type:type);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type,
    };
  }
}
