import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/chat/data/models/chat_message_model.dart';
import 'package:caresync/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:caresync/features/chat/domain/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

class ChatConversationParams {
  final String patientId;
  final String doctorId;

  const ChatConversationParams({
    required this.patientId,
    required this.doctorId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversationParams &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          doctorId == other.doctorId;

  @override
  int get hashCode => patientId.hashCode ^ doctorId.hashCode;
}

final chatMessagesStreamProvider = StreamProvider.autoDispose
    .family<List<ChatMessageModel>, ChatConversationParams>((ref, params) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.streamMessages(
    patientId: params.patientId,
    doctorId: params.doctorId,
  );
});

final doctorChatPatientsFutureProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, doctorId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getDoctorPatients(doctorId: doctorId);
});

final allDoctorsChatListFutureProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getDoctors();
});

class ChatActionState {
  final bool isSending;
  final String? errorMessage;

  const ChatActionState({
    this.isSending = false,
    this.errorMessage,
  });

  ChatActionState copyWith({
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatActionState(
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }
}

class ChatActionNotifier extends StateNotifier<ChatActionState> {
  final ChatRepository _repository;

  ChatActionNotifier(this._repository) : super(const ChatActionState());

  Future<bool> sendMessage({
    required String patientId,
    required String doctorId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return false;
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      await _repository.sendMessage(
        patientId: patientId,
        doctorId: doctorId,
        senderId: senderId,
        receiverId: receiverId,
        text: text.trim(),
      );
      state = state.copyWith(isSending: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSending: false, errorMessage: e.toString());
      return false;
    }
  }
}

final chatActionNotifierProvider =
    StateNotifierProvider<ChatActionNotifier, ChatActionState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatActionNotifier(repository);
});
