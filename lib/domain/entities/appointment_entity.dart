
class AppointmentEntity {
  final int? id;
  final String name;
  final String phone;
  final DateTime dateTime;


  AppointmentEntity({
    this.id,
    required this.name,
    required this.phone,
    required this.dateTime,

  });
}
