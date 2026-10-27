import 'package:caresync/features/blood_donation/data/models/blood_form_model.dart';

abstract class BloodDonationRepository {
  Stream<List<BloodDetail>> getPendingBloodRequests(
      {required String currentUserId});
  Stream<List<BloodDetail>> getMyBloodRequests({required String currentUserId});
  Future<void> submitBloodRequest({
    required String patientId,
    required String name,
    required String phone,
    required String email,
    required String age,
    required String? gender,
    required String address,
    required String? bloodGroup,
  });
  Future<void> acceptBloodRequest({
    required String recipientId,
    required String recipientFormId,
    required String uniId,
    required String donorId,
  });
}
