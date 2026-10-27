import 'package:caresync/features/chat/data/models/chat_message_model.dart';

abstract class ChatRepository {
  Stream<List<ChatMessageModel>> streamMessages({
    required String patientId,
    required String doctorId,
  });

  Future<void> sendMessage({
    required String patientId,
    required String doctorId,
    required String senderId,
    required String receiverId,
    required String text,
  });

  Future<List<Map<String, dynamic>>> getDoctorPatients(
      {required String doctorId});

  Future<List<Map<String, dynamic>>> getDoctors();
}
