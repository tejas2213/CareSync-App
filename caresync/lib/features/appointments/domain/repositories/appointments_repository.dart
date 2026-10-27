import '../../data/models/appointment_model.dart';

abstract class AppointmentsRepository {
  Stream<List<MyAppointment>> getPatientAppointmentsStream(String patientId);
  Future<void> bookAppointment({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String patientName,
    required String patientPhone,
    required String date,
    required String time,
  });
}
