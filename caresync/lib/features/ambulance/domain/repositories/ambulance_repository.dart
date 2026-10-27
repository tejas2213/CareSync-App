import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AmbulanceRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getAmbulancesStream();
  Stream<QuerySnapshot<Map<String, dynamic>>> getAmbulancesByTypeStream(
      String type);
  Future<Map<String, dynamic>?> getAmbulanceDetails(String ambulanceId);
  Future<List<Map<String, dynamic>>> getPatientBookings(String patientId);
  Future<void> bookAmbulance({
    required String? patientId,
    required String ambulanceId,
    required String ambulanceName,
    required String? ambulancePhone,
    required String pickupLocation,
    required String dropoffLocation,
  });
}
