import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_user.dart';
import '../../../domain/usecases/get_users.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../domain/entities/user_entity.dart';
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsers;
  final AddUserUseCase addUser;

  UserBloc({
    required this.getUsers,
    required this.addUser,
  }) : super(UserInitial()) {
    on<LoadUsers>(_onLoad);
    on<AddUsersEvent>(_onAdd);
  }

  Future<void> _onLoad(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAdd(AddUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await addUser(UserEntity(
        name: event.name,
        email: event.email,
        password: event.password,
        type: event.type,
      ));
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
