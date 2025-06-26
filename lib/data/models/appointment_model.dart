import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    int? id,
    required String name,
    required String phone,
    required DateTime dateTime,
  }) : super(id: id, name: name, phone: phone, dateTime: dateTime);

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
