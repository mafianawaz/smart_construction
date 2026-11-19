import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

import '../logic/create_bid_wizard.dart';
import '../models/create_bid_enums.dart';

/// The dropdown that opens from the orange "+" on the Bids header
/// (Figma "Frame 6"): dimmed screen, white card anchored under the
/// button with the two ways to start a bid.
class NewBidMenu {
  NewBidMenu._();

  /// [anchorContext] must be the context of the "+" button itself
  /// (wrap it in a `Builder`) so the card can be positioned under it.
  static Future<void> show(BuildContext anchorContext) {
    final box = anchorContext.findRenderObject() as RenderBox;
    final origin = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenWidth = MediaQuery.of(anchorContext).size.width;

    return showGeneralDialog(
      context: anchorContext,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (ctx, _, __) {
        return Stack(
          children: [
            Positioned(
              top: origin.dy + size.height + 6,
              right: screenWidth - (origin.dx + size.width),
              width: (screenWidth - 32).clamp(0, 280).toDouble(),
              child: Material(
                color: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Option(
                      icon: AppIcons.ai,
                      title: 'AI-Enhanced Bid Wizard',
                      subtitle: 'AI analyzes documents & extracts scope',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        CreateBidWizard.start(CreateBidFlow.ai);
                      },
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    _Option(
                      icon: AppIcons.manual,
                      title: 'Manual Bid Entry',
                      subtitle: 'Enter bid details directly without documents',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        CreateBidWizard.start(CreateBidFlow.manual);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Option extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle
              ),
              child: SvgPicture.asset(icon, height: 18, color: AppColors.primaryOrange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
