import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../logic.dart';
import '../widgets/aiq_basics.dart';
import '../widgets/aiq_list_extras.dart';
import '../widgets/aiq_review_sheet_panel.dart';
import 'logic.dart';

/// Draft Review screen reached from Edit / Reject (or a `?review=rv_8812`
/// deep link): breadcrumb, a compact list of queue rows, and the review sheet
/// inline underneath.
class AiReviewDetailView extends StatelessWidget {
  const AiReviewDetailView({super.key, required this.reviewId});

  final String reviewId;

  @override
  Widget build(BuildContext context) {
    // Registers the queue controller when opened straight from a deep link.
    AiReviewQueueLogic.ensure();

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'AI Review Detail',
        showBackButton: true,
        centerTitle: true,
      ),
      body: GetBuilder<AiReviewQueueLogic>(
        builder: (queue) {
          final item = queue.itemById(reviewId);
          if (item == null) {
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const AiqHeader(
                  crumbs: ['Projects', 'AI Review Queue'],
                  title: 'AI Review Queue',
                ),
                const SizedBox(height: 16),
                AiqEmptyState(
                  title: 'Draft not found',
                  message: 'This review link is no longer available.',
                  actionLabel: 'Back to queue',
                  onAction: () => Get.back(),
                ),
              ],
            );
          }

          return GetBuilder<ReviewSheetLogic>(
            tag: item.id,
            init: ReviewSheetLogic(item, queue),
            // Tagged controllers are released where the route is popped.
            dispose: (_) => Get.delete<ReviewSheetLogic>(tag: item.id),
            builder: (sheet) {
              return ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  AiqHeader(
                    crumbs: ['Projects', 'AI Review Queue', '?review=${item.id}'],
                    title: 'AI Review Queue',
                  ),
                  const SizedBox(height: 14),
                  for (final row in queue.compactRowsFor(item.id))
                    AiqCompactCard(
                      item: row,
                      onTap: row.id == item.id
                          ? null
                          : () => Get.off(
                                () => AiReviewDetailView(reviewId: row.id),
                              ),
                    ),
                  const SizedBox(height: 6),
                  AiqReviewSheetPanel(
                    logic: sheet,
                    onClose: () => Get.back(),
                    onAccept: () {
                      if (sheet.accept()) _done('Accepted: ${item.shortTitle}');
                    },
                    onSaveEdits: () {
                      if (sheet.saveEditsAndAccept()) {
                        _done('Edits saved and accepted: ${item.shortTitle}');
                      }
                    },
                    onReject: () {
                      if (sheet.reject()) _done('Rejected: ${item.shortTitle}');
                    },
                    onSendToAttorney: () {
                      if (sheet.sendToAttorney()) {
                        _done('Sent to attorney review: ${item.shortTitle}');
                      }
                    },
                    // Audit Log G-09 has no screen yet — see the notes file.
                    onOpenAudit: () => _toast('Audit Log G-09 is not wired yet.'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _done(String message) {
    Get.back();
    _toast(message);
  }

  void _toast(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }
}
