import 'package:flutter/material.dart';

import '../models/worker_model.dart';
import 'wf_common.dart';
import 'wf_palette.dart';

/// Round avatar: network photo when available, initials otherwise.
class WfAvatar extends StatelessWidget {
  const WfAvatar({super.key, required this.worker, this.radius = 25});
  final WorkerModel worker;
  final double radius;

  static const _tints = [
    Color(0xFFF59E0B),
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
  ];

  @override
  Widget build(BuildContext context) {
    final tint = _tints[worker.id.hashCode.abs() % _tints.length];
    final fallback = CircleAvatar(
      radius: radius,
      backgroundColor: tint,
      child: Text(
        worker.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.7,
        ),
      ),
    );
    final url = worker.avatarUrl;
    if (url == null || url.isEmpty) return fallback;
    return ClipOval(
      child: Image.network(
        url,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

/// One row in the Workers list.
class WorkerCard extends StatelessWidget {
  const WorkerCard({super.key, required this.worker, required this.onTap});
  final WorkerModel worker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = worker.status == WorkerStatus.active;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: WfPalette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: WfPalette.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WfAvatar(worker: worker),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.fullName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WfPalette.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    worker.title,
                    style: const TextStyle(fontSize: 12, color: WfPalette.muted),
                  ),
                  const SizedBox(height: 6),
                  WfTag(worker.trade),
                ],
              ),
            ),
            WfDotStatus(
              worker.status.label,
              color: active ? WfPalette.success : WfPalette.hint,
            ),
          ],
        ),
      ),
    );
  }
}

/// Certification row inside Worker Details.
class CertificationRow extends StatelessWidget {
  const CertificationRow({super.key, required this.cert});
  final WorkerCertification cert;

  @override
  Widget build(BuildContext context) {
    late final Color fg;
    late final Color bg;
    switch (cert.status) {
      case CertStatus.active:
        fg = WfPalette.success;
        bg = WfPalette.successBg;
        break;
      case CertStatus.expiringSoon:
        fg = WfPalette.warning;
        bg = WfPalette.warningBg;
        break;
      case CertStatus.expired:
        fg = WfPalette.danger;
        bg = WfPalette.dangerBg;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cert.expiresLabel,
                  style: const TextStyle(fontSize: 9.5, color: WfPalette.muted),
                ),
              ],
            ),
          ),
          WfStatusChip(cert.status.label, fg: fg, bg: bg),
        ],
      ),
    );
  }
}
