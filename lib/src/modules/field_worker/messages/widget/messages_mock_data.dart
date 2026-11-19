import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

import '../../../../services/session/session.dart';
import '../model/chat_models.dart';




/// Mock data shaped exactly like the eventual API response.
/// When the backend is ready, replace the body of `forRole` with an
/// API call that returns the same MessagesScreenConfig shape — the
/// screen and controller do not change at all.
class MessagesMockData {
  static MessagesScreenConfig forRole(UserRole role) {
    switch (role) {
      case UserRole.vendor:
      // Vendors only talk per-project — no Team Chat section at all.
        return const MessagesScreenConfig(
          subtitle: 'Chat with Projects',
          searchHint: 'Search For Project...',
          sections: [
            ChatSection(title: 'Channels', items: [
              ChatPreview(
                id: 'proj_a',
                type: ChatType.channel,
                name: 'Project A',
                lastMessage: 'Vendor Contact: vendor',
                timeLabel: '15d',
                unreadCount: 3,
                icon: Icons.chat_bubble,
                iconBackgroundColor: Color(0xFF3D5AFE),
              ),
              ChatPreview(
                id: 'proj_b',
                type: ChatType.channel,
                name: 'Project B',
                lastMessage: 'Sarah: Updated schedule',
                timeLabel: '2h',
                icon: Icons.groups,
                iconBackgroundColor: Color(0xFFFF7A45),
              ),
            ]),
          ],
        );

      case UserRole.fieldWorker:
      case UserRole.estimator:
      case UserRole.superIntendent:
      case UserRole.manager:
      case UserRole.hustler:
      // These roles see both org/site channels and 1:1 team chats.
        return const MessagesScreenConfig(
          subtitle: 'Chat with team members',
          sections: [
            ChatSection(title: 'Channels', items: [
              ChatPreview(
                id: 'company_chat',
                type: ChatType.channel,
                name: 'Company Chat',
                lastMessage: 'Vendor Contact: vendor',
                timeLabel: '15d',
                unreadCount: 3,
                icon: Icons.chat_bubble,
                iconBackgroundColor: Color(0xFF3D5AFE),
              ),
              ChatPreview(
                id: 'site_a_crew',
                type: ChatType.channel,
                name: 'Site A Crew',
                lastMessage: 'Sarah: Updated schedule',
                timeLabel: '2h',
                icon: Icons.groups,
                iconBackgroundColor: Color(0xFFFF7A45),
              ),
            ]),
            ChatSection(title: 'Team Chat', items: [
              ChatPreview(
                id: 'mike_chen',
                type: ChatType.direct,
                name: 'Mike Chen',
                lastMessage: 'Great!',
                timeLabel: '15d',
                unreadCount: 3,
                avatarUrl: AppImages.person,
              ),
              ChatPreview(
                id: 'sarah_mitchel',
                type: ChatType.direct,
                name: 'Sarah Mitchel',
                lastMessage: 'See you soon.',
                timeLabel: '15d',
                unreadCount: 3,
                avatarUrl: AppImages.person,
              ),
            ]),
          ],
        );
    }
  }

  /// Mock message thread for the chat detail screen (image 2 reference).
  static List<ChatMessage> threadFor(String chatId) {
    return const [
      ChatMessage(
        id: 'm1',
        text: "This is your delivery driver from Speedy Chow. I'm just "
            "around the corner from your place. 😊",
        timeLabel: '10:10',
        isMe: false,
      ),
      ChatMessage(id: 'm2', text: 'Hi!', timeLabel: '10:10', isMe: true),
      ChatMessage(
        id: 'm3',
        text: "Awesome, thanks for letting me know! Can't wait for my "
            "delivery 🎉",
        timeLabel: '10:11',
        isMe: true,
      ),
      ChatMessage(
        id: 'm4',
        text: "No problem at all! I'll be there in about 15 minutes.",
        timeLabel: '10:11',
        isMe: false,
      ),
      ChatMessage(
        id: 'm5',
        text: "I'll text you when I arrive.",
        timeLabel: '10:11',
        isMe: false,
      ),
      ChatMessage(id: 'm6', text: 'Great! 😊', timeLabel: '10:12', isMe: true),
    ];
  }
}