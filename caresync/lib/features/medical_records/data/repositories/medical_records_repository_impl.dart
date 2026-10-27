import 'dart:io';
import 'package:caresync/features/medical_records/data/datasources/medical_records_remote_data_source.dart';
import 'package:caresync/features/medical_records/data/models/medical_record_model.dart';
import 'package:caresync/features/medical_records/domain/repositories/medical_records_repository.dart';

class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  final MedicalRecordsRemoteDataSource _remoteDataSource;

  MedicalRecordsRepositoryImpl(
      {MedicalRecordsRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? MedicalRecordsRemoteDataSourceImpl();

  @override
  Stream<List<MedicalRecordModel>> getMedicalRecords(String patientId) {
    return _remoteDataSource.streamMedicalRecords(patientId);
  }

  @override
  Future<void> uploadMedicalRecord({
    required String patientId,
    required File file,
    required String fileName,
    required String type,
  }) {
    return _remoteDataSource.uploadMedicalRecord(
      patientId: patientId,
      file: file,
      fileName: fileName,
      type: type,
    );
  }

  @override
  Future<void> deleteMedicalRecord({
    required String patientId,
    required String recordId,
    required String fileUrl,
  }) {
    return _remoteDataSource.deleteMedicalRecord(
      patientId: patientId,
      recordId: recordId,
      fileUrl: fileUrl,
    );
  }
}
