import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/project_enums.dart';
import '../../../widgets/project_empty_card.dart';
import '../../widgets/project_action_button.dart';
import '../../widgets/project_format.dart';
import '../logic.dart';
import '../widgets/financial_record_tiles.dart';
import '../widgets/financials_card.dart';
import '../widgets/orange_segment_strip.dart';

/// Schedule of Values — "New SOV", the orange Pay App / Payments / Lien
/// Waivers / CO Tie-Out strip, and the content for the selected strip tab
/// (a grey "Record Payment" / "New Waiver" action on Payments and Lien
/// Waivers, then the list or its empty state).
class ScheduleOfValuesSection extends StatelessWidget {
  final FinancialsLogic logic;
  const ScheduleOfValuesSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectActionButton(label: 'New SOV', icon: Icons.add, onPressed: logic.openNewSov),
        const SizedBox(height: 12),
        Obx(() => OrangeSegmentStrip<SovSubTab>(
              values: SovSubTab.values,
              labelOf: (t) => t.label,
              selected: logic.sovTab.value,
              onChanged: logic.onSovTabChange,
            )),
        const SizedBox(height: 12),
        Obx(() {
          switch (logic.sovTab.value) {
            case SovSubTab.payApp:
              return _payApps();
            case SovSubTab.payments:
              return _payments();
            case SovSubTab.lienWaivers:
              return _waivers();
            case SovSubTab.coTieOut:
              return _tieOut();
          }
        }),
      ],
    );
  }

  Widget _payApps() {
    final list = logic.sovs.toList();
    if (list.isEmpty) {
      return const ProjectEmptyCard(
        icon: Icons.description_outlined,
        message: 'No SOVs yet for this project',
      );
    }
    return Column(children: [
      for (final s in list) SovRecordTile(record: s, paid: logic.paidFor(s.id)),
    ]);
  }

  Widget _payments() {
    final list = logic.payments.toList();
    return Column(
      children: [
        ProjectActionButton(
          label: 'Record Payment',
          icon: Icons.add,
          filled: false,
          onPressed: logic.openRecordPayment,
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const ProjectEmptyCard(
            icon: Icons.credit_card_outlined,
            message: 'No Payment recorded yet',
          )
        else
          for (final p in list)
            PaymentRecordTile(
              record: p,
              sovLabel: _sovLabel(p.sovId),
            ),
      ],
    );
  }

  String _sovLabel(String sovId) {
    final index = logic.sovs.indexWhere((s) => s.id == sovId);
    return index == -1 ? 'SOV' : logic.sovs[index].number;
  }

  Widget _waivers() {
    final list = logic.lienWaivers.toList();
    return Column(
      children: [
        ProjectActionButton(
          label: 'New Waiver',
          icon: Icons.add,
          filled: false,
          onPressed: logic.openNewWaiver,
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const ProjectEmptyCard(
            icon: Icons.assignment_outlined,
            message: 'No Waiver yet',
          )
        else
          for (final w in list) LienWaiverRecordTile(record: w),
      ],
    );
  }

  /// Reconciles approved change orders against SOV pay apps. The reference
  /// shows only the empty state; the populated summary below is a guess.
  Widget _tieOut() {
    final cos = logic.changeOrders;
    final sovs = logic.sovs;
    if (cos.isEmpty && sovs.isEmpty) {
      return const ProjectEmptyCard(
        icon: Icons.link,
        message: 'No Change order or SOV to reconcile for this project yet',
      );
    }
    final coTotal = cos.fold(0.0, (s, c) => s + c.amount);
    final paid = logic.payments.fold(0.0, (s, p) => s + p.amount);
    return FinancialsCard(
      title: 'CO Tie-Out',
      children: [
        _row('Change orders (${cos.length})', projectMoney(coTotal)),
        _row('SOV payments recorded (${sovs.length} ${sovs.length == 1 ? 'SOV' : 'SOVs'})', projectMoney(paid)),
        const Divider(height: 18),
        _row('Difference', projectMoney(coTotal - paid), bold: true),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 11))),
            Text(value,
                style: TextStyle(
                    fontSize: 11, fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
          ],
        ),
      );
}
