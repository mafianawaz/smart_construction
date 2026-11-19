import 'package:flutter/material.dart';
import 'detail_card.dart';

class DescriptionCard extends StatelessWidget {
  final String description;
  const DescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Description',
      children: [
        Text(
          description.isEmpty ? 'No description provided.' : description,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
        ),
      ],
    );
  }
}
