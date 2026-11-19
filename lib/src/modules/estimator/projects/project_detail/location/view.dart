import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../../widgets/project_list_tile.dart';
import '../widgets/project_action_button.dart';
import 'logic.dart';

/// Location tab — description, "Add Location", then the hierarchy or its
/// empty state ("No Location Set Up"). Each row is indented by level.
class LocationView extends StatelessWidget {
  final String projectId;
  const LocationView({super.key, required this.projectId});

  IconData _iconFor(LocationLevel level) {
    switch (level) {
      case LocationLevel.building:
        return Icons.apartment_outlined;
      case LocationLevel.floor:
        return Icons.layers_outlined;
      case LocationLevel.room:
        return Icons.meeting_room_outlined;
      case LocationLevel.zone:
        return Icons.grid_view_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationLogic>(
      init: LocationLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organize Project Takeoff by Building, Floor, Rooms, and Zone',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 12),
              ProjectActionButton(
                label: 'Add Location',
                icon: Icons.add,
                onPressed: logic.openAddLocation,
              ),
              const SizedBox(height: 12),
              Obx(() {
                final list = logic.orderedLocations;
                if (list.isEmpty) {
                  return const ProjectEmptyCard(
                    icon: Icons.place_outlined,
                    message: 'No Location Set Up',
                  );
                }
                return Column(
                  children: [
                    for (final l in list)
                      Padding(
                        padding: EdgeInsets.only(left: l.level.index * 14.0),
                        child: ProjectListTile(
                          icon: _iconFor(l.level),
                          title: l.name,
                          subtitle: l.description,
                          trailing: ProjectBadge(
                            label: l.level.label,
                            background: Colors.grey.shade200,
                            foreground: Colors.grey.shade700,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
