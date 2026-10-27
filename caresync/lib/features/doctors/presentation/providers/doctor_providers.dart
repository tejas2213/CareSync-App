import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';
import 'package:caresync/features/authentication/presentation/providers/auth_provider.dart';
import 'package:caresync/features/doctors/data/repositories/doctors_repository_impl.dart';
import 'package:caresync/features/doctors/domain/repositories/doctors_repository.dart';

final doctorsRepositoryProvider = Provider<DoctorsRepository>((ref) {
  return DoctorsRepositoryImpl();
});

final currentDoctorProfileStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final repository = ref.watch(doctorsRepositoryProvider);
  final user = ref.watch(firebaseAuthUserProvider).value;
  final doctorId = user?.uid ?? '';
  if (doctorId.isEmpty) {
    return Stream.value(null);
  }
  return repository.streamDoctorProfile(doctorId);
});

final currentDoctorAppointmentsStreamProvider =
    StreamProvider.autoDispose<List<DrAppointment>>((ref) {
  final repository = ref.watch(doctorsRepositoryProvider);
  final user = ref.watch(firebaseAuthUserProvider).value;
  final doctorId = user?.uid ?? '';
  if (doctorId.isEmpty) {
    return const Stream.empty();
  }
  return repository.streamDoctorAppointments(doctorId);
});

final doctorAcceptedAppointmentsProvider =
    Provider.autoDispose<AsyncValue<List<DrAppointment>>>((ref) {
  return ref.watch(currentDoctorAppointmentsStreamProvider).whenData(
        (list) => list
            .where((app) => app.status.toLowerCase() == 'accepted')
            .toList(),
      );
});

final doctorRejectedAppointmentsProvider =
    Provider.autoDispose<AsyncValue<List<DrAppointment>>>((ref) {
  return ref.watch(currentDoctorAppointmentsStreamProvider).whenData(
        (list) => list
            .where((app) => app.status.toLowerCase() == 'rejected')
            .toList(),
      );
});

final doctorUpcomingAppointmentsProvider =
    Provider.autoDispose<AsyncValue<List<DrAppointment>>>((ref) {
  return ref.watch(currentDoctorAppointmentsStreamProvider).whenData(
        (list) =>
            list.where((app) => app.status.toLowerCase() == 'pending').toList(),
      );
});

class DoctorActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const DoctorActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  DoctorActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return DoctorActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class DoctorActionNotifier extends StateNotifier<DoctorActionState> {
  final DoctorsRepository _repository;

  DoctorActionNotifier(this._repository) : super(const DoctorActionState());

  Future<bool> updateAppointmentStatus({
    required String doctorId,
    required String appointmentId,
    required String patientId,
    required String patientAppId,
    required String status,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateAppointmentStatus(
        doctorId: doctorId,
        appointmentId: appointmentId,
        patientId: patientId,
        patientAppId: patientAppId,
        status: status,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    required String doctorId,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateDoctorProfile(
        doctorId: doctorId,
        data: data,
        imageFile: imageFile,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final doctorActionNotifierProvider =
    StateNotifierProvider<DoctorActionNotifier, DoctorActionState>((ref) {
  final repository = ref.watch(doctorsRepositoryProvider);
  return DoctorActionNotifier(repository);
});
