
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class AddAppointmentUseCase {
  final AppointmentRepository repository;

  AddAppointmentUseCase(this.repository);

  Future<int> call(AppointmentEntity appointment) =>
      repository.addAppointment(appointment);

}
