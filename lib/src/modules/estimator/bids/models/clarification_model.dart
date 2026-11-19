class ClarificationModel {
  final String id;
  final String question;
  final String askedBy;
  final DateTime askedAt;
  final String? answer;

  const ClarificationModel({
    required this.id,
    required this.question,
    required this.askedBy,
    required this.askedAt,
    this.answer,
  });

  bool get isAnswered => answer != null && answer!.trim().isNotEmpty;
}
