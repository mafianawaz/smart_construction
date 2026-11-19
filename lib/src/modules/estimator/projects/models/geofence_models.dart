import 'project_enums.dart';

class SiteCoordinates {
  final double latitude;
  final double longitude;
  const SiteCoordinates({required this.latitude, required this.longitude});
}

class GeofenceZoneModel {
  final String id;
  final String name;
  final String type; // e.g. "Staging Area", "Parking Lot"

  const GeofenceZoneModel({
    required this.id,
    required this.name,
    required this.type,
  });
}

class GeofenceSettings {
  final GeofenceEnforcementMode mode;
  final SiteCoordinates? siteCoordinates;
  final List<GeofenceZoneModel> zones;

  const GeofenceSettings({
    this.mode = GeofenceEnforcementMode.off,
    this.siteCoordinates,
    this.zones = const [],
  });

  GeofenceSettings copyWith({
    GeofenceEnforcementMode? mode,
    SiteCoordinates? siteCoordinates,
    List<GeofenceZoneModel>? zones,
  }) {
    return GeofenceSettings(
      mode: mode ?? this.mode,
      siteCoordinates: siteCoordinates ?? this.siteCoordinates,
      zones: zones ?? this.zones,
    );
  }
}

/// One row of the "Geo-fence Compliance" date-range report.
class ShiftGeofenceStatus {
  final String workerName;
  final DateTime shiftDate;
  final bool wasInsideGeofence;

  const ShiftGeofenceStatus({
    required this.workerName,
    required this.shiftDate,
    required this.wasInsideGeofence,
  });
}
