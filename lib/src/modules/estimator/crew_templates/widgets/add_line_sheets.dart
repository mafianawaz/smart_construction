import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/crew_models.dart';
import 'crew_buttons.dart';
import 'crew_field.dart';
import 'crew_palette.dart';

final _decimalOnly = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
];
const _decimalKeys = TextInputType.numberWithOptions(decimal: true);

/// Opens the Add Worker sheet; resolves to the worker or null if dismissed.
Future<CrewWorkerModel?> showAddWorkerSheet() => Get.bottomSheet<CrewWorkerModel>(
      const _AddWorkerSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );

/// Opens the Add Equipment sheet; resolves to the item or null if dismissed.
Future<CrewEquipmentModel?> showAddEquipmentSheet() =>
    Get.bottomSheet<CrewEquipmentModel>(
      const _AddEquipmentSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );

class _SheetFrame extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SheetFrame({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: CrewPalette.ink,
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AddWorkerSheet extends StatefulWidget {
  const _AddWorkerSheet();

  @override
  State<_AddWorkerSheet> createState() => _AddWorkerSheetState();
}

class _AddWorkerSheetState extends State<_AddWorkerSheet> {
  final _role = TextEditingController();
  final _count = TextEditingController(text: '1');
  final _rate = TextEditingController();
  final _burden = TextEditingController(text: '0');
  String? _error;

  @override
  void dispose() {
    _role.dispose();
    _count.dispose();
    _rate.dispose();
    _burden.dispose();
    super.dispose();
  }

  void _submit() {
    final count = int.tryParse(_count.text.trim());
    final rate = double.tryParse(_rate.text.trim());
    final burden = double.tryParse(_burden.text.trim()) ?? 0;
    if (_role.text.trim().isEmpty ||
        count == null ||
        count < 1 ||
        rate == null ||
        rate <= 0) {
      setState(() => _error = 'Role, a count of 1+ and an hourly rate are required');
      return;
    }
    Get.back(
      result: CrewWorkerModel(
        role: _role.text.trim(),
        count: count,
        hourlyRate: rate,
        burdenPercent: burden,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Add Worker',
      children: [
        CrewField(
          heading: 'Role',
          hintText: 'e.g. Foreman, Laborer',
          controller: _role,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CrewField(
                heading: 'Count',
                hintText: '1',
                controller: _count,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CrewField(
                heading: 'Hourly Rate (\$)',
                hintText: '0.00',
                controller: _rate,
                keyboardType: _decimalKeys,
                inputFormatters: _decimalOnly,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CrewField(
                heading: 'Burden (%)',
                hintText: '0',
                controller: _burden,
                keyboardType: _decimalKeys,
                inputFormatters: _decimalOnly,
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(fontSize: 10, color: CrewPalette.danger),
          ),
        ],
        const SizedBox(height: 16),
        CrewButton(text: 'Add Worker', onPressed: _submit),
      ],
    );
  }
}

class _AddEquipmentSheet extends StatefulWidget {
  const _AddEquipmentSheet();

  @override
  State<_AddEquipmentSheet> createState() => _AddEquipmentSheetState();
}

class _AddEquipmentSheetState extends State<_AddEquipmentSheet> {
  final _name = TextEditingController();
  final _count = TextEditingController(text: '1');
  final _daily = TextEditingController();
  final _fixed = TextEditingController(text: '0');
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _count.dispose();
    _daily.dispose();
    _fixed.dispose();
    super.dispose();
  }

  void _submit() {
    final count = int.tryParse(_count.text.trim());
    final daily = double.tryParse(_daily.text.trim());
    final fixed = double.tryParse(_fixed.text.trim()) ?? 0;
    if (_name.text.trim().isEmpty ||
        count == null ||
        count < 1 ||
        daily == null ||
        daily < 0) {
      setState(() => _error = 'Name, a count of 1+ and a daily rate are required');
      return;
    }
    Get.back(
      result: CrewEquipmentModel(
        name: _name.text.trim(),
        count: count,
        dailyRate: daily,
        fixedCost: fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Add Equipment',
      children: [
        CrewField(
          heading: 'Equipment',
          hintText: 'e.g. Concrete Pump',
          controller: _name,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CrewField(
                heading: 'Count',
                hintText: '1',
                controller: _count,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CrewField(
                heading: 'Daily Rate (\$)',
                hintText: '0.00',
                controller: _daily,
                keyboardType: _decimalKeys,
                inputFormatters: _decimalOnly,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CrewField(
                heading: 'Fixed (\$)',
                hintText: '0.00',
                controller: _fixed,
                keyboardType: _decimalKeys,
                inputFormatters: _decimalOnly,
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(fontSize: 10, color: CrewPalette.danger),
          ),
        ],
        const SizedBox(height: 16),
        CrewButton(text: 'Add Equipment', onPressed: _submit),
      ],
    );
  }
}
