import 'package:get/get.dart';

import '../models/bid_model.dart';
import '../models/clarification_model.dart';

/// State for one Bid Details screen. Created with `tag: bid.id` so two
/// details screens never share state.
class BidDetailsLogic extends GetxController {
  final BidModel bid;
  BidDetailsLogic(this.bid);

  final RxList<ClarificationModel> clarifications = <ClarificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // API: GET /bids/{id}/clarifications
    clarifications.assignAll(bid.clarifications);
  }

  // API: POST /bids/{id}/clarifications { question }
  void addQuestion(String question) {
    final q = question.trim();
    if (q.isEmpty) return;
    clarifications.add(
      ClarificationModel(
        id: 'clar_${DateTime.now().microsecondsSinceEpoch}',
        question: q,
        askedBy: 'You',
        askedAt: DateTime.now(),
      ),
    );
  }

  // API: GET /bids/{id}/documents (download)
  void downloadDocuments() {
    Get.snackbar('Documents', 'Download is not wired up yet.');
  }
}
