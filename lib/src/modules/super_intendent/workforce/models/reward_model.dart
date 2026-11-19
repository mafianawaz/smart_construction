/// Workforce → Rewards model.
enum RewardIconKind { champion, topPerformer, earlyBird, teamPlayer, star }

class RewardModel {
  final String id;
  final String title;
  final String description;
  final DateTime awardedOn;
  final String awardedBy;
  final int points;
  final RewardIconKind icon;

  const RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.awardedOn,
    required this.awardedBy,
    required this.points,
    this.icon = RewardIconKind.star,
  });
}
