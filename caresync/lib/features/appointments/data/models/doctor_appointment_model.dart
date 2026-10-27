class DrAppointment {
  final String name;
  final String date;
  final String phone;
  final String time;
  String status;
  String appointmentId;
  String patientId;
  final String patientAppId;

  DrAppointment({
    required this.name,
    required this.time,
    required this.date,
    required this.phone,
    required this.status,
    required this.appointmentId,
    required this.patientId,
    required this.patientAppId,
  });
}