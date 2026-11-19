import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/financial_models.dart';
import '../../models/project_enums.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'record_payment_logic.dart';

/// "Record Payment" — pushed from the Payments strip. SOV Pay App, Amount +
/// Payment Date, Payment Method + Reference #, Notes; Record Payment sits
/// under the card as in the reference.
class RecordPaymentView extends StatelessWidget {
  final String projectId;
  const RecordPaymentView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordPaymentLogic>(
      init: RecordPaymentLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Record Payment',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record a full or partial payment against an SOV pay app.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  ProjectFormCard(
                    children: [
                      Obx(() => ProjectDropdown<SovRecord>(
                            label: 'SOV Pay App',
                            hint: 'Select SOV...',
                            value: logic.sov.value,
                            options: logic.sovs,
                            labelOf: (s) => '${s.number} · ${s.title}',
                            onChanged: (s) => logic.sov.value = s,
                          )),
                      projectFieldGap,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              heading: 'Amount (\$)',
                              hintText: '0.00',
                              controller: logic.amountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => ProjectDateField(
                                  label: 'Payment Date',
                                  hint: 'dd/mm/yyyy',
                                  format: 'dd/MM/yyyy',
                                  value: logic.paymentDate.value,
                                  onChanged: (d) => logic.paymentDate.value = d,
                                )),
                          ),
                        ],
                      ),
                      projectFieldGap,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Obx(() => ProjectDropdown<PaymentMethod>(
                                  label: 'Payment Method',
                                  hint: PaymentMethod.check.label,
                                  value: logic.method.value,
                                  options: PaymentMethod.values,
                                  labelOf: (m) => m.label,
                                  onChanged: (m) =>
                                      logic.method.value = m ?? PaymentMethod.check,
                                )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              heading: 'Reference # (optional)',
                              hintText: '',
                              controller: logic.referenceCtrl,
                            ),
                          ),
                        ],
                      ),
                      projectFieldGap,
                      CustomTextField(
                        heading: 'Notes (optional)',
                        hintText: 'Additional notes or details...',
                        controller: logic.notesCtrl,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Obx(() => CustomButton(
                        text: 'Record Payment',
                        onPressed: logic.isSaving.value ? null : logic.record,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
