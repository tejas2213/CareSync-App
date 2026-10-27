import 'package:caresync/features/blood_donation/data/datasources/blood_donation_remote_data_source.dart';
import 'package:caresync/features/blood_donation/data/models/blood_form_model.dart';
import 'package:caresync/features/blood_donation/domain/repositories/blood_donation_repository.dart';

class BloodDonationRepositoryImpl implements BloodDonationRepository {
  final BloodDonationRemoteDataSource _remoteDataSource;

  BloodDonationRepositoryImpl({BloodDonationRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? BloodDonationRemoteDataSourceImpl();

  @override
  Stream<List<BloodDetail>> getPendingBloodRequests(
      {required String currentUserId}) {
    return _remoteDataSource.streamPendingBloodRequests(
        currentUserId: currentUserId);
  }

  @override
  Stream<List<BloodDetail>> getMyBloodRequests(
      {required String currentUserId}) {
    return _remoteDataSource.streamMyBloodRequests(
        currentUserId: currentUserId);
  }

  @override
  Future<void> submitBloodRequest({
    required String patientId,
    required String name,
    required String phone,
    required String email,
    required String age,
    required String? gender,
    required String address,
    required String? bloodGroup,
  }) {
    return _remoteDataSource.submitBloodRequest(
      patientId: patientId,
      name: name,
      phone: phone,
      email: email,
      age: age,
      gender: gender,
      address: address,
      bloodGroup: bloodGroup,
    );
  }

  @override
  Future<void> acceptBloodRequest({
    required String recipientId,
    required String recipientFormId,
    required String uniId,
    required String donorId,
  }) {
    return _remoteDataSource.acceptBloodRequest(
      recipientId: recipientId,
      recipientFormId: recipientFormId,
      uniId: uniId,
      donorId: donorId,
    );
  }
}
