import 'package:intl/intl.dart';

/// Role badge shown next to an author's name.
enum CfoBulletinRole {
  admin('ADMIN'),
  manager('MANAGER'),
  fieldWorker('FIELD_WORKER'),
  other('MEMBER');

  final String label;
  const CfoBulletinRole(this.label);
}

class CfoBulletin {
  final String id;
  final String authorName;
  final CfoBulletinRole role;
  final DateTime postedAt;
  final String message;

  /// Optional project the note is attached to ("Maisie Hicks - 260009").
  final String? projectName;
  final String? projectCode;

  /// Null → the avatar falls back to initials.
  final String? avatarUrl;

  const CfoBulletin({
    required this.id,
    required this.authorName,
    required this.role,
    required this.postedAt,
    required this.message,
    this.projectName,
    this.projectCode,
    this.avatarUrl,
  });

  bool get hasProject => projectName != null && projectName!.isNotEmpty;

  String get projectLabel =>
      projectCode == null ? projectName! : '$projectName - $projectCode';

  /// "May 12, 2026 5:55 PM"
  String get postedLabel => DateFormat('MMM d, yyyy h:mm a').format(postedAt);

  String get initials {
    final parts =
        authorName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }
}

/// One linked organization and its bulletins.
class CfoBulletinOrg {
  final String id;
  final String name;

  /// Raw type key as the API sends it, e.g. `GENERAL_CONTRACTOR`.
  final String type;

  /// Shows the green NEW badge (unseen bulletins).
  final bool isNew;
  final List<CfoBulletin> bulletins;

  const CfoBulletinOrg({
    required this.id,
    required this.name,
    required this.type,
    required this.bulletins,
    this.isNew = false,
  });

  bool get isEmpty => bulletins.isEmpty;

  /// Newest first.
  List<CfoBulletin> get sorted =>
      [...bulletins]..sort((a, b) => b.postedAt.compareTo(a.postedAt));
}
