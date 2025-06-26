
abstract class UserEvent {}
class AddUsersEvent extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String type;

  AddUsersEvent( {required this.name, required this.email, required this.password, required this.type});


}
class LoadUsers extends UserEvent {}


