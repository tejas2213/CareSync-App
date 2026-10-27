import 'dart:io';
import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';

abstract class DoctorsRepository {
  Stream<Map<String, dynamic>?> streamDoctorProfile(String doctorId);
  Future<Map<String, dynamic>?> getDoctorProfile(String doctorId);
  Future<void> updateDoctorProfile({
    required String doctorId,
    required Map<String, dynamic> data,
    File? imageFile,
  });
  Stream<List<DrAppointment>> streamDoctorAppointments(String doctorId);
  Future<void> updateAppointmentStatus({
    required String doctorId,
    required String appointmentId,
    required String patientId,
    required String patientAppId,
    required String status,
  });
}
