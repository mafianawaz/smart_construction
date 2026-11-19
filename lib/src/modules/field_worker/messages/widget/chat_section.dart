import 'package:flutter/material.dart';

import '../model/chat_models.dart';

class ChatSectionHeader extends StatelessWidget {
  final String title;

  const ChatSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}


/// Renders one row of the Messages list. Whether it looks like a
/// "channel" (icon in a colored circle) or a "direct" chat (avatar)
/// is decided entirely by `item.type` — callers never branch on role.
class ChatListTile extends StatelessWidget {
  final ChatPreview item;
  final VoidCallback? onTap;

  const ChatListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Row(
          children: [
            _buildLeading(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.timeLabel,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                if (item.unreadCount > 0) _buildUnreadBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (item.type == ChatType.direct) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(image: AssetImage(item.avatarUrl!))
        ),
        child: item.avatarUrl == null ? const Icon(Icons.person) : null,
      );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: item.iconBackgroundColor ?? Colors.blueGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(item.icon ?? Icons.chat_bubble, color: Colors.white),
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${item.unreadCount}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


/// Fixed message-composer bar. Kept as a Scaffold sibling on the chat
/// detail screen (not inside any scrollable), same pattern as
/// CommentInputBar on the Task Details screen.
class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFF5F5F7),
              child: IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey, size: 18,),
                onPressed: onAttach,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              backgroundColor: const Color(0xFFFF7A45),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}