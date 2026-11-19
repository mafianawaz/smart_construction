import '../../modules/field_worker/messages/model/chat_models.dart';

class MockSession {
  static const UserRole currentRole = UserRole.hustler;
}

/// Everything MessagesScreen needs to render, with zero role-specific
/// logic baked into the widget itself. A role builds one of these
/// (see MessagesMockData) and hands it to the screen.
class MessagesScreenConfig {
  final String title;
  final String subtitle;
  final String searchHint;

  /// Ordered list of sections. A role with only Channels passes a
  /// single-item list; a role with Channels + Team Chat passes two.
  final List<ChatSection> sections;

  const MessagesScreenConfig({
    this.title = 'Messages',
    required this.subtitle,
    this.searchHint = 'Search Messages...',
    required this.sections,
  });
}

/// Placeholder role enum — swap this import for the app's existing
/// role enum if one already exists (e.g. from your auth/user model).
enum UserRole { fieldWorker, vendor, estimator, superIntendent , manager, hustler}

