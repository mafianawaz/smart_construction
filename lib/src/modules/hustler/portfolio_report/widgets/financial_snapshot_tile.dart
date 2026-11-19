import 'package:flutter/material.dart';
import '../models/portfolio_format.dart';
import '../models/portfolio_report_models.dart';
import 'report_palette.dart';
import 'report_primitives.dart';

/// Expandable "Financial Snapshots" tile. Collapsed: building icon, name,
/// type, chevron. Expanded: AR aging, collection rate, open invoices.
///
/// The expanded layout is my own design; the reference only shows the
/// collapsed tiles.
class FinancialSnapshotTile extends StatelessWidget {
  const FinancialSnapshotTile({
    super.key,
    required this.org,
    required this.isExpanded,
    required this.onToggle,
  });

  final PortfolioOrgMetrics org;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: ReportPalette.chipFill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      size: 18,
                      color: ReportPalette.body,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.name,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: ReportPalette.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          org.typeLabel,
                          style: const TextStyle(
                            fontSize: 9.5,
                            letterSpacing: 0.3,
                            color: ReportPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: ReportPalette.body,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: _Details(financials: org.financials),
            ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.financials});

  final PortfolioFinancials financials;

  @override
  Widget build(BuildContext context) {
    if (financials.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          'No receivables or open invoices recorded.',
          style: TextStyle(fontSize: 12, color: ReportPalette.muted),
        ),
      );
    }

    final rate = financials.collectionRatePct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: ReportPalette.border),
        const SizedBox(height: 12),
        const Text(
          'AR AGING',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
            color: ReportPalette.muted,
          ),
        ),
        const SizedBox(height: 8),
        _Row('Current', PortfolioFormat.money(financials.arCurrent)),
        _Row('1–30 days', PortfolioFormat.money(financials.ar1to30)),
        _Row('31–60 days', PortfolioFormat.money(financials.ar31to60)),
        _Row('61–90 days', PortfolioFormat.money(financials.ar61to90)),
        _Row('90+ days', PortfolioFormat.money(financials.arOver90)),
        const Divider(height: 20, color: ReportPalette.border),
        _Row(
          'Collection rate',
          rate == null ? '—' : '${rate.toStringAsFixed(1)}%',
          bold: true,
        ),
        _Row(
          'Open invoices',
          '${financials.openInvoiceCount} · '
              '${PortfolioFormat.money(financials.openInvoiceAmount)}',
          bold: true,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: ReportPalette.body),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: ReportPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}
