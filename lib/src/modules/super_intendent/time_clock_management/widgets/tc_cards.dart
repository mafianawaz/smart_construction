import 'package:flutter/material.dart';
import '../data/tc_format.dart';
import '../models/time_clock_models.dart';
import 'tc_common.dart';
import 'tc_palette.dart';

/// Row in the Live Monitoring list (flat, divider underneath).
class ActiveShiftTile extends StatelessWidget {
  const ActiveShiftTile({super.key, required this.shift});

  final ActiveShift shift;

  @override
  Widget build(BuildContext context) {
    final elapsed = shift.elapsed();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TcPalette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shift.employeeName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TcPalette.text),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TcPalette.greenBg,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: TcPalette.green),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: TcPalette.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(alignment: Alignment.centerLeft, child: TcRoleChip(role: shift.role)),
          TcInfoRow(icon: Icons.location_on_outlined, child: TcInfoText(shift.location)),
          TcInfoRow(icon: Icons.person_outline, child: TcInfoText('ID: ${shift.employeeId}')),
          TcInfoRow(
            icon: Icons.access_time,
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 11, color: TcPalette.muted),
                children: [
                  TextSpan(text: 'Clock In: ${TcFormat.time12(shift.clockIn)} '),
                  TextSpan(
                    text: '(${TcFormat.ago(shift.clockIn)})',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: TcPalette.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  TcFormat.hm(elapsed),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TcPalette.orange),
                ),
                const SizedBox(width: 6),
                const Text('active', style: TextStyle(fontSize: 10, color: TcPalette.muted)),
              ],
            ),
          ),
          TcInfoRow(
            icon: Icons.map_outlined,
            child: Row(
              children: [
                Text(shift.coordinatesLabel, style: const TextStyle(fontSize: 10, color: TcPalette.muted)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: TcPalette.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    shift.hasGeofence ? 'Geofence' : 'No Geofence',
                    style: const TextStyle(fontSize: 9, color: TcPalette.muted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: TcPalette.border),
      boxShadow: const [
        BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
      ],
    );

/// Pending shift card with Approve / Adapt / Reject.
class PendingShiftCard extends StatelessWidget {
  const PendingShiftCard({
    super.key,
    required this.shift,
    required this.onApprove,
    required this.onAdapt,
    required this.onReject,
  });

  final PendingShift shift;
  final VoidCallback onApprove;
  final VoidCallback onAdapt;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                shift.employeeName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TcPalette.text),
              ),
              const SizedBox(width: 8),
              TcRoleChip(role: shift.role, purple: true),
              const Spacer(),
              Text(TcFormat.date(shift.date),
                  style: const TextStyle(fontSize: 10, color: TcPalette.muted)),
            ],
          ),
          TcInfoRow(icon: Icons.location_on_outlined, child: TcInfoText(shift.projectLabel)),
          TcInfoRow(icon: Icons.person_outline, child: TcInfoText('ID: ${shift.employeeId}')),
          TcInfoRow(
            icon: Icons.access_time,
            child: TcInfoText(
              'In: ${TcFormat.time24(shift.clockIn)}, Out: ${TcFormat.time24(shift.clockOut)}',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Duration', style: TextStyle(fontSize: 11, color: TcPalette.muted)),
              const Spacer(),
              Text(
                TcFormat.durationLabel(shift.duration),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TcPalette.text),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TcActionButton(label: 'Approve', onPressed: onApprove, background: TcPalette.green),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TcActionButton(
                  label: 'Adapt',
                  onPressed: onAdapt,
                  background: TcPalette.surface,
                  foreground: TcPalette.text,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TcActionButton(label: 'Reject', onPressed: onReject, background: TcPalette.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Overtime request card with Approve / Reject.
class OvertimeRequestCard extends StatelessWidget {
  const OvertimeRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final OvertimeRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
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
                    Text(
                      request.employeeName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TcPalette.text),
                    ),
                    const SizedBox(height: 2),
                    Text(request.location,
                        style: const TextStyle(fontSize: 10, color: TcPalette.muted)),
                    const SizedBox(height: 2),
                    Text(TcFormat.date(request.date),
                        style: const TextStyle(fontSize: 10, color: TcPalette.muted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${TcFormat.hours(request.regularHours)} regular',
                      style: const TextStyle(fontSize: 10, color: TcPalette.muted)),
                  const SizedBox(height: 2),
                  Text(TcFormat.ago(request.requestedAt),
                      style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF))),
                ],
              ),
            ],
          ),
          if (request.note.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Note: ${request.note}',
                style: const TextStyle(fontSize: 10, color: TcPalette.muted)),
          ],
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TcFormat.overtime(request.overtimeHours),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: TcPalette.orange),
                  ),
                  const Text('OT Requested', style: TextStyle(fontSize: 9, color: TcPalette.muted)),
                ],
              ),
              const Spacer(),
              TcActionButton(
                label: 'Approve',
                icon: Icons.check,
                onPressed: onApprove,
                background: TcPalette.green,
              ),
              const SizedBox(width: 8),
              TcActionButton(
                label: 'Reject',
                icon: Icons.close,
                onPressed: onReject,
                background: TcPalette.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card shown on the Time Entry tab.
class TimeEntryRedirectCard extends StatelessWidget {
  const TimeEntryRedirectCard({super.key, required this.onGo});

  final VoidCallback onGo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: TcPalette.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment_outlined, size: 26, color: TcPalette.muted),
          ),
          const SizedBox(height: 14),
          const Text(
            'Time Entry Approvals',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TcPalette.text),
          ),
          const SizedBox(height: 10),
          const Text(
            'Review and approve employee time entries on the dedicated Time Entry Management page.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, height: 1.4, color: TcPalette.muted),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onGo,
              style: ElevatedButton.styleFrom(
                backgroundColor: TcPalette.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                'Go to Time Entry Management',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state for a list tab.
class TcEmptyBlock extends StatelessWidget {
  const TcEmptyBlock({super.key, required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 36, color: TcPalette.muted),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TcPalette.text)),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: TcPalette.muted)),
        ],
      ),
    );
  }
}
