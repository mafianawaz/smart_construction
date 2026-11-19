import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'proc_inputs.dart';

/// Full-screen form layout used by New PO / New Delivery Receipt / New Invoice:
/// back arrow + title + subtitle header, divider, scrolling body, and a
/// primary button pinned to the bottom (matches the New Purchase Order Figma).
class ProcFormScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String buttonText;
  final VoidCallback onSubmit;

  const ProcFormScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 15, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 22),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: TextStyle(
                                fontSize: 11, color: ProcStyle.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: ProcStyle.border),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            const Divider(height: 1, color: ProcStyle.border),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ProcButton(
                text: buttonText,
                fullWidth: true,
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two fields side by side.
class ProcRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const ProcRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 10),
          Expanded(child: right),
        ],
      );
}
