import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_textfield.dart';
import '../widgets/cost_form_card.dart';
import 'logic.dart';

class AddCostRecordView extends StatelessWidget {
  const AddCostRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    const number = TextInputType.numberWithOptions(decimal: true);

    return GetBuilder(
      init: AddCostRecordLogic(),
      builder: (logic){
      return Scaffold(
        appBar: AppPrimaryBar(
          title: 'Add Cost Record',
          showBackButton: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Record actual costs from a completed project for future reference', style: TextStyle(fontSize: 12, color: AppColors.textMuted),),
                const SizedBox(height: 14),
                CostFormCard(children: [
                  CustomTextField(
                    heading: 'Description',
                    hintText: 'e.g., 4-inch concrete slab',
                    controller: logic.description,
                  ),
                  const SizedBox(height: 14),
                  CostFieldRow(
                    left: CustomTextField(
                      heading: 'Scope Category',
                      hintText: 'e.g., CONCRETE',
                      controller: logic.scopeCategory,
                    ),
                    right: CustomTextField(
                      heading: 'Trade',
                      hintText: 'e.g., Concrete',
                      controller: logic.trade,
                    ),
                  ),
                  const SizedBox(height: 14),
                  CostFieldRow(
                    left: CustomTextField(
                      heading: 'Cost Code',
                      hintText: 'e.g., 03-100',
                      controller: logic.costCode,
                    ),
                    // readOnly + onTap: unconfirmed CustomTextField params (see notes).
                    right: CustomTextField(
                      heading: 'Completed Date',
                      hintText: 'dd/mm/yyyy',
                      controller: logic.completedDateText,
                      readOnly: true,
                      onClick: logic.pickCompletedDate,
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                CostFormCard(children: [
                  CostFieldRow(
                    left: CustomTextField(
                      heading: 'Quantity',
                      hintText: '0',
                      controller: logic.quantity,
                      keyboardType: number,
                    ),
                    right: CustomTextField(
                      heading: 'Unit',
                      hintText: 'e.g., CY, SF, LF',
                      controller: logic.unit,
                    ),
                  ),
                  const SizedBox(height: 14),
                  CostFieldRow(
                    left: CustomTextField(
                      heading: 'Unit Cost (\$)',
                      hintText: '0',
                      controller: logic.unitCost,
                      keyboardType: number,
                    ),
                    right: CustomTextField(
                      heading: 'Project Name',
                      hintText: 'Source project...',
                      controller: logic.projectName,
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    heading: 'Project Type',
                    hintText: 'e.g., Commercial, Residential',
                    controller: logic.projectType,
                  ),
                ]),
                const SizedBox(height: 12),
                CostFormCard(title: 'Cost Breakdown', children: [
                  CostFieldRow(
                    left: CustomTextField(
                      heading: 'Material \$',
                      hintText: '0',
                      controller: logic.material,
                      keyboardType: number,
                    ),
                    right: CustomTextField(
                      heading: 'Labor \$',
                      hintText: '0',
                      controller: logic.labor,
                      keyboardType: number,
                    ),
                  ),
                  const SizedBox(height: 14),
                  CostFieldRow(
                    left: CustomTextField(
                      heading: 'Equipment \$',
                      hintText: '0',
                      controller: logic.equipment,
                      keyboardType: number,
                    ),
                    right: CustomTextField(
                      heading: 'Subcontract \$',
                      hintText: '0',
                      controller: logic.subcontract,
                      keyboardType: number,
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                CustomButton(text: 'Add Record', onPressed: logic.submit),
              ],
            ),
          ),
        ),
      );
    });
  }
}
