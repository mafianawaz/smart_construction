import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'model/bulletin_model.dart';


class BulletinLogic extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController editMessageController = TextEditingController();

  late List<BulletinModel> bulletins;
  late List<ProjectOption> projectOptions;

  ProjectOption? selectedProject;
  String? editingBulletinId;
  bool isPosting = false;

  // Placeholder until MockSession is wired in — mirrors the seam used
  // in the Messages module (MockSession.currentRole / currentUserId).
  static const String _currentUserId = 'user_sarah_mitchell';
  static const String _currentUserName = 'Sarah Mitchell';
  static const String _currentUserAvatarUrl = AppImages.person;

  bool isOwnPost(BulletinModel bulletin) => bulletin.authorId == _currentUserId;

  @override
  void onInit() {
    super.onInit();
    bulletins = BulletinsMockData.getBulletins()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    projectOptions = BulletinsMockData.getProjectOptions();
  }

  bool get canPost => messageController.text.trim().isNotEmpty;

  void onMessageChanged(value) {
    update();
  }

  void selectProject(ProjectOption? option) {
    selectedProject = option;
    update();
  }

  Future<void> postBulletin() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    isPosting = true;
    update();

    // TODO: replace with real API call (POST /bulletins).
    await Future.delayed(const Duration(milliseconds: 300));

    final newBulletin = BulletinModel(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      authorId: _currentUserId,
      authorName: _currentUserName,
      authorAvatarUrl: _currentUserAvatarUrl,
      message: text,
      projectId: selectedProject?.id,
      projectName: selectedProject?.name,
      createdAt: DateTime.now(),
    );

    bulletins.insert(0, newBulletin);
    messageController.clear();
    selectedProject = null;
    isPosting = false;
    update();
  }

  void startEditing(BulletinModel bulletin) {
    editingBulletinId = bulletin.id;
    editMessageController.text = bulletin.message;
    update();
  }

  void cancelEditing() {
    editingBulletinId = null;
    editMessageController.clear();
    update();
  }

  void saveEditing(String bulletinId) {
    final index = bulletins.indexWhere((b) => b.id == bulletinId);
    if (index == -1) return;

    final newText = editMessageController.text.trim();
    if (newText.isEmpty) return;

    // TODO: replace with real API call (PATCH /bulletins/:id).
    bulletins[index] = bulletins[index].copyWith(message: newText);
    editingBulletinId = null;
    editMessageController.clear();
    update();
  }

  @override
  void onClose() {
    messageController.dispose();
    editMessageController.dispose();
    super.onClose();
  }
}