import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import 'detail_card.dart';

class FinancialInfoCard extends StatelessWidget {
  final ProjectModel project;
  const FinancialInfoCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Financial Information',
      children: [
        DetailFieldPair(label: 'Project Budget', value: project.budgetLabel),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: DetailFieldPair(
                  label: 'Contract Amount', value: project.contractAmountLabel),
            ),
            Expanded(child: DetailFieldPair(label: 'Margin', value: project.marginLabel)),
          ],
        ),
      ],
    );
  }
}
