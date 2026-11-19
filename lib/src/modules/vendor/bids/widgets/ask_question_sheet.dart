import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';


/// Shows the sheet and returns the submitted question, or null if the
/// user dismissed it without asking anything.
Future<String?> showAskQuestionSheet(BuildContext context) {
  final controller = TextEditingController();

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ask a Question',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            CustomTextField(
                hintText: 'Type your question for the GC...',
              maxLines: 5,
              controller: controller,
            ),
            const SizedBox(height: 16),
            CustomButton(
                text: 'Send',
                onPressed: () => Navigator.of(sheetContext).pop(controller.text),
            ),
          ],
        ),
      );
    },
  );
}
