import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointments_repository_impl.dart';
import '../../domain/repositories/appointments_repository.dart';

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  return AppointmentsRepositoryImpl();
});

final patientAppointmentsStreamProvider =
    StreamProvider.family<List<MyAppointment>, String>((ref, patientId) {
  return ref
      .watch(appointmentsRepositoryProvider)
      .getPatientAppointmentsStream(patientId);
});

class AppointmentBookingState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AppointmentBookingState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  AppointmentBookingState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return AppointmentBookingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AppointmentBookingNotifier extends Notifier<AppointmentBookingState> {
  late final AppointmentsRepository _repository;

  @override
  AppointmentBookingState build() {
    _repository = ref.watch(appointmentsRepositoryProvider);
    return const AppointmentBookingState();
  }

  Future<bool> bookAppointment({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String patientName,
    required String patientPhone,
    required String date,
    required String time,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      await _repository.bookAppointment(
        patientId: patientId,
        doctorId: doctorId,
        doctorName: doctorName,
        patientName: patientName,
        patientPhone: patientPhone,
        date: date,
        time: time,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final appointmentBookingNotifierProvider =
    NotifierProvider<AppointmentBookingNotifier, AppointmentBookingState>(
        AppointmentBookingNotifier.new);
