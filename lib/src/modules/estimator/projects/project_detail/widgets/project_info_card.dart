import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import 'detail_card.dart';

class ProjectInfoCard extends StatelessWidget {
  final ProjectModel project;
  const ProjectInfoCard({super.key, required this.project});

  String _dash(String? v) => (v == null || v.isEmpty) ? 'N/A' : v;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Project Information',
      children: [
        Row(
          children: [
            Expanded(
              child: DetailFieldPair(label: 'Client', value: _dash(project.contactName)),
            ),
            Expanded(
              child: DetailFieldPair(
                label: 'Status',
                value: project.isRecordActive ? 'ACTIVE' : 'INACTIVE',
                valueColor: project.isRecordActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: DetailFieldPair(label: 'Contact', value: _dash(project.contactTitle))),
            Expanded(child: DetailFieldPair(label: 'Email', value: _dash(project.contactEmail))),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: DetailFieldPair(label: 'Phone', value: _dash(project.contactPhone))),
            Expanded(child: DetailFieldPair(label: 'Location', value: _dash(project.location))),
          ],
        ),
      ],
    );
  }
}
