import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../services/session/session.dart';
import '../../../utils/app_icons.dart';
import '../../../widgets/app_appbar.dart';
import 'chat/view.dart';
import 'logic.dart';
import 'model/chat_models.dart';
import 'widget/chat_section.dart';


/// Drop-in Messages screen. Every role uses the exact same widget —
/// only the `config` passed in (and therefore the sections it renders)
/// changes. See MessagesMockData.forRole for how each role builds one.
///
/// `tag` lets the same screen be pushed more than once (e.g. from
/// different tabs) without controller collisions, matching the
/// per-instance tagging used for AppCalendar.
class MessagesScreen extends StatelessWidget {
  final MessagesScreenConfig? config;
  final String? tag;

  /// Optional override for navigation. Defaults to pushing
  /// ChatDetailScreen. Pass this in if the app's routing pattern
  /// differs (see NOTES.md — Task List → Detail nav is still a TODO
  /// there, so wire both the same way once that's settled).
  final void Function(BuildContext context, ChatPreview item)? onChatTap;

  const MessagesScreen({
    super.key,
     this.config,
     this.tag,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesLogic(config!), tag: tag);

    return Scaffold(
      appBar: SecondaryAppbar(
        isHome: false,
        title: 'Messages',
        count: '9 msg',
        subTitle: config?.subtitle ?? '',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 8),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           config?.title ?? '',
            //           style: const TextStyle(
            //             fontSize: 24,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(width: 8),
            //         Obx(() {
            //           final total = controller.filteredSections
            //               .expand((s) => s.items)
            //               .fold<int>(0, (sum, i) => sum + i.unreadCount);
            //           return Container(
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 8,
            //               vertical: 2,
            //             ),
            //             decoration: BoxDecoration(
            //               color: Colors.grey.shade200,
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             child: Text(
            //               '$total msg',
            //               style: const TextStyle(fontSize: 12),
            //             ),
            //           );
            //         }),
            //       ],
            //     ),
            //     const Icon(Icons.edit_outlined),
            //   ],
            // ),
            // Text(
            //   config?.subtitle ?? '',
            //   style: const TextStyle(color: Colors.grey),
            // ),
            // const SizedBox(height: 16),
            CustomTextField(
              hintText: config?.searchHint ?? '',
              onChange: controller.onSearchChanged,
              leftIconPath: AppIcons.search,
            ),
            Expanded(
              child: Obx(() {
                final sections = controller.filteredSections;
                if (sections.isEmpty) {
                  return const Center(child: Text('No results'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatSectionHeader(title: section.title),
                        ...section.items.map(
                              (item) => ChatListTile(
                            item: item,
                            onTap: () => _handleTap(context, item),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, ChatPreview item) {
    if (onChatTap != null) {
      onChatTap!(context, item);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatDetailScreen(chat: item)),
    );
  }
}