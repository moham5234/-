
import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentEntity>> getAppointments();
  Future<int> addAppointment(AppointmentEntity appointment);
  Future<void> updateAppointment(AppointmentEntity appointment);
  Future<void> deleteAppointment(int id);
}
