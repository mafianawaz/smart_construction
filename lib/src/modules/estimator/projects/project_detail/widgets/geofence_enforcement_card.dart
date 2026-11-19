import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../models/geofence_models.dart';
import '../../models/project_enums.dart';
import 'detail_card.dart';

class GeofenceEnforcementCard extends StatelessWidget {
  final GeofenceSettings settings;
  final ValueChanged<GeofenceEnforcementMode> onModeChanged;
  final VoidCallback onSetSiteCoordinates;
  final VoidCallback onPickOnMap;

  const GeofenceEnforcementCard({
    super.key,
    required this.settings,
    required this.onModeChanged,
    required this.onSetSiteCoordinates,
    required this.onPickOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final hasCoords = settings.siteCoordinates != null;
    return DetailCard(
      title: 'Geo-fence Enforcement',
      subtitle: hasCoords
          ? 'Geofence checks run on clock-in.'
          : 'No geofence checks on clock-in',
      children: [
        const Text('Enforcement Mode',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final mode in GeofenceEnforcementMode.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(mode.label),
                  selected: settings.mode == mode,
                  selectedColor: AppColors.primaryOrange,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: settings.mode == mode ? Colors.white : AppColors.textMuted,
                  ),
                  backgroundColor: Colors.white,
                  onSelected: (_) => onModeChanged(mode),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          hasCoords ? 'Site coordinates configured' : 'No site coordinates configured',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onSetSiteCoordinates,
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: const BorderSide(color: AppColors.fieldBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.fieldBorder)
                    )
                ),
                child: const Text('Set Site Coordinates', style: TextStyle(fontSize: 12, color: Colors.grey),),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: onPickOnMap,
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: const BorderSide(color: AppColors.fieldBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
                child: const Text('Pick on Map', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
