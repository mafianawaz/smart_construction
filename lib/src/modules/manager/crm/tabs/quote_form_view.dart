import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../models/crm_activity_models.dart';
import '../widgets/crm_activity_style.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_date_field.dart';
import '../widgets/crm_form_fields.dart';
import '../widgets/crm_palette.dart';

/// New Quote form. Pushed as its own route and returns the finished
/// [QuoteModel] (status Draft) via `Get.back(result: ...)`; the caller hands
/// it to `CrmLogic.addQuote`.
///
/// The reference only shows the "New Quote" buttons, so this layout is this
/// module's own design (see NOTES_CRM.md).
class QuoteFormView extends StatefulWidget {
  final String id;
  final String number;
  final List<String> organizationNames;

  const QuoteFormView({
    super.key,
    required this.id,
    required this.number,
    required this.organizationNames,
  });

  @override
  State<QuoteFormView> createState() => _QuoteFormViewState();
}

/// Controllers for one editable line-item row.
class _LineDraft {
  final description = TextEditingController();
  final quantity = TextEditingController(text: '1');
  final unitPrice = TextEditingController();

  double get qty => _parse(quantity.text) ?? 0;
  double get price => _parse(unitPrice.text) ?? 0;

  static double? _parse(String text) =>
      double.tryParse(text.trim().replaceAll(',', ''));

  void dispose() {
    description.dispose();
    quantity.dispose();
    unitPrice.dispose();
  }
}

class _QuoteFormViewState extends State<QuoteFormView> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final List<_LineDraft> _lines = [_LineDraft()];

  String? _organization;
  DateTime? _validUntil;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  double get _total =>
      _lines.fold(0.0, (sum, line) => sum + line.qty * line.price);

  void _addLine() => setState(() => _lines.add(_LineDraft()));

  void _removeLine(int index) {
    if (_lines.length <= 1) return;
    final removed = _lines[index];
    setState(() => _lines.removeAt(index));
    // Dispose after the frame so the removed row's fields have detached.
    WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Get.back<QuoteModel>(
      result: QuoteModel(
        id: widget.id,
        number: widget.number,
        title: _title.text.trim(),
        organizationName: _organization ?? '',
        lineItems: [
          for (final line in _lines)
            QuoteLineItem(
              description: line.description.text.trim(),
              quantity: line.qty,
              unitPrice: line.price,
            ),
        ],
        validUntil: _validUntil,
        notes: _notes.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'New Quote',
        subtitle: 'Quote ${widget.number} · saved as a draft.',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CrmTextField(
                label: 'Quote title',
                controller: _title,
                hint: 'e.g. Riverside warehouse slab',
                isRequired: true,
              ),
              const SizedBox(height: 14),
              CrmDropdownField<String>(
                label: 'Organization',
                value: _organization,
                items: widget.organizationNames,
                labelOf: (n) => n,
                hint: 'Select organization',
                isRequired: true,
                onChanged: (v) => setState(() => _organization = v),
              ),
              const SizedBox(height: 14),
              CrmDateField(
                label: 'Valid until (optional)',
                value: _validUntil,
                firstDate: today,
                lastDate: DateTime(today.year + 5),
                pickerHelp: 'Valid until',
                onChanged: (d) => setState(() => _validUntil = d),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Line items',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CrmPalette.text,
                      ),
                    ),
                  ),
                  CrmSmallButton(
                    label: 'Add item',
                    icon: Icons.add,
                    onTap: _addLine,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < _lines.length; i++)
                _LineItemCard(
                  key: ObjectKey(_lines[i]),
                  index: i,
                  draft: _lines[i],
                  canRemove: _lines.length > 1,
                  onRemove: () => _removeLine(i),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CrmPalette.textMuted,
                        ),
                      ),
                    ),
                    // Rebuilds as quantities / prices are typed.
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        for (final line in _lines) ...[
                          line.quantity,
                          line.unitPrice,
                        ],
                      ]),
                      builder: (context, _) => Text(
                        crmMoneyPrecise(_total),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: CrmPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CrmTextField(
                label: 'Notes (optional)',
                controller: _notes,
                maxLines: 3,
                hint: 'Terms, exclusions, payment schedule…',
              ),
              const SizedBox(height: 24),
              CrmPrimaryButton(text: 'Create Quote', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineItemCard extends StatelessWidget {
  final int index;
  final _LineDraft draft;
  final bool canRemove;
  final VoidCallback onRemove;

  const _LineItemCard({
    super.key,
    required this.index,
    required this.draft,
    required this.canRemove,
    required this.onRemove,
  });

  static String? _positive(String? v) {
    final n = double.tryParse((v ?? '').trim().replaceAll(',', ''));
    return (n == null || n <= 0) ? 'Invalid' : null;
  }

  static String? _nonNegative(String? v) {
    final n = double.tryParse((v ?? '').trim().replaceAll(',', ''));
    return (n == null || n < 0) ? 'Invalid' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ),
              if (canRemove)
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: CrmPalette.textMuted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          CrmTextField(
            label: 'Description',
            controller: draft.description,
            isRequired: true,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CrmTextField(
                  label: 'Qty',
                  controller: draft.quantity,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: _positive,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: CrmTextField(
                  label: 'Unit price (\$)',
                  controller: draft.unitPrice,
                  hint: '0',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: _nonNegative,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
