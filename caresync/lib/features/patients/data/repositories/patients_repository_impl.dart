import 'dart:io';
import '../../domain/repositories/patients_repository.dart';
import '../datasources/patients_remote_data_source.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final PatientsRemoteDataSource _remoteDataSource;

  PatientsRepositoryImpl({
    PatientsRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? PatientsRemoteDataSourceImpl();

  @override
  Stream<Map<String, dynamic>?> streamPatientProfile(String patientId) {
    return _remoteDataSource.streamPatientProfile(patientId);
  }

  @override
  Future<Map<String, dynamic>?> getPatientProfile(String patientId) {
    return _remoteDataSource.getPatientProfile(patientId);
  }

  @override
  Future<void> updatePatientProfile({
    required String patientId,
    required Map<String, dynamic> data,
    File? imageFile,
  }) {
    return _remoteDataSource.updatePatientProfile(
      patientId: patientId,
      data: data,
      imageFile: imageFile,
    );
  }
}
