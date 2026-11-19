/// A single question raised against a bid, with an optional GC response.
class ClarificationModel {
  final String id;
  final String question;
  final DateTime askedAt;
  final String? response;
  final DateTime? respondedAt;

  const ClarificationModel({
    required this.id,
    required this.question,
    required this.askedAt,
    this.response,
    this.respondedAt,
  });

  bool get isAwaitingResponse => response == null;

  ClarificationModel copyWith({
    String? response,
    DateTime? respondedAt,
  }) {
    return ClarificationModel(
      id: id,
      question: question,
      askedAt: askedAt,
      response: response ?? this.response,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  // TODO(api): replace with ClarificationModel.fromJson when
  // GET /api/bids/{bidId}/clarifications is wired up.
}
