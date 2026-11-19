enum MarketplaceTab { contractor, talentPool, crews, equipmentRentals }

extension MarketplaceTabX on MarketplaceTab {
  String get label {
    switch (this) {
      case MarketplaceTab.contractor:
        return 'Contractor';
      case MarketplaceTab.talentPool:
        return 'Talent pool';
      case MarketplaceTab.crews:
        return 'Crews';
      case MarketplaceTab.equipmentRentals:
        return 'Equipment Rentals';
    }
  }

  String get banner {
    switch (this) {
      case MarketplaceTab.contractor:
        return 'Browse and connect with verified subcontractors and specialty contractors in your area.';
      case MarketplaceTab.talentPool:
        return 'Discover skilled workers and subcontractors in your network.';
      case MarketplaceTab.crews:
        return 'Browse and list availability crew for hire by trade, location and availability';
      case MarketplaceTab.equipmentRentals:
        return 'Rent or list construction equipment — excavators, lifts, compressors, scaffolding & more';
    }
  }
}

enum EquipmentSubTab { browse, myListing, myRequest }

extension EquipmentSubTabX on EquipmentSubTab {
  String get label {
    switch (this) {
      case EquipmentSubTab.browse:
        return 'Browse';
      case EquipmentSubTab.myListing:
        return 'My Listing';
      case EquipmentSubTab.myRequest:
        return 'My Request';
    }
  }
}

enum RentalRequestStatus { pending, approved, declined }

extension RentalRequestStatusX on RentalRequestStatus {
  String get label {
    switch (this) {
      case RentalRequestStatus.pending:
        return 'Pending';
      case RentalRequestStatus.approved:
        return 'Approved';
      case RentalRequestStatus.declined:
        return 'Declined';
    }
  }
}

class ContractorModel {
  final String id;
  final String name;
  final String code; // e.g. M1
  final String type; // GENERAL CONTRACTOR
  final String trade;
  final String location;
  final String description;
  final double rating;
  final int reviewCount;

  const ContractorModel({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.trade,
    required this.location,
    required this.description,
    required this.rating,
    required this.reviewCount,
  });
}

class TalentModel {
  final String id;
  final String name;
  final String trade; // CONCRETE
  final bool available;
  final String headline; // Best Concrete Pourer
  final String bio;
  final double rateMin;
  final double rateMax;
  final String email;
  final String location;
  final List<String> skills;
  final List<String> certifications;
  final double rating;
  final DateTime addedAt;

  const TalentModel({
    required this.id,
    required this.name,
    required this.trade,
    required this.available,
    required this.headline,
    required this.bio,
    required this.rateMin,
    required this.rateMax,
    required this.email,
    required this.location,
    required this.skills,
    required this.certifications,
    required this.rating,
    required this.addedAt,
  });

  String get rateLabel =>
      '\$${rateMin.toStringAsFixed(0)} - \$${rateMax.toStringAsFixed(0)} / hour';
}

class CrewModel {
  final String id;
  final String name;
  final String trade; // FRAMING AND GATES
  final bool available;
  final int workers;
  final double hourlyRate;
  final String location;
  final List<String> notes;

  const CrewModel({
    required this.id,
    required this.name,
    required this.trade,
    required this.available,
    required this.workers,
    required this.hourlyRate,
    required this.location,
    this.notes = const [],
  });

  String get summary =>
      '$workers workers · \$${hourlyRate.toStringAsFixed(0)}/hr';
}

class EquipmentModel {
  final String id;
  final String name;
  final String make;
  final String model;
  final String year;
  final String category;
  final String condition;
  final double dailyRate;
  final double weeklyRate;
  final double monthlyRate;
  final double deposit;
  final String location;
  final String deliveryRadius;
  final List<String> photoUrls;
  final bool ongoing;
  final String description;
  final String ownerOrg;
  final bool isActive;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.make,
    required this.model,
    required this.year,
    required this.category,
    required this.condition,
    required this.dailyRate,
    required this.weeklyRate,
    required this.monthlyRate,
    required this.deposit,
    required this.location,
    required this.deliveryRadius,
    required this.photoUrls,
    required this.ongoing,
    required this.description,
    required this.ownerOrg,
    this.isActive = true,
  });

  String get makeModelYear => [make, model, year]
      .where((e) => e.trim().isNotEmpty)
      .join(' ')
      .trim();

  EquipmentModel copyWith({
    String? name,
    String? make,
    String? model,
    String? year,
    String? category,
    String? condition,
    double? dailyRate,
    double? weeklyRate,
    double? monthlyRate,
    double? deposit,
    String? location,
    String? deliveryRadius,
    List<String>? photoUrls,
    bool? ongoing,
    String? description,
    String? ownerOrg,
    bool? isActive,
  }) {
    return EquipmentModel(
      id: id,
      name: name ?? this.name,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      dailyRate: dailyRate ?? this.dailyRate,
      weeklyRate: weeklyRate ?? this.weeklyRate,
      monthlyRate: monthlyRate ?? this.monthlyRate,
      deposit: deposit ?? this.deposit,
      location: location ?? this.location,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      photoUrls: photoUrls ?? this.photoUrls,
      ongoing: ongoing ?? this.ongoing,
      description: description ?? this.description,
      ownerOrg: ownerOrg ?? this.ownerOrg,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// A rental request. Owners see requests against their listings
/// ("Incoming Requests"); renters see their own under "My Request".
class RentalRequestModel {
  final String id;
  final String equipmentId;
  final String requesterOrg;
  final DateTime start;
  final DateTime end;
  final bool deliveryRequested;
  final String note;
  final RentalRequestStatus status;

  /// True when the current user is the renter (shows under My Request).
  final bool isMine;

  const RentalRequestModel({
    required this.id,
    required this.equipmentId,
    required this.requesterOrg,
    required this.start,
    required this.end,
    required this.deliveryRequested,
    required this.note,
    required this.status,
    this.isMine = false,
  });

  RentalRequestModel copyWith({RentalRequestStatus? status}) {
    return RentalRequestModel(
      id: id,
      equipmentId: equipmentId,
      requesterOrg: requesterOrg,
      start: start,
      end: end,
      deliveryRequested: deliveryRequested,
      note: note,
      status: status ?? this.status,
      isMine: isMine,
    );
  }
}

class JobOption {
  final String id;
  final String title;
  const JobOption(this.id, this.title);
}

/// Result of "Add to Pipeline" on the Recruit screen.
class PipelineCandidate {
  final String talentId;
  final String talentName;
  final String? jobId;
  const PipelineCandidate({
    required this.talentId,
    required this.talentName,
    this.jobId,
  });
}
