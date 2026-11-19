import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_color.dart';
import '../models/marketplace_models.dart';
import 'marketplace_primitives.dart';

final _dateFmt = DateFormat('yyyy-MM-dd');

class ContractorCard extends StatelessWidget {
  final ContractorModel contractor;
  final VoidCallback onConnect;
  const ContractorCard({
    super.key,
    required this.contractor,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final c = contractor;
    return MarketplaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(c.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              MarketplaceTag(c.type),
            ],
          ),
          const SizedBox(height: 2),
          Text(c.code,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryOrange)),
          const SizedBox(height: 8),
          Text(c.description,
              style: TextStyle(
                  fontSize: 11.5, height: 1.4, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_border,
                  size: 15, color: MarketplacePalette.star),
              const SizedBox(width: 4),
              Text(c.rating.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
              Text('(${c.reviewCount} reviews)',
                  style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
              const Spacer(),
              InlineActionLink('Connect', onTap: onConnect),
            ],
          ),
        ],
      ),
    );
  }
}

class TalentCard extends StatelessWidget {
  final TalentModel talent;
  final VoidCallback onTap;
  final VoidCallback onRecruit;
  const TalentCard({
    super.key,
    required this.talent,
    required this.onTap,
    required this.onRecruit,
  });

  @override
  Widget build(BuildContext context) {
    final t = talent;
    return MarketplaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.name,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(t.available ? 'Available' : 'Unavailable',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: t.available
                                ? AppColors.primaryOrange
                                : AppColors.textMuted)),
                  ],
                ),
              ),
              MarketplaceTag(t.trade.toUpperCase()),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.bio,
              style: TextStyle(
                  fontSize: 11.5, height: 1.4, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          InlineActionLink('Recruit', onTap: onRecruit),
        ],
      ),
    );
  }
}

class CrewCard extends StatelessWidget {
  final CrewModel crew;
  const CrewCard({super.key, required this.crew});

  @override
  Widget build(BuildContext context) {
    final c = crew;
    return MarketplaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(c.available ? 'Available' : 'Unavailable',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: c.available
                                ? AppColors.primaryOrange
                                : AppColors.textMuted)),
                  ],
                ),
              ),
              MarketplaceTag(c.trade.toUpperCase()),
            ],
          ),
          const SizedBox(height: 8),
          Text(c.summary,
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
          for (final n in c.notes)
            Text(n,
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class EquipmentBrowseCard extends StatelessWidget {
  final EquipmentModel item;
  const EquipmentBrowseCard({super.key, required this.item});

  String _money(double v) => NumberFormat('#,##0').format(v);

  @override
  Widget build(BuildContext context) {
    final e = item;
    return MarketplaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(e.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              MarketplaceTag(e.condition),
            ],
          ),
          const SizedBox(height: 2),
          Text(e.makeModelYear,
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '\$${_money(e.dailyRate)}/day',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryOrange)),
            TextSpan(
                text: '  \$${_money(e.weeklyRate)}/wk  \$${_money(e.monthlyRate)}/mon',
                style: const TextStyle(fontSize: 11.5)),
          ])),
          const SizedBox(height: 6),
          Text('Availability: ${e.ongoing ? 'Ongoing' : 'Fixed dates'}',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const Divider(height: 18),
          Text(e.ownerOrg,
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class MyListingTile extends StatelessWidget {
  final EquipmentModel item;
  final VoidCallback onTap;
  const MyListingTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final e = item;
    return MarketplaceCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Other ${e.make} ${e.model}'.trim(),
                    style:
                        TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                const SizedBox(height: 8),
                Text('\$${NumberFormat('#,##0').format(e.dailyRate)}/day',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: e.isActive
                      ? AppColors.primaryOrange
                      : MarketplacePalette.tagBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(e.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: e.isActive ? Colors.white : Colors.black54)),
              ),
              const SizedBox(height: 14),
              Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class RequestStatusTag extends StatelessWidget {
  final RentalRequestStatus status;
  const RequestStatusTag(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    late Color bg, fg;
    switch (status) {
      case RentalRequestStatus.pending:
        bg = MarketplacePalette.pendingBg;
        fg = MarketplacePalette.pendingText;
        break;
      case RentalRequestStatus.approved:
        bg = MarketplacePalette.approvedBg;
        fg = MarketplacePalette.approvedText;
        break;
      case RentalRequestStatus.declined:
        bg = MarketplacePalette.declinedBg;
        fg = MarketplacePalette.declinedText;
        break;
    }
    return MarketplaceTag(status.label, background: bg, foreground: fg);
  }
}

class RentalRequestTile extends StatelessWidget {
  final RentalRequestModel request;

  /// Shown only for the owner while the request is pending.
  final VoidCallback? onRespond;
  const RentalRequestTile({super.key, required this.request, this.onRespond});

  @override
  Widget build(BuildContext context) {
    final r = request;
    final small = TextStyle(fontSize: 10.5, color: AppColors.textMuted);
    return MarketplaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(r.requesterOrg,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
              RequestStatusTag(r.status),
            ],
          ),
          const SizedBox(height: 8),
          Text('${_dateFmt.format(r.start)} — ${_dateFmt.format(r.end)}',
              style: small),
          if (r.deliveryRequested) Text('• Delivery requested', style: small),
          if (r.note.isNotEmpty) Text('"${r.note}"', style: small),
          if (onRespond != null && r.status == RentalRequestStatus.pending) ...[
            const Divider(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onRespond,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryOrange,
                  side: BorderSide(color: AppColors.primaryOrange),
                  minimumSize: const Size(72, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Text('Respond', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
