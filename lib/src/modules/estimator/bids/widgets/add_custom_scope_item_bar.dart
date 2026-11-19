import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

/// "Add Custom Scope Item" card: Description / Qty / Unit + orange "+".
class AddCustomScopeItemBar extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final VoidCallback onAdd;

  const AddCustomScopeItemBar({
    super.key,
    required this.descriptionController,
    required this.quantityController,
    required this.unitController,
    required this.onAdd,
  });

  Widget _labeled(String label, Widget field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          field,
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Custom Scope Item',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child:  CustomTextField(
                  heading: 'Description',
                  controller: descriptionController,
                  hintText: 'e.g. Demo existing ramp',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child:  CustomTextField(
                  heading: 'Qty',
                  controller: quantityController,
                  hintText: '1',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: CustomTextField(
                  heading: 'Unit',
                  hintText: 'lot',
                  controller: unitController,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
