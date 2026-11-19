import 'package:flutter/material.dart';

enum ChatType { channel, direct }

/// A single row in the Messages list.
/// Shaped like the eventual API response so swapping mock data for a
/// real endpoint later requires no UI changes.
class ChatPreview {
  final String id;
  final ChatType type;
  final String name;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;

  /// Used for `ChatType.direct` rows (person-to-person).
  final String? avatarUrl;

  /// Used for `ChatType.channel` rows (icon inside a colored circle).
  final IconData? icon;
  final Color? iconBackgroundColor;

  const ChatPreview({
    required this.id,
    required this.type,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    this.unreadCount = 0,
    this.avatarUrl,
    this.icon,
    this.iconBackgroundColor,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      id: json['id'] as String,
      type: json['type'] == 'direct' ? ChatType.direct : ChatType.channel,
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      timeLabel: json['timeLabel'] as String,
      unreadCount: json['unreadCount'] as int? ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

/// A named group of chats, e.g. "Channels" or "Team Chat".
/// A role that doesn't have Team Chat simply omits that section —
/// the screen never checks "what role is this" itself.
class ChatSection {
  final String title;
  final List<ChatPreview> items;

  const ChatSection({required this.title, required this.items});
}

/// A single message bubble on the chat detail screen.
class ChatMessage {
  final String id;
  final String text;
  final String timeLabel;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.timeLabel,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      timeLabel: json['timeLabel'] as String,
      isMe: json['isMe'] as bool? ?? false,
    );
  }
}