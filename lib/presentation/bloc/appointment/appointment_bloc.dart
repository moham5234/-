import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/notification_service.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/usecases/add_appointment.dart';
import '../../../domain/usecases/delete_appointment.dart';
import '../../../domain/usecases/get_appointments.dart';
import '../../../domain/usecases/update_appointment.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';
import '../../../core/pdfs.dart';

class AppointmentBlocs extends Bloc<AppointmentEvent, AppointmentsState> {
  final GetAppointmentsUseCase getAppointments;
  final AddAppointmentUseCase addAppointment;
  final UpdateAppointmentUseCase updateAppointment;
  final DeleteAppointmentUseCase deleteAppointment;

  AppointmentBlocs({
    required this.getAppointments,
    required this.addAppointment,
    required this.updateAppointment,
    required this.deleteAppointment,
  }) : super(AppointmentInitial()) {
    on<LoadAppointments>(_onLoad);
    on<AddAppointmentEvent>(_onAdd);
    on<UpdateAppointmentEvent>(_onUpdate);
    on<DeleteAppointmentsEvent>(_onDelete);
    on<ExportAppointmentsToPDFEvent>(_onExportToPDF);
  }

  Future<void> _onLoad(
      LoadAppointments event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments = await getAppointments();
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onAdd(
      AddAppointmentEvent event, Emitter<AppointmentsState> emit) async {
    try {
      final appointment = AppointmentEntity(
        name: event.name,
        phone: event.phone,
        dateTime: event.dateTime,
      );

      await addAppointment(appointment);

      NotificationService().scheduleNotificationBeforeOneHour(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'موعد قادم',
        body:
            'لديك موعد مع ${event.name} الساعة ${DateFormat('hh:mm a').format(event.dateTime)}',
        appointmentDateTime: event.dateTime,
      );

      add(LoadAppointments());
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateAppointmentEvent event, Emitter<AppointmentsState> emit) async {
    try {
      final appointment = AppointmentEntity(
        id: event.id,
        name: event.name,
        phone: event.phone,
        dateTime: event.dateTime,
      );

      await updateAppointment(appointment);
      NotificationService().scheduleNotificationBeforeOneHour(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'تعديل موعد',
        body:
            'تم تعديل موعدك مع ${event.name} الساعة ${DateFormat('hh:mm a').format(event.dateTime)}',
        appointmentDateTime: event.dateTime,
      );
      add(LoadAppointments());
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteAppointmentsEvent event, Emitter<AppointmentsState> emit) async {
    try {
      await deleteAppointment(event.id);
      add(LoadAppointments());
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onExportToPDF(ExportAppointmentsToPDFEvent event,
      Emitter<AppointmentsState> emit) async {
    try {
      final appointments = await getAppointments();

      print_PDF.prepareData(
        title_: event.title,
        date_: DateFormat('yyyy-MM-dd').format(event.date),
        appointmentList: appointments,
      );

      await print_PDF.createPdf(
          fileName:
              "appointments_${DateFormat('yyyyMMdd').format(event.date)}");
    } catch (e) {
      emit(AppointmentError("فشل في تصدير PDF: ${e.toString()}"));
    }
  }
}
