/// The two Create Bid flows shown in the Figma "Bids" frames.
///
///  * [ai]     — AI-Powered Bid Upload (4 steps):
///               Details -> Upload -> AI Scan -> Scope (then Create Bid)
///  * [manual] — Manual Bid Entry (3 steps):
///               Info -> Scope -> Details (then Create Bid)
enum CreateBidFlow { ai, manual }

extension CreateBidFlowX on CreateBidFlow {
  List<String> get stepLabels {
    switch (this) {
      case CreateBidFlow.ai:
        return const ['Details', 'Upload', 'AI Scan', 'Scope'];
      case CreateBidFlow.manual:
        return const ['Info', 'Scope', 'Details'];
    }
  }
}

/// Drives the loading / failed states of the AI Document Analysis
/// screen. Controller state (not widget branching) decides what renders.
enum AiAnalysisStatus {
  idle,
  analyzing,
  success,
  failed,
  skipped,
}

/// How the draft's scope items were populated.
enum BidEntryMethod {
  aiDocuments,
  manual,
}
