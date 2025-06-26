import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';

import '../datasources/local_data_source.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final LocalDataSource localDataSource;

  AppointmentRepositoryImpl(this.localDataSource);

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    final models = await localDataSource.getAppointments();
    return models.map((model) => AppointmentEntity(
      id: model.id,
      name: model.name,
      phone: model.phone,
      dateTime: model.dateTime,
    )).toList();
  }

  @override
  Future<int> addAppointment(AppointmentEntity appointment) {
    final model = AppointmentModel(
      id: appointment.id,
      name: appointment.name,
      phone: appointment.phone,
      dateTime: appointment.dateTime,
    );
    return localDataSource.addAppointment(model);
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) {
    final model = AppointmentModel(
      id: appointment.id,
      name: appointment.name,
      phone: appointment.phone,
      dateTime: appointment.dateTime,
    );
    return localDataSource.updateAppointment(model);
  }

  @override
  Future<void> deleteAppointment(int id) {
    return localDataSource.deleteAppointment(id);
  }
}
