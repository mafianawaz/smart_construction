import 'package:get/get.dart';
import '../model/chat_models.dart';
import '../widget/messages_mock_data.dart';


/// One controller instance per open chat, tagged by chatId so opening
/// two chats in sequence never reuses stale state.
class ChatDetailController extends GetxController {
  final String chatId;
  ChatDetailController(this.chatId);

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Mock-to-API seam: replace with a real fetch keyed on chatId.
    messages.assignAll(MessagesMockData.threadFor(chatId));
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(
      ChatMessage(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        text: text.trim(),
        timeLabel: 'Now',
        isMe: true,
      ),
    );
  }
}