/// The three executive views on the Portfolio Rollup screen.
enum RollupTab { heatmap, gantt, financial }

extension RollupTabX on RollupTab {
  String get label => switch (this) {
        RollupTab.heatmap => 'Health Heatmap',
        RollupTab.gantt => 'Portfolio Gantt',
        RollupTab.financial => 'Financial Rollup',
      };
}

/// Project lifecycle status. `bid` is only offered by the Health Heatmap
/// filter row (the Gantt and Financial rows have four chips, no BID).
enum RollupStatus { planning, active, complete, closed, bid }

extension RollupStatusX on RollupStatus {
  /// Title case, used on cards and badges.
  String get label => switch (this) {
        RollupStatus.planning => 'Planning',
        RollupStatus.active => 'Active',
        RollupStatus.complete => 'Complete',
        RollupStatus.closed => 'Closed',
        RollupStatus.bid => 'Bid',
      };

  /// Upper case, used on filter chips and Gantt row labels.
  String get upperLabel => label.toUpperCase();
}
