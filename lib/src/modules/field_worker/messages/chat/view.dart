import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_icons.dart';
import '../model/chat_models.dart';
import '../widget/chat_section.dart';
import '../widget/message_bubble.dart';
import 'logic.dart';

/// Same screen for a channel or a direct chat — `chat` (the ChatPreview
/// tapped in MessagesScreen) is the only thing that differs.
class ChatDetailScreen extends StatelessWidget {
  final ChatPreview chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ChatDetailController(chat.id),
      tag: chat.id,
    );
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.fieldBorder),
                shape: BoxShape.circle
            ),
            child: IconButton(
              onPressed:  () => Navigator.of(context).maybePop(),
              icon:  Icon(Icons.arrow_back_ios_new_rounded,size: 15,),
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
              chat.avatarUrl != null ? AssetImage(chat.avatarUrl!) : null,
              child: chat.avatarUrl == null
                  ? Icon(chat.icon ?? Icons.person, size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (chat.type == ChatType.direct)
                  const Text(
                    'Active',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                SvgPicture.asset(AppIcons.video, width: 24, height: 24),
                SizedBox(width: 10),
                SvgPicture.asset(AppIcons.call, width: 24, height: 24),
              ],
            ),
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) =>
                    MessageBubble(message: controller.messages[index]),
              ),
            ),
          ),
          ChatInputBar(
            controller: textController,
            onSend: () {
              controller.sendMessage(textController.text);
              textController.clear();
            },
          ),
        ],
      ),
    );
  }
}