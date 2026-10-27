import 'dart:io';

abstract class PatientsRepository {
  Stream<Map<String, dynamic>?> streamPatientProfile(String patientId);
  Future<Map<String, dynamic>?> getPatientProfile(String patientId);
  Future<void> updatePatientProfile({
    required String patientId,
    required Map<String, dynamic> data,
    File? imageFile,
  });
}
