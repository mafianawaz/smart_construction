import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../models/geofence_models.dart';
import 'detail_card.dart';

class GeofenceZonesCard extends StatelessWidget {
  final List<GeofenceZoneModel> zones;
  final VoidCallback onAdd;

  const GeofenceZonesCard({super.key, required this.zones, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Geo-fence Zones',
      subtitle: 'Additional geofence boundaries for this project '
          '(e.g., staging areas, parking lots).',
      trailing: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side:  BorderSide(color: AppColors.fieldBorder),
          ),
        ),
        onPressed: onAdd,
        child: const Text('Add', style: TextStyle(color: Colors.grey)),
      ),
      children: [
        if (zones.isEmpty)
          Text(
            'No additional geofence zone configured. The primary site '
            'coordinates are used as the default zone.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          )
        else
          for (final z in zones)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.fence_outlined, size: 14),
                  const SizedBox(width: 6),
                  Text(z.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 6),
                  Text('(${z.type})', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
      ],
    );
  }
}
