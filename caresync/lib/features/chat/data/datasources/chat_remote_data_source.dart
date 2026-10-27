import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caresync/features/chat/data/models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
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

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String _getChatId(String patientId, String doctorId) =>
      '${patientId}_$doctorId';

  @override
  Stream<List<ChatMessageModel>> streamMessages({
    required String patientId,
    required String doctorId,
  }) {
    final chatId = _getChatId(patientId, doctorId);
    return _firestore
        .collection('chats/$chatId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> sendMessage({
    required String patientId,
    required String doctorId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final chatId = _getChatId(patientId, doctorId);
    await _firestore.collection('chats/$chatId/messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctorPatients(
      {required String doctorId}) async {
    final querySnapshot = await _firestore
        .collection('/CareSync/doctors/accounts/$doctorId/appointments/')
        .get();

    final Map<String, Map<String, dynamic>> uniquePatients = {};
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final pId = data['patientId']?.toString() ?? '';
      final name = data['name']?.toString() ?? 'Unknown';
      if (pId.isNotEmpty && !uniquePatients.containsKey(pId)) {
        uniquePatients[pId] = {
          'patientId': pId,
          'name': name,
        };
      }
    }
    return uniquePatients.values.toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctors() async {
    final doctorsSnapshot =
        await _firestore.collection('CareSync/doctors/accounts').get();
    return doctorsSnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }
}
