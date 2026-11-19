/// Models for the Bid Network feature (contractor → subcontractor bid requests).

enum BidRequestStatus { draft, open, closed }

extension BidRequestStatusX on BidRequestStatus {
  String get label {
    switch (this) {
      case BidRequestStatus.draft:
        return 'DRAFT';
      case BidRequestStatus.open:
        return 'OPEN';
      case BidRequestStatus.closed:
        return 'CLOSED';
    }
  }
}

enum BidNetworkFilter { all, draft, open, closed }

extension BidNetworkFilterX on BidNetworkFilter {
  String get label {
    switch (this) {
      case BidNetworkFilter.all:
        return 'All';
      case BidNetworkFilter.draft:
        return 'Draft';
      case BidNetworkFilter.open:
        return 'Open';
      case BidNetworkFilter.closed:
        return 'Closed';
    }
  }

  bool matches(BidRequestStatus s) {
    switch (this) {
      case BidNetworkFilter.all:
        return true;
      case BidNetworkFilter.draft:
        return s == BidRequestStatus.draft;
      case BidNetworkFilter.open:
        return s == BidRequestStatus.open;
      case BidNetworkFilter.closed:
        return s == BidRequestStatus.closed;
    }
  }
}

enum InvitationStatus { pending, viewed, responded, declined }

extension InvitationStatusX on InvitationStatus {
  String get label => name.toUpperCase();
}

enum BidDetailTab { overview, invitations, responses, qa }

extension BidDetailTabX on BidDetailTab {
  String get label {
    switch (this) {
      case BidDetailTab.overview:
        return 'Overview';
      case BidDetailTab.invitations:
        return 'Invitations';
      case BidDetailTab.responses:
        return 'Responses';
      case BidDetailTab.qa:
        return 'Q&A';
    }
  }
}

class BidInvitationModel {
  final String subcontractor;
  final InvitationStatus status;
  final DateTime invitedAt;
  final DateTime? viewedAt;
  final DateTime? respondedAt;

  const BidInvitationModel({
    required this.subcontractor,
    required this.status,
    required this.invitedAt,
    this.viewedAt,
    this.respondedAt,
  });
}

class BidResponseModel {
  final String subcontractor;
  final double amount;
  final DateTime submittedAt;
  final String? note;

  const BidResponseModel({
    required this.subcontractor,
    required this.amount,
    required this.submittedAt,
    this.note,
  });
}

class BidQuestionModel {
  final String askedBy;
  final String question;
  final DateTime askedAt;
  final String? answer;

  const BidQuestionModel({
    required this.askedBy,
    required this.question,
    required this.askedAt,
    this.answer,
  });
}

class BidRequestModel {
  final String id;
  final String title;
  final String organization;
  final String description;
  final String scopeOfWork;
  final List<String> trades;
  final BidRequestStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? projectStart;
  final String address;
  final String city;
  final String state;
  final double? budgetMin;
  final double? budgetMax;
  final bool showBudget;
  final bool requiresBonding;
  final bool requiresInsurance;
  final String specialRequirements;
  final int views;
  final List<BidInvitationModel> invitations;
  final List<BidResponseModel> responses;
  final List<BidQuestionModel> questions;

  const BidRequestModel({
    required this.id,
    required this.title,
    required this.organization,
    this.description = '',
    this.scopeOfWork = '',
    this.trades = const [],
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.projectStart,
    this.address = '',
    this.city = '',
    this.state = '',
    this.budgetMin,
    this.budgetMax,
    this.showBudget = true,
    this.requiresBonding = false,
    this.requiresInsurance = false,
    this.specialRequirements = '',
    this.views = 0,
    this.invitations = const [],
    this.responses = const [],
    this.questions = const [],
  });

  int get invitedCount => invitations.length;
  int get responseCount => responses.length;

  String get locationLabel =>
      [address, city, state].where((s) => s.trim().isNotEmpty).join(', ');

  BidRequestModel copyWith({BidRequestStatus? status}) => BidRequestModel(
        id: id,
        title: title,
        organization: organization,
        description: description,
        scopeOfWork: scopeOfWork,
        trades: trades,
        status: status ?? this.status,
        createdAt: createdAt,
        dueDate: dueDate,
        projectStart: projectStart,
        address: address,
        city: city,
        state: state,
        budgetMin: budgetMin,
        budgetMax: budgetMax,
        showBudget: showBudget,
        requiresBonding: requiresBonding,
        requiresInsurance: requiresInsurance,
        specialRequirements: specialRequirements,
        views: views,
        invitations: invitations,
        responses: responses,
        questions: questions,
      );
}

class BidNetworkSettingsModel {
  final bool networkParticipation;
  final bool canSendBidRequests;
  final bool canReceiveBidInvites;
  final bool emailNotifications;
  final bool inAppNotifications;

  const BidNetworkSettingsModel({
    this.networkParticipation = true,
    this.canSendBidRequests = true,
    this.canReceiveBidInvites = true,
    this.emailNotifications = true,
    this.inAppNotifications = true,
  });

  BidNetworkSettingsModel copyWith({
    bool? networkParticipation,
    bool? canSendBidRequests,
    bool? canReceiveBidInvites,
    bool? emailNotifications,
    bool? inAppNotifications,
  }) =>
      BidNetworkSettingsModel(
        networkParticipation: networkParticipation ?? this.networkParticipation,
        canSendBidRequests: canSendBidRequests ?? this.canSendBidRequests,
        canReceiveBidInvites: canReceiveBidInvites ?? this.canReceiveBidInvites,
        emailNotifications: emailNotifications ?? this.emailNotifications,
        inAppNotifications: inAppNotifications ?? this.inAppNotifications,
      );
}

/// Trade categories shown in the multi-select picker (from the Figma
/// "scrollable-list" frame, in the same order).
const List<String> kBidTrades = [
  'Acoustical Ceilings',
  'Asphalt Paving',
  'Cabinetry',
  'Carpentry & Framing',
  'Cast-In-Place Concrete',
  'Caulking/Waterproofing',
  'Communications/IT',
  'Concrete',
  'Concrete Paving',
  'Countertops',
  'Curb & Gutter',
  'Decking',
  'Demolitions',
  'Drywall',
  'Drywall Systems',
  'Earthwork & Site Work',
  'Electrical',
  'Doors/Hardware',
  'Electrical Underground',
  'Environmental Remediation',
  'Erosion Control',
  'Fencing',
  'Painting',
  'Fencing & Gates',
  'Fire Protection',
  'Fire-Protection Systems',
  'Flooring',
  'Flooring-Carpet',
  'Glazing Systems',
  'Gutters',
  'HVAC Systems',
  'Landscaping',
  'Low Voltage',
];
