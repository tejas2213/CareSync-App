import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/ambulance_repository.dart';
import '../datasources/ambulance_remote_data_source.dart';

class AmbulanceRepositoryImpl implements AmbulanceRepository {
  final AmbulanceRemoteDataSource _remoteDataSource;

  AmbulanceRepositoryImpl({AmbulanceRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AmbulanceRemoteDataSource();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAmbulancesStream() =>
      _remoteDataSource.getAmbulancesStream();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAmbulancesByTypeStream(
          String type) =>
      _remoteDataSource.getAmbulancesByTypeStream(type);

  @override
  Future<Map<String, dynamic>?> getAmbulanceDetails(String ambulanceId) =>
      _remoteDataSource.getAmbulanceDetails(ambulanceId);

  @override
  Future<List<Map<String, dynamic>>> getPatientBookings(String patientId) =>
      _remoteDataSource.getPatientBookings(patientId);

  @override
  Future<void> bookAmbulance({
    required String? patientId,
    required String ambulanceId,
    required String ambulanceName,
    required String? ambulancePhone,
    required String pickupLocation,
    required String dropoffLocation,
  }) =>
      _remoteDataSource.bookAmbulance(
        patientId: patientId,
        ambulanceId: ambulanceId,
        ambulanceName: ambulanceName,
        ambulancePhone: ambulancePhone,
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
      );
}
