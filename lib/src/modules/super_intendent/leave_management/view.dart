import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';

import '../../../utils/app_icons.dart';
import 'leave_request/view.dart';
import 'logic.dart';
import 'model/leave_model.dart';


const _muted = Color(0xFF8A94A6);
const _ink = Color(0xFF111827);

class SuperInLeaveManagementView extends StatelessWidget {
  const SuperInLeaveManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SuperInLeaveManagementLogic());

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Leave Management',
        subtitle: 'Manage time-off requests and leave balances',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('My Leave Balances'),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: c.balanceTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => _BalanceCard(
                  type: c.balanceTypes[i],
                  used: c.usedDays(c.balanceTypes[i]),
                  remaining: c.remainingDays(c.balanceTypes[i]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomIconButton(
              onPressed: () => Get.to(() => const RequestLeaveView()),
              icon: AppIcons.add,
              text: 'Request Leave',
            ),
            const SizedBox(height: 20),
            const _SectionTitle('My Leave Request History'),
            const SizedBox(height: 10),
            Obx(() => c.requests.isEmpty
                ? const _EmptyState()
                : Column(
              children: [
                for (final r in c.requests)
                  _RequestCard(
                    request: r,
                    onCancel: () => c.cancelRequest(r.id),
                  ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: _ink));
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 2))
  ],
);

class _BalanceCard extends StatelessWidget {
  final LeaveType type;
  final int used, remaining;
  const _BalanceCard(
      {required this.type, required this.used, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final total = type.totalDays!;
    return Container(
      width: 130,
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SvgPicture.asset(type.icon, height: 14, color: kLeaveOrange),
            const SizedBox(width: 4),
            Flexible(
              child: Text(type.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 4),
          Text('$remaining',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : used / total,
              minHeight: 3,
              backgroundColor: const Color(0xFFE5E7EB),
              color: kLeaveOrange,
            ),
          ),
          const SizedBox(height: 4),
          Text('$used used / $total total',
              style: const TextStyle(fontSize: 9, color: _muted)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    decoration: _cardDecoration(),
    child: Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
              color: Color(0xFFD9F5E8), shape: BoxShape.circle),
          child: const Icon(Icons.calendar_today_outlined,
              size: 20, color: Color(0xFF10B981)),
        ),
        const SizedBox(height: 12),
        const Text('No leave requests yet',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text(
          'Submit your first leave request above to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: _muted),
        ),
      ],
    ),
  );
}

class _RequestCard extends StatelessWidget {
  final LeaveRequest request;
  final VoidCallback onCancel;
  const _RequestCard({required this.request, required this.onCancel});

  // Colors follow the design (pending = green, approved = orange).
  (Color bg, Color fg, String label) get _chip => switch (request.status) {
    LeaveStatus.pending => (
    const Color(0xFFD9F5E8),
    const Color(0xFF10B981),
    'Pending'
    ),
    LeaveStatus.approved => (
    const Color(0xFFFFE8D6),
    kLeaveOrange,
    'Approved'
    ),
    LeaveStatus.rejected => (
    const Color(0xFFFDE2E2),
    const Color(0xFFDC2626),
    'Rejected'
    ),
  };

  @override
  Widget build(BuildContext context) {
    final chip = _chip;
    final r = request;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      decoration: _cardDecoration(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: kLeaveOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.type.label,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: chip.$1,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(chip.$3,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: chip.$2)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isoDate(r.start)} to ${isoDate(r.end)} '
                        '(${r.days} ${r.days == 1 ? 'day' : 'days'})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (r.reason.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Reason: ${r.reason}',
                        style: const TextStyle(fontSize: 11, color: _muted)),
                  ],
                ],
              ),
            ),
            if (r.status == LeaveStatus.pending)
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: onCancel,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF3F4F6),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Icon(Icons.close, size: 14, color: _muted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}