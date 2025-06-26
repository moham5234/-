
import '../../../domain/entities/appointment_entity.dart';

abstract class AppointmentsState {}

class AppointmentInitial extends AppointmentsState {}

class AppointmentLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentEntity> appointments;

  AppointmentsLoaded(this.appointments);
}

class AppointmentError extends AppointmentsState {
  final String message;

  AppointmentError(this.message);
}
