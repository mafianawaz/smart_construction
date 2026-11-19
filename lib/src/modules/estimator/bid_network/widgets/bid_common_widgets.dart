import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/bid_network_models.dart';

// Local status colors (AppColors.success/warning are unconfirmed — see notes).
const Color kBidGreen = Color(0xFF16A34A);
const Color kBidAmber = Color(0xFFD97706);
const Color kBidGrey = Color(0xFF6B7280);
const Color kBidBorder = Color(0xFFE5E7EB);

/// Back button + centered title (+ optional trailing widget).
class BidNetworkAppBar extends StatelessWidget {
  const BidNetworkAppBar({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            width: 64,
            child: Align(alignment: Alignment.centerRight, child: trailing),
          ),
        ],
      ),
    );
  }
}

/// White rounded card with a hairline border.
class BidCard extends StatelessWidget {
  const BidCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBidBorder),
      ),
      child: child,
    );
  }
}

class BidStatusPill extends StatelessWidget {
  const BidStatusPill({super.key, required this.status});

  final BidRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BidRequestStatus.open => kBidGreen,
      BidRequestStatus.closed => kBidAmber,
      BidRequestStatus.draft => kBidGrey,
    };
    final icon = switch (status) {
      BidRequestStatus.open => Icons.circle,
      BidRequestStatus.closed => Icons.access_time,
      BidRequestStatus.draft => Icons.edit_outlined,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: status == BidRequestStatus.open ? 6 : 10, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

/// Small uppercase trade tag.
class BidTradeTag extends StatelessWidget {
  const BidTradeTag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500,letterSpacing: 0.4),
      ),
    );
  }
}

/// Label + switch row used in Create Bid Request and Settings.
class BidSwitchRow extends StatelessWidget {
  const BidSwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryOrange,
          ),
        ],
      ),
    );
  }
}

/// Icon + message panel used for empty Responses / Q&A tabs.
class BidEmptyPanel extends StatelessWidget {
  const BidEmptyPanel({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return BidCard(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
