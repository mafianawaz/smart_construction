enum PermitUrgency { critical, soon, upcoming, safe }

class PermitModel {
  final String id;
  final String name; // e.g. "Building Permit"
  final String number; // e.g. "BP-2024-001"
  final String projectName;
  final String issuingAuthority;
  final DateTime issuedDate;
  final DateTime expiryDate;

  const PermitModel({
    required this.id,
    required this.name,
    required this.number,
    required this.projectName,
    required this.issuingAuthority,
    required this.issuedDate,
    required this.expiryDate,
  });

  String get displayTitle => '$name #$number';

  /// Whole calendar days from [now] (date-only) to expiry. Negative = expired.
  int daysRemaining([DateTime? now]) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  PermitUrgency urgency([DateTime? now]) {
    final d = daysRemaining(now);
    if (d <= 7) return PermitUrgency.critical;
    if (d <= 14) return PermitUrgency.soon;
    if (d <= 21) return PermitUrgency.upcoming;
    return PermitUrgency.safe;
  }

  String daysLabel([DateTime? now]) {
    final d = daysRemaining(now);
    if (d < 0) return 'Expired';
    if (d == 0) return 'Today';
    return d == 1 ? '1 day' : '$d days';
  }
}
