import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../data/tc_format.dart';
import '../models/time_clock_models.dart';
import 'tc_common.dart';
import 'tc_palette.dart';

/// Result of the Adapt sheet.
class AdaptedTimes {
  const AdaptedTimes(this.clockIn, this.clockOut);
  final DateTime clockIn;
  final DateTime clockOut;
}

/// Bottom sheet that lets the supervisor correct clock-in / clock-out.
/// Returns [AdaptedTimes] (or null if dismissed).
Future<AdaptedTimes?> showAdaptShiftSheet(BuildContext context, PendingShift shift) {
  return showModalBottomSheet<AdaptedTimes>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _AdaptShiftSheet(shift: shift),
  );
}

class _AdaptShiftSheet extends StatefulWidget {
  const _AdaptShiftSheet({required this.shift});
  final PendingShift shift;

  @override
  State<_AdaptShiftSheet> createState() => _AdaptShiftSheetState();
}

class _AdaptShiftSheetState extends State<_AdaptShiftSheet> {
  late DateTime _in = widget.shift.clockIn;
  late DateTime _out = widget.shift.clockOut;

  Duration get _duration {
    final d = _out.difference(_in);
    return d.isNegative ? Duration.zero : d;
  }

  bool get _valid => _out.isAfter(_in);

  Future<void> _pick(bool isIn) async {
    final current = isIn ? _in : _out;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (t == null) return;
    setState(() {
      final next = DateTime(current.year, current.month, current.day, t.hour, t.minute);
      if (isIn) {
        _in = next;
      } else {
        _out = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Adapt Shift',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: TcPalette.text)),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            Text(
              '${widget.shift.employeeName} · ${TcFormat.date(widget.shift.date)}',
              style: const TextStyle(fontSize: 11, color: TcPalette.muted),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _TimeField(label: 'Clock In', value: TcFormat.time24(_in), onTap: () => _pick(true))),
                const SizedBox(width: 12),
                Expanded(child: _TimeField(label: 'Clock Out', value: TcFormat.time24(_out), onTap: () => _pick(false))),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text('Duration', style: TextStyle(fontSize: 11, color: TcPalette.muted)),
                const Spacer(),
                Text(TcFormat.durationLabel(_duration),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TcPalette.text)),
              ],
            ),
            if (!_valid) ...[
              const SizedBox(height: 8),
              const Text('Clock Out must be after Clock In.',
                  style: TextStyle(fontSize: 10, color: TcPalette.red)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: _valid ? () => Navigator.of(context).pop(AdaptedTimes(_in, _out)) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TcPalette.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Save & Approve',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: TcPalette.muted)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: TcPalette.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(value,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: TcPalette.text)),
                ),
                const Icon(Icons.access_time, size: 16, color: TcPalette.muted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Reject confirmation with an optional reason. Returns the reason
/// (possibly empty) on confirm, or null if cancelled.
Future<String?> showRejectDialog(BuildContext context, {required String title, required String subject}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _RejectDialog(title: title, subject: subject),
  );
}

class _RejectDialog extends StatefulWidget {
  const _RejectDialog({required this.title, required this.subject});
  final String title;
  final String subject;

  @override
  State<_RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<_RejectDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(widget.title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.subject, style: const TextStyle(fontSize: 11, color: TcPalette.muted)),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _controller,
            maxLines: 3,
            hintText: 'Reason (optional)',
            isFilled: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: TcPalette.muted)),
        ),
        TcActionButton(
          label: 'Reject',
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          background: TcPalette.red,
        ),
      ],
    );
  }
}
