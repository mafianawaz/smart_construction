import 'package:get/get.dart';

import '../models/bid_model.dart';
import '../models/clarification_model.dart';

class BidDetailsLogic extends GetxController {
  BidDetailsLogic(BidModel bid) : _bid = bid.obs;

  final Rx<BidModel> _bid;
  BidModel get bid => _bid.value;

  bool get isExpired => bid.isExpired;

  void askQuestion(String question) {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;

    final clarification = ClarificationModel(
      id: 'clar-${DateTime.now().millisecondsSinceEpoch}',
      question: trimmed,
      askedAt: DateTime.now(),
    );

    // TODO(api): POST /api/bids/{bidId}/clarifications { question }
    _bid.value = bid.copyWith(
      clarifications: [...bid.clarifications, clarification],
    );
  }
}
