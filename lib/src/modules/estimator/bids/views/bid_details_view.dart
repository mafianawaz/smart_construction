import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../logic/bid_details_logic.dart';
import '../models/bid_model.dart';
import '../widgets/bid_status_chip.dart';

/// Bid Details (Figma "Bid Details" frame): header with status, Scope of
/// Work + Additional Description, Clarifications thread with Ask
/// Question, Project Details, and the expired banner.
class BidDetailsView extends StatelessWidget {
  final BidModel bid;
  const BidDetailsView({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BidDetailsLogic>(
      init: BidDetailsLogic(bid),
      tag: bid.id,
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('Bid Details'), centerTitle: true),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bid ${bid.number}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(bid.title,
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      BidStatusChip(status: bid.status),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _Card(children: [
                    _label('Scope of Work'),
                    _value(bid.scopeOfWork),
                    const SizedBox(height: 12),
                    _label('Additional Description'),
                    _value(bid.additionalDescription),
                  ]),
                  const SizedBox(height: 12),
                  _Card(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Clarifications',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        OutlinedButton.icon(
                          onPressed: () => _askQuestion(context, logic),
                          icon: const Icon(Icons.chat_bubble_outline, size: 14),
                          label: const Text('Ask Question'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textDark,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (logic.clarifications.isEmpty) {
                        return Text('No questions have been asked yet.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textMuted));
                      }
                      return Column(
                        children: [
                          for (final c in logic.clarifications)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.question,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Asked by ${c.askedBy} · '
                                    '${DateFormat('MMM d, y').format(c.askedAt)}',
                                    style: TextStyle(
                                        fontSize: 11, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    c.isAnswered ? c.answer! : 'Awaiting response',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: c.isAnswered
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                      color: c.isAnswered
                                          ? AppColors.textDark
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }),
                  ]),
                  const SizedBox(height: 12),
                  _Card(children: [
                    const Text('Project Details',
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    _label('Required Trades'),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (bid.requiredTrades.isEmpty) _value('-'),
                        for (final t in bid.requiredTrades)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(t,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _label('Bid Due Date'),
                    Text(
                      bid.dueDateLongLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: bid.isPastDue ? AppColors.redColor : AppColors.textDark,
                      ),
                    ),
                    if (bid.isPastDue)
                      Text('This bid due date has passed',
                          style: TextStyle(fontSize: 11, color: AppColors.redColor)),
                    const SizedBox(height: 12),
                    _label('Project Start'),
                    _value(bid.projectStartLabel),
                    const SizedBox(height: 12),
                    _label('Location'),
                    _value(bid.locationLabel),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: logic.downloadDocuments,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.textDark,
                        ),
                        child: const Text('Download Documents'),
                      ),
                    ),
                  ]),
                  if (bid.isExpired) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              size: 16, color: AppColors.redColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This bid has expired and is no longer accepting '
                              'submissions.',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.redColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String t) => Text(t,
      style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted));

  Widget _value(String t) => Text(t.isEmpty ? '-' : t,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500));

  Future<void> _askQuestion(BuildContext context, BidDetailsLogic logic) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AskQuestionSheet(onSubmit: logic.addQuestion),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _AskQuestionSheet extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  const _AskQuestionSheet({required this.onSubmit});

  @override
  State<_AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends State<_AskQuestionSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ask a Question',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Your question is sent to the bid owner for clarification.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            maxLines: 4,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Type your question…'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_ctrl.text.trim().isEmpty) return;
                widget.onSubmit(_ctrl.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Question'),
            ),
          ),
        ],
      ),
    );
  }
}
