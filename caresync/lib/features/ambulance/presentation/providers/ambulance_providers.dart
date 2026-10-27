import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/ambulance_repository_impl.dart';
import '../../domain/repositories/ambulance_repository.dart';

final ambulanceRepositoryProvider = Provider<AmbulanceRepository>((ref) {
  return AmbulanceRepositoryImpl();
});

final allAmbulancesStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {
  return ref.watch(ambulanceRepositoryProvider).getAmbulancesStream();
});

final ambulancesByTypeStreamProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, type) {
  return ref.watch(ambulanceRepositoryProvider).getAmbulancesByTypeStream(type);
});

final ambulanceDetailsFutureProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, ambulanceId) {
  return ref
      .watch(ambulanceRepositoryProvider)
      .getAmbulanceDetails(ambulanceId);
});

final patientAmbulanceBookingsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, patientId) {
  return ref.watch(ambulanceRepositoryProvider).getPatientBookings(patientId);
});

class AmbulanceBookingState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AmbulanceBookingState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  AmbulanceBookingState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return AmbulanceBookingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AmbulanceBookingNotifier extends Notifier<AmbulanceBookingState> {
  late final AmbulanceRepository _repository;

  @override
  AmbulanceBookingState build() {
    _repository = ref.watch(ambulanceRepositoryProvider);
    return const AmbulanceBookingState();
  }

  Future<bool> bookAmbulance({
    String? patientId,
    required String ambulanceId,
    required String ambulanceName,
    required String? ambulancePhone,
    required String pickupLocation,
    required String dropoffLocation,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      await _repository.bookAmbulance(
        patientId: patientId,
        ambulanceId: ambulanceId,
        ambulanceName: ambulanceName,
        ambulancePhone: ambulancePhone,
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final ambulanceBookingNotifierProvider =
    NotifierProvider<AmbulanceBookingNotifier, AmbulanceBookingState>(
        AmbulanceBookingNotifier.new);
