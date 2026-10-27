import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/patients_repository_impl.dart';
import '../../domain/repositories/patients_repository.dart';

final patientsRepositoryProvider = Provider<PatientsRepository>((ref) {
  return PatientsRepositoryImpl();
});

final currentPatientIdProvider = Provider<String>((ref) {
  final user = ref.watch(firebaseAuthUserProvider).value;
  return user?.uid ?? '';
});

final currentPatientProfileStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final repository = ref.watch(patientsRepositoryProvider);
  final patientId = ref.watch(currentPatientIdProvider);
  if (patientId.isEmpty) {
    return Stream.value(null);
  }
  return repository.streamPatientProfile(patientId);
});

class PatientActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const PatientActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  PatientActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return PatientActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class PatientActionNotifier extends StateNotifier<PatientActionState> {
  final PatientsRepository _repository;

  PatientActionNotifier(this._repository) : super(const PatientActionState());

  Future<bool> updateProfile({
    required String patientId,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updatePatientProfile(
        patientId: patientId,
        data: data,
        imageFile: imageFile,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }
}

final patientActionNotifierProvider = StateNotifierProvider.autoDispose<
    PatientActionNotifier, PatientActionState>(
  (ref) {
    final repository = ref.watch(patientsRepositoryProvider);
    return PatientActionNotifier(repository);
  },
);
