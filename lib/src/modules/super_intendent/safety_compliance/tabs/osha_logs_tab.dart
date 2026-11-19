import 'package:flutter/material.dart';
import '../logic.dart';
import '../widgets/osha_widgets.dart';
import '../widgets/safety_common_widgets.dart';
import '../widgets/safety_palette.dart';

/// OSHA Logs tab: year picker, 300A download, annual summary, 300 log entries.
class SafetyOshaLogsTab extends StatelessWidget {
  final SafetyLogic logic;

  const SafetyOshaLogsTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final s = logic.oshaSummary;
    final entries = logic.oshaEntries;
    return ListView(
      children: [
        Row(
          children: [
            const Text(
              'Year:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: SafetyPalette.textDark,
              ),
            ),
            const SizedBox(width: 8),
            _YearDropdown(
              value: logic.oshaYear,
              years: logic.availableYears,
              onChanged: logic.selectOshaYear,
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: logic.downloadOsha300A,
              icon: const Icon(Icons.file_download_outlined, size: 15),
              label: const Text('Download 300A PDF'),
              style: OutlinedButton.styleFrom(
                foregroundColor: SafetyPalette.orange,
                side: const BorderSide(color: SafetyPalette.orange),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SafetyCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Annual Summary (${logic.oshaYear})',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: SafetyPalette.textDark,
                ),
              ),
              const SizedBox(height: 12),
              SafetyTwoColumnGrid(
                spacing: 10,
                children: [
                  OshaSummaryTile(
                    label: 'Total Recordable',
                    value: '${s.totalRecordable}',
                    icon: Icons.description_outlined,
                  ),
                  OshaSummaryTile(
                    label: 'Deaths',
                    value: '${s.deaths}',
                    icon: s.deaths == 0
                        ? Icons.warning_amber_rounded
                        : Icons.report_gmailerrorred_outlined,
                    valueColor:
                        s.deaths == 0 ? SafetyPalette.green : SafetyPalette.red,
                    iconColor:
                        s.deaths == 0 ? SafetyPalette.green : SafetyPalette.red,
                  ),
                  OshaSummaryTile(
                    label: 'Days Away',
                    value: '${s.daysAway}',
                    icon: Icons.description_outlined,
                  ),
                  OshaSummaryTile(
                    label: 'Restricted Days',
                    value: '${s.restrictedDays}',
                    icon: Icons.description_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SafetyCard(
          padding:  EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'OSHA 300 Log Entries',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: SafetyPalette.textDark,
                ),
              ),
              const SizedBox(height: 12),
              if (entries.isEmpty)
                SafetyEmptyBox(
                  message: 'No recordable incidents for ${logic.oshaYear}.',
                )
              else
                for (var i = 0; i < entries.length; i++) ...[
                  OshaLogEntryTile(entry: entries[i]),
                  if (i != entries.length - 1) const SizedBox(height: 10),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _YearDropdown extends StatelessWidget {
  final int value;
  final List<int> years;
  final ValueChanged<int> onChanged;

  const _YearDropdown({
    required this.value,
    required this.years,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SafetyPalette.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: SafetyPalette.textMuted,
          ),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SafetyPalette.textDark,
          ),
          items: [
            for (final y in years)
              DropdownMenuItem<int>(value: y, child: Text('$y')),
          ],
          onChanged: (y) {
            if (y != null) onChanged(y);
          },
        ),
      ),
    );
  }
}
