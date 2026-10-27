import 'dart:io';
import 'package:caresync/features/medical_records/data/models/medical_record_model.dart';

abstract class MedicalRecordsRepository {
  Stream<List<MedicalRecordModel>> getMedicalRecords(String patientId);
  Future<void> uploadMedicalRecord({
    required String patientId,
    required File file,
    required String fileName,
    required String type,
  });
  Future<void> deleteMedicalRecord({
    required String patientId,
    required String recordId,
    required String fileUrl,
  });
}
