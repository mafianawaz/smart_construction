import 'package:flutter/material.dart';

import '../models/portfolio_report_models.dart';
import 'report_palette.dart';

/// White bordered rounded card. [highlight] draws the orange leader border.
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.highlight = false,
    this.fill = Colors.white,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool highlight;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? ReportPalette.primary : ReportPalette.border,
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}

/// Circular back button + centered title.
class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ReportPalette.border),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 22,
                    color: ReportPalette.text,
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ReportPalette.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportSectionTitle extends StatelessWidget {
  const ReportSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: ReportPalette.text,
      ),
    );
  }
}

class ReportSubtitle extends StatelessWidget {
  const ReportSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        height: 1.45,
        color: ReportPalette.muted,
      ),
    );
  }
}

/// IDLE (grey) / ACTIVE (green) pill.
class ReportStatusPill extends StatelessWidget {
  const ReportStatusPill({super.key, required this.status});

  final PortfolioOrgStatus status;

  @override
  Widget build(BuildContext context) {
    final active = status == PortfolioOrgStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? ReportPalette.activeFill : ReportPalette.idleFill,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: active ? ReportPalette.activeText : ReportPalette.idleText,
        ),
      ),
    );
  }
}

/// Grey caps tag for the organization type.
class ReportTypeTag extends StatelessWidget {
  const ReportTypeTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: ReportPalette.chipFill,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: ReportPalette.idleText,
        ),
      ),
    );
  }
}

/// `#1` shows an amber trophy chip; every other rank is a plain grey chip.
class ReportRankBadge extends StatelessWidget {
  const ReportRankBadge(this.rank, {super.key});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final first = rank == 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: first ? ReportPalette.rankFill : ReportPalette.chipFill,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (first) ...[
            const Icon(
              Icons.emoji_events_outlined,
              size: 11,
              color: ReportPalette.rankText,
            ),
            const SizedBox(width: 2),
          ],
          Text(
            '#$rank',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: first ? ReportPalette.rankText : ReportPalette.idleText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width muted "Export CSV" bar.
class ReportExportButton extends StatelessWidget {
  const ReportExportButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ReportPalette.chipFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: const SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.file_download_outlined,
                size: 17,
                color: ReportPalette.barText,
              ),
              SizedBox(width: 8),
              Text(
                'Export CSV',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ReportPalette.barText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
