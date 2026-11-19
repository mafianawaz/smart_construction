/// "Loading…." in the reference stood in for content that hadn't been
/// designed yet — modeled here as simple completion counts pending a
/// real spec, flagged in NOTES_PROJECTS.md.
class CloseoutReadinessModel {
  final int submittalsComplete;
  final int submittalsTotal;
  final int punchListResolved;
  final int punchListTotal;
  final String packageStatus;

  const CloseoutReadinessModel({
    this.submittalsComplete = 0,
    this.submittalsTotal = 0,
    this.punchListResolved = 0,
    this.punchListTotal = 0,
    this.packageStatus = 'Not started',
  });
}
