
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

class ProjectOption {
  final String id;
  final String name;

  const ProjectOption({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProjectOption && other.id == id);

  @override
  int get hashCode => id.hashCode;
}


class BulletinModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final String message;
  final String? projectId;
  final String? projectName;
  final DateTime createdAt;

  BulletinModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.message,
    this.projectId,
    this.projectName,
    required this.createdAt,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(createdAt);

  BulletinModel copyWith({
    String? message,
    String? projectId,
    String? projectName,
  }) {
    return BulletinModel(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      message: message ?? this.message,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      createdAt: createdAt,
    );
  }
}


/// Mock seam for the Bulletins module.
/// Replace [getBulletins] / [getProjectOptions] with real API calls;
/// signatures are shaped to match the eventual endpoint responses.
class BulletinsMockData {
  static List<BulletinModel> getBulletins() {
    return [
      BulletinModel(
        id: 'b1',
        authorId: 'user_field_worker_1',
        authorName: 'Field Worker',
        authorAvatarUrl: AppImages.person,
        message:
        'Daily site inspection completed. All safety protocols followed. No issues reported.',
        createdAt: DateTime(2026, 6, 25),
      ),
      BulletinModel(
        id: 'b2',
        authorId: 'user_sarah_mitchell',
        authorName: 'Sarah Mitchell',
        authorAvatarUrl: AppImages.person,
        message: 'Updated concrete delivery schedule for Block A.',
        projectId: 'proj_block_a',
        projectName: 'Block A Construction',
        createdAt: DateTime(2026, 6, 24),
      ),
    ];
  }

  static List<ProjectOption> getProjectOptions() {
    return const [
      ProjectOption(id: 'proj_block_a', name: 'Block A Construction'),
      ProjectOption(id: 'proj_block_b', name: 'Block B Construction'),
      ProjectOption(id: 'proj_site_prep', name: 'Site Preparation'),
    ];
  }
}