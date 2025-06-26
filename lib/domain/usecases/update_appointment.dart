
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointmentUseCase {
  final AppointmentRepository repository;

  UpdateAppointmentUseCase(this.repository);

  Future<void> call(AppointmentEntity appointment) =>
      repository.updateAppointment(appointment);
}
