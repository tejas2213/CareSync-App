class MyAppointment {
  final String doctorId;
  final String name;
  final String date;
  final String doctorName;
  final String phone;
  final String time;
  String status;
  String? appointmentId;

  MyAppointment({
    required this.doctorId,
    required this.name,
    required this.time,
    required this.date,
    required this.doctorName,
    required this.phone,
    required this.status,
    this.appointmentId,
  });
}