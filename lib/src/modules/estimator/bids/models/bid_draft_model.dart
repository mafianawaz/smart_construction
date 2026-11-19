import 'bid_model.dart';
import 'create_bid_enums.dart';
import 'scope_item_model.dart';

/// Snapshot of everything collected across the wizard. Built once, at
/// submit time, from [CreateBidLogic]'s controllers — this is the shape
/// the real "create bid" POST will eventually send.
class BidDraftModel {
  final BidEntryMethod entryMethod;
  final String? uploadedFileName;
  final List<ScopeItemModel> scopeItems;

  final String bidName;
  final DateTime? bidDate;

  final String? crmContactOrg;
  final String? crmOrgStatus;

  final String orgName;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final double? estimatedAmount;

  final String address;
  final String city;
  final String state;
  final String locationNotes;
  final String textToTextKeywords;

  const BidDraftModel({
    required this.entryMethod,
    this.uploadedFileName,
    this.scopeItems = const [],
    required this.bidName,
    this.bidDate,
    this.crmContactOrg,
    this.crmOrgStatus,
    required this.orgName,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    this.estimatedAmount,
    required this.address,
    required this.city,
    required this.state,
    this.locationNotes = '',
    this.textToTextKeywords = '',
  });

  List<ScopeItemModel> get includedItems =>
      scopeItems.where((i) => i.isIncluded).toList();

  /// Turns the draft into the card/list model the Bids board shows.
  /// New bids always start as drafts.
  BidModel toBid(String id) {
    final place = [city, state].where((s) => s.isNotEmpty).join(', ');
    return BidModel(
      id: id,
      number: id.replaceAll(RegExp(r'\D'), '').padRight(6, '0').substring(0, 6),
      title: bidName,
      clientName: orgName,
      status: BidStatus.draft,
      amount: estimatedAmount,
      dueDate: bidDate,
      location: place.isEmpty ? null : place,
      scopeOfWork: includedItems.map((i) => i.description).join('\n'),
      additionalDescription: locationNotes,
    );
  }
}
