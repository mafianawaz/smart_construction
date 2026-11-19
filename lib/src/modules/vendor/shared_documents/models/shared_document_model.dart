/// A single document shared with the field worker by their contractor.
class SharedDocumentModel {
  final String id;
  final String title;
  final String organizationName;
  final String fileSize;
  final DateTime sharedDate;

  /// Category tag shown on the card, e.g. "OTHER". Free-text rather than an
  /// enum since the reference only shows one value and the real set of
  /// categories isn't known yet.
  final String category;

  /// Format tag shown on the card, e.g. "PDF".
  final String fileFormat;

  const SharedDocumentModel({
    required this.id,
    required this.title,
    required this.organizationName,
    required this.fileSize,
    required this.sharedDate,
    required this.category,
    required this.fileFormat,
  });

  /// Card format, e.g. "12/09/2023".
  String get formattedDate =>
      '${sharedDate.month.toString().padLeft(2, '0')}/'
      '${sharedDate.day.toString().padLeft(2, '0')}/'
      '${sharedDate.year}';
}
