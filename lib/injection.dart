
import 'package:get_it/get_it.dart';
import 'package:pdfs/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:pdfs/presentation/bloc/user/user_bloc.dart';

import 'core/notification_service.dart';
import 'data/datasources/local_data_source.dart';
import 'data/repositories_impl/appointment_repository_impl.dart';
import 'data/repositories_impl/user_repository_impl.dart';
import 'domain/repositories/appointment_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/add_appointment.dart';
import 'domain/usecases/add_user.dart';
import 'domain/usecases/delete_appointment.dart';
import 'domain/usecases/get_appointments.dart';
import 'domain/usecases/get_users.dart';
import 'domain/usecases/update_appointment.dart';


final getIt = GetIt.instance;
void setupInjection() {
  // Local Data Source
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  // Repositories
  getIt.registerLazySingleton<AppointmentRepository>(
          () => AppointmentRepositoryImpl(getIt<LocalDataSource>()));
  getIt.registerLazySingleton<UserRepository>(
          () => UserRepositoryImpl(getIt<LocalDataSource>()));

  // Appointment UseCases
  getIt.registerLazySingleton(() => GetAppointmentsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAppointmentUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAppointmentUseCase(getIt()));

  // User UseCases
  getIt.registerLazySingleton(() => GetUsersUseCase(getIt()));
  getIt.registerLazySingleton(() => AddUserUseCase(getIt()));

  // Blocs
  getIt.registerLazySingleton<AppointmentBlocs>(() => AppointmentBlocs(
    getAppointments: getIt<GetAppointmentsUseCase>(),
    addAppointment: getIt<AddAppointmentUseCase>(),
    updateAppointment: getIt<UpdateAppointmentUseCase>(),
    deleteAppointment: getIt<DeleteAppointmentUseCase>(),
  ));

  getIt.registerLazySingleton<UserBloc>(() => UserBloc(
    getUsers: getIt<GetUsersUseCase>(),
    addUser: getIt<AddUserUseCase>(),
  ));
}
