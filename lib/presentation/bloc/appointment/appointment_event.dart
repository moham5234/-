import '../../../domain/entities/appointment_entity.dart';

abstract class AppointmentEvent {}

class LoadAppointments extends AppointmentEvent {}

class AddAppointmentEvent extends AppointmentEvent {
  final String name;
  final String phone;
  final DateTime dateTime;

  AddAppointmentEvent({
    required this.name,
    required this.phone,
    required this.dateTime,
  });
}

class UpdateAppointmentEvent extends AppointmentEvent {
  final int id;
  final String name;
  final String phone;
  final DateTime dateTime;

  UpdateAppointmentEvent({
    required this.id,
    required this.name,
    required this.phone,
    required this.dateTime,
  });
}

class DeleteAppointmentsEvent extends AppointmentEvent {
  final int id;

  DeleteAppointmentsEvent(this.id);
}

class ExportAppointmentsToPDFEvent extends AppointmentEvent {
  final String title;
  final DateTime date;

  ExportAppointmentsToPDFEvent({
    required this.title,
    required this.date,
  });
}
