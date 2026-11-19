import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'production_card.dart';
import 'production_palette.dart';

/// One bold lead-in + body line inside [ProductionInfoCard].
class ProductionInfoItem {
  final String title;
  final String body;

  /// Benchmarks tab renders "For Estimating: text" inline; the analytics
  /// tab stacks the title above the body.
  final bool inline;

  const ProductionInfoItem({
    required this.title,
    required this.body,
    this.inline = false,
  });
}

/// Divider-separated help card ("How to use Production Rates",
/// "Understanding Cost Analytics").
class ProductionInfoCard extends StatelessWidget {
  final List<ProductionInfoItem> items;

  const ProductionInfoCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ProductionCard(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: ProductionPalette.divider),
              ),
            SizedBox(
              width: double.infinity,
              child: items[i].inline ? _inline(items[i]) : _stacked(items[i]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _inline(ProductionInfoItem item) => Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${item.title}: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: ProductionPalette.ink,
                fontSize: 11,
              ),
            ),
            TextSpan(
              text: item.body,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 11, height: 1.5),
      );

  Widget _stacked(ProductionInfoItem item) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ProductionPalette.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.body,
            style: TextStyle(fontSize: 11, height: 1.5, color: AppColors.textMuted),
          ),
        ],
      );
}
