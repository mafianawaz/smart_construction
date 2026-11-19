import 'package:flutter/material.dart';

import 'dd_palette.dart';

/// Breadcrumb ("Home › AI Agents › Daily Digest") plus the dated title.
class DdHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onHomeTap;
  final VoidCallback? onAiAgentsTap;

  const DdHeader({
    super.key,
    required this.title,
    this.onHomeTap,
    this.onAiAgentsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _Crumb(label: 'Home', onTap: onHomeTap),
            const _Chevron(),
            _Crumb(label: 'AI Agents', onTap: onAiAgentsTap),
            const _Chevron(),
            const _Crumb(label: 'Daily Digest'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: DdPalette.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Crumb extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _Crumb({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: DdPalette.textMuted),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.chevron_right, size: 14, color: DdPalette.textMuted),
    );
  }
}
