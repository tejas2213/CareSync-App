import 'package:caresync/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:caresync/features/chat/data/models/chat_message_model.dart';
import 'package:caresync/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({ChatRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChatRemoteDataSourceImpl();

  @override
  Stream<List<ChatMessageModel>> streamMessages({
    required String patientId,
    required String doctorId,
  }) {
    return _remoteDataSource.streamMessages(
        patientId: patientId, doctorId: doctorId);
  }

  @override
  Future<void> sendMessage({
    required String patientId,
    required String doctorId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    return _remoteDataSource.sendMessage(
      patientId: patientId,
      doctorId: doctorId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctorPatients(
      {required String doctorId}) {
    return _remoteDataSource.getDoctorPatients(doctorId: doctorId);
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctors() {
    return _remoteDataSource.getDoctors();
  }
}
