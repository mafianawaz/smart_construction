import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'rollup_palette.dart';

/// `stacked`: heatmap — label on the left, control on the right, one filter
/// per row inside a white panel.
/// `compact`: Gantt / Financial — inline "LABEL: [control]" items that wrap,
/// followed by the slider and an orange "Clear filters" link.
enum RollupFiltersLayout { stacked, compact }

/// Shared PM / Start After / End Before / Min Health filters. Owns no state:
/// everything comes in as values and goes out through callbacks, and the date
/// pickers are opened here so the logic stays free of BuildContext.
class RollupFiltersPanel extends StatelessWidget {
  const RollupFiltersPanel({
    super.key,
    required this.layout,
    required this.pmOptions,
    required this.pm,
    required this.startAfter,
    required this.endBefore,
    required this.minHealth,
    required this.hasActiveFilters,
    required this.onPmChanged,
    required this.onStartAfterChanged,
    required this.onEndBeforeChanged,
    required this.onMinHealthChanged,
    required this.onClear,
  });

  final RollupFiltersLayout layout;
  final List<String> pmOptions;
  final String? pm;
  final DateTime? startAfter;
  final DateTime? endBefore;
  final double minHealth;
  final bool hasActiveFilters;
  final ValueChanged<String?> onPmChanged;
  final ValueChanged<DateTime?> onStartAfterChanged;
  final ValueChanged<DateTime?> onEndBeforeChanged;
  final ValueChanged<double> onMinHealthChanged;
  final VoidCallback onClear;

  static final DateFormat _fmt = DateFormat('MM/dd/yyyy');

  Future<void> _pick(
    BuildContext context,
    DateTime? current,
    ValueChanged<DateTime?> onChanged,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }

  Widget _pmField() => _PmDropdown(
        options: pmOptions,
        value: pm,
        onChanged: onPmChanged,
      );

  Widget _dateField(
    BuildContext context,
    DateTime? value,
    ValueChanged<DateTime?> onChanged,
  ) =>
      _DateBox(
        text: value == null ? null : _fmt.format(value),
        onTap: () => _pick(context, value, onChanged),
        onClear: value == null ? null : () => onChanged(null),
      );

  Widget _slider() => _MinHealthSlider(
        value: minHealth,
        onChanged: onMinHealthChanged,
      );

  @override
  Widget build(BuildContext context) {
    return layout == RollupFiltersLayout.stacked
        ? _buildStacked(context)
        : _buildCompact(context);
  }

  // ── heatmap ──────────────────────────────────────────────────────────
  Widget _buildStacked(BuildContext context) {
    Widget row(String label, Widget control) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: RollupPalette.muted)),
              control,
            ],
          ),
        );

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          row('PM', _pmField()),
          row('Start After', _dateField(context, startAfter, onStartAfterChanged)),
          row('End Before', _dateField(context, endBefore, onEndBeforeChanged)),
          row(
            'Min Health',
            Text(
              '${minHealth.round()}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: RollupPalette.orange,
              ),
            ),
          ),
          _slider(),
          if (hasActiveFilters)
            Align(
              alignment: Alignment.centerLeft,
              child: _ClearLink(onTap: onClear),
            ),
        ],
      ),
    );
  }

  // ── gantt / financial ────────────────────────────────────────────────
  Widget _buildCompact(BuildContext context) {
    Widget labeled(String label, Widget control) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: RollupPalette.muted,
              ),
            ),
            const SizedBox(width: 6),
            control,
          ],
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              labeled('PM:', _pmField()),
              labeled('START AFTER:',
                  _dateField(context, startAfter, onStartAfterChanged)),
              labeled(
                'MIN HEALTH:',
                _MinHealthBadge(
                  value: minHealth,
                  onReset: minHealth > 0 ? () => onMinHealthChanged(0) : null,
                ),
              ),
              labeled('END BEFORE:',
                  _dateField(context, endBefore, onEndBeforeChanged)),
            ],
          ),
          const SizedBox(height: 4),
          _slider(),
          Align(
            alignment: Alignment.centerLeft,
            child: _ClearLink(onTap: onClear),
          ),
        ],
      ),
    );
  }
}

class _PmDropdown extends StatelessWidget {
  const _PmDropdown({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: RollupPalette.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 18, color: RollupPalette.muted),
          style: const TextStyle(fontSize: 12, color: RollupPalette.text),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Any PM'),
            ),
            for (final o in options)
              DropdownMenuItem<String?>(value: o, child: Text(o)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.text, required this.onTap, this.onClear});

  /// null shows the mm/dd/yyyy placeholder.
  final String? text;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: RollupPalette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text ?? 'mm/dd/yyyy',
              style: TextStyle(
                fontSize: 12,
                color: text == null ? RollupPalette.muted : RollupPalette.text,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onClear ?? onTap,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                onClear == null ? Icons.calendar_today_outlined : Icons.close,
                size: 14,
                color: RollupPalette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinHealthBadge extends StatelessWidget {
  const _MinHealthBadge({required this.value, this.onReset});

  final double value;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: RollupPalette.orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${value.round()}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: RollupPalette.orange,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onReset,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            Icons.close,
            size: 13,
            color: onReset == null
                ? RollupPalette.border
                : RollupPalette.muted,
          ),
        ),
      ],
    );
  }
}

class _MinHealthSlider extends StatelessWidget {
  const _MinHealthSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3,
        activeTrackColor: RollupPalette.orange,
        inactiveTrackColor: RollupPalette.track,
        thumbColor: RollupPalette.orange,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: SliderComponentShape.noOverlay,
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: value.clamp(0, 100).toDouble(),
        min: 0,
        max: 100,
        divisions: 100,
        onChanged: onChanged,
      ),
    );
  }
}

class _ClearLink extends StatelessWidget {
  const _ClearLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          'Clear filters',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: RollupPalette.orange,
          ),
        ),
      ),
    );
  }
}
