import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'logic.dart';
import 'widget/bulletin_card.dart';
import 'widget/bulletin_composor.dart';


class BulletinView extends StatelessWidget {
  const BulletinView({super.key});

  static const String _tag = 'bulletins';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BulletinLogic>(
      init: BulletinLogic(),
      tag: _tag,
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Bulletins',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const Text(
                  'Daily updates and notes from across the company',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                BulletinComposer(
                  messageController: logic.messageController,
                  projectOptions: logic.projectOptions,
                  selectedProject: logic.selectedProject,
                  onProjectChanged: logic.selectProject,
                  onMessageChanged: logic.onMessageChanged,
                  onPost: logic.postBulletin,
                  canPost: logic.canPost,
                  isPosting: logic.isPosting,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Bulletins',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                if (logic.bulletins.isEmpty)
                  const AppEmptyState(
                    title: 'No bulletins yet',
                    message: 'Be the first to share an update with the team.',
                    showButton: false,
                  )
                else
                  ...logic.bulletins.map(
                        (bulletin) => BulletinCard(
                      bulletin: bulletin,
                      isOwnPost: logic.isOwnPost(bulletin),
                      isEditing: logic.editingBulletinId == bulletin.id,
                      editController: logic.editMessageController,
                      onEditTap: () => logic.startEditing(bulletin),
                      onSave: () => logic.saveEditing(bulletin.id),
                      onCancel: logic.cancelEditing,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}