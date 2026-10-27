import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/authentication/presentation/providers/auth_provider.dart';
import 'package:caresync/features/blood_donation/data/models/blood_form_model.dart';
import 'package:caresync/features/blood_donation/data/repositories/blood_donation_repository_impl.dart';
import 'package:caresync/features/blood_donation/domain/repositories/blood_donation_repository.dart';

final bloodDonationRepositoryProvider =
    Provider<BloodDonationRepository>((ref) {
  return BloodDonationRepositoryImpl();
});

final pendingBloodRequestsStreamProvider =
    StreamProvider.autoDispose<List<BloodDetail>>((ref) {
  final repository = ref.watch(bloodDonationRepositoryProvider);
  final user = ref.watch(firebaseAuthUserProvider).value;
  final currentUserId = user?.uid ?? '';
  return repository.getPendingBloodRequests(currentUserId: currentUserId);
});

final myBloodRequestsStreamProvider =
    StreamProvider.autoDispose<List<BloodDetail>>((ref) {
  final repository = ref.watch(bloodDonationRepositoryProvider);
  final user = ref.watch(firebaseAuthUserProvider).value;
  final currentUserId = user?.uid ?? '';
  return repository.getMyBloodRequests(currentUserId: currentUserId);
});

class BloodDonationActionState {
  final bool isSubmitting;
  final String? loadingItemId;
  final String? errorMessage;
  final bool isSuccess;

  const BloodDonationActionState({
    this.isSubmitting = false,
    this.loadingItemId,
    this.errorMessage,
    this.isSuccess = false,
  });

  BloodDonationActionState copyWith({
    bool? isSubmitting,
    String? loadingItemId,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return BloodDonationActionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      loadingItemId: loadingItemId,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class BloodDonationActionNotifier
    extends StateNotifier<BloodDonationActionState> {
  final BloodDonationRepository _repository;

  BloodDonationActionNotifier(this._repository)
      : super(const BloodDonationActionState());

  Future<bool> submitBloodRequest({
    required String patientId,
    required String name,
    required String phone,
    required String email,
    required String age,
    required String? gender,
    required String address,
    required String? bloodGroup,
  }) async {
    state = state.copyWith(
        isSubmitting: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.submitBloodRequest(
        patientId: patientId,
        name: name,
        phone: phone,
        email: email,
        age: age,
        gender: gender,
        address: address,
        bloodGroup: bloodGroup,
      );
      state = state.copyWith(isSubmitting: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> acceptBloodRequest({
    required String recipientId,
    required String recipientFormId,
    required String uniId,
    required String donorId,
  }) async {
    state = state.copyWith(loadingItemId: uniId, errorMessage: null);
    try {
      await _repository.acceptBloodRequest(
        recipientId: recipientId,
        recipientFormId: recipientFormId,
        uniId: uniId,
        donorId: donorId,
      );
      state = state.copyWith(loadingItemId: null);
      return true;
    } catch (e) {
      state = state.copyWith(loadingItemId: null, errorMessage: e.toString());
      return false;
    }
  }
}

final bloodDonationActionNotifierProvider = StateNotifierProvider<
    BloodDonationActionNotifier, BloodDonationActionState>((ref) {
  final repository = ref.watch(bloodDonationRepositoryProvider);
  return BloodDonationActionNotifier(repository);
});
