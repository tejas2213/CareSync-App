import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/authentication/presentation/providers/auth_provider.dart';
import 'package:caresync/features/medical_records/data/models/medical_record_model.dart';
import 'package:caresync/features/medical_records/data/repositories/medical_records_repository_impl.dart';
import 'package:caresync/features/medical_records/domain/repositories/medical_records_repository.dart';

final medicalRecordsRepositoryProvider =
    Provider<MedicalRecordsRepository>((ref) {
  return MedicalRecordsRepositoryImpl();
});

final patientMedicalRecordsStreamProvider =
    StreamProvider.autoDispose<List<MedicalRecordModel>>((ref) {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  final user = ref.watch(firebaseAuthUserProvider).value;
  final patientId = user?.uid ?? '';
  if (patientId.isEmpty) {
    return const Stream.empty();
  }
  return repository.getMedicalRecords(patientId);
});

class MedicalRecordsActionState {
  final bool isUploading;
  final String? deletingRecordId;
  final String? errorMessage;
  final bool isSuccess;

  const MedicalRecordsActionState({
    this.isUploading = false,
    this.deletingRecordId,
    this.errorMessage,
    this.isSuccess = false,
  });

  MedicalRecordsActionState copyWith({
    bool? isUploading,
    String? deletingRecordId,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return MedicalRecordsActionState(
      isUploading: isUploading ?? this.isUploading,
      deletingRecordId: deletingRecordId,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class MedicalRecordsActionNotifier
    extends StateNotifier<MedicalRecordsActionState> {
  final MedicalRecordsRepository _repository;

  MedicalRecordsActionNotifier(this._repository)
      : super(const MedicalRecordsActionState());

  Future<bool> uploadRecord({
    required String patientId,
    required File file,
    required String fileName,
    required String type,
  }) async {
    state =
        state.copyWith(isUploading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.uploadMedicalRecord(
        patientId: patientId,
        file: file,
        fileName: fileName,
        type: type,
      );
      state = state.copyWith(isUploading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isUploading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteRecord({
    required String patientId,
    required String recordId,
    required String fileUrl,
  }) async {
    state = state.copyWith(deletingRecordId: recordId, errorMessage: null);
    try {
      await _repository.deleteMedicalRecord(
        patientId: patientId,
        recordId: recordId,
        fileUrl: fileUrl,
      );
      state = state.copyWith(deletingRecordId: null);
      return true;
    } catch (e) {
      state =
          state.copyWith(deletingRecordId: null, errorMessage: e.toString());
      return false;
    }
  }
}

final medicalRecordsActionNotifierProvider = StateNotifierProvider<
    MedicalRecordsActionNotifier, MedicalRecordsActionState>((ref) {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  return MedicalRecordsActionNotifier(repository);
});
