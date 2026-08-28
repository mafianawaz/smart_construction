import 'package:flutter/material.dart';

// class RoleSummaryCard extends StatelessWidget {
//   const RoleSummaryCard({
//     super.key,
//     required this.title,
//     required this.items,
//     this.columns = 3,
//     this.height,
//     this.margin,
//     this.padding,
//   });
//
//   final String title;
//   final List<RoleSummaryItem> items;
//   final int columns;
//
//   /// Optional fixed height.
//   /// If null, height is calculated from the content.
//   final double? height;
//
//   final EdgeInsetsGeometry? margin;
//   final EdgeInsetsGeometry? padding;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: margin,
//       width: double.infinity,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Container(
//           height: height,
//           decoration: const BoxDecoration(
//             color: Color(0xFFF68A2F),
//           ),
//           child: Stack(
//             children: [
//               // ----------------------------------------------------------
//               // DARK CIRCLE / GLOW IN TOP-RIGHT CORNER
//               // ----------------------------------------------------------
//               Positioned(
//                 top: -72,
//                 right: -55,
//                 child: Container(
//                   width: 190,
//                   height: 190,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color(0xFFE77928).withOpacity(0.42),
//                   ),
//                 ),
//               ),
//
//               // ----------------------------------------------------------
//               // SMALL DECORATIVE DOT
//               // ----------------------------------------------------------
//               Positioned(
//                 top: 65,
//                 left: 142,
//                 child: Container(
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color(0xFFFFB15F).withOpacity(0.75),
//                   ),
//                 ),
//               ),
//
//               // ----------------------------------------------------------
//               // CONTENT
//               // ----------------------------------------------------------
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _RoleTitlePill(title: title),
//
//                     const SizedBox(height: 34),
//
//                     LayoutBuilder(
//                       builder: (context, constraints) {
//                         final spacing = columns == 3 ? 13.0 : 12.0;
//
//                         final itemWidth =
//                             (constraints.maxWidth -
//                                 (spacing * (columns - 1))) /
//                                 columns;
//
//                         return Row(
//                           spacing: spacing,
//                           children: items.map((item) {
//                             return Expanded(child: _RoleStatCard(item: item));
//                           }).toList(),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // ============================================================================
// // TITLE PILL
// // ============================================================================
// class _RoleTitlePill extends StatelessWidget {
//   const _RoleTitlePill({
//     required this.title,
//   });
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 15,
//         vertical: 8,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.13),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.25),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 1.8,
//         ),
//       ),
//     );
//   }
// }
// // ============================================================================
// // STAT CARD
// // ============================================================================
// class _RoleStatCard extends StatelessWidget {
//   const _RoleStatCard({
//     required this.item,
//   });
//
//   final RoleSummaryItem item;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9A154).withOpacity(0.72),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.16),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             item.value,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 25,
//               fontWeight: FontWeight.w600,
//               height: 1,
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           Text(
//             item.label,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.65),
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               height: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // ============================================================================
// // DATA MODEL
// // ============================================================================
// class RoleSummaryItem {
//   const RoleSummaryItem({
//     required this.value,
//     required this.label,
//   });
//
//   final String value;
//   final String label;
// }

import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import 'decorative_circle.dart';

class RoleSummaryCard extends StatelessWidget {
  const RoleSummaryCard({
    super.key,
    required this.title,
    required this.items,
    this.columns = 3,
    this.rowCount = 1,
    this.height,
    this.margin,
    this.padding,
    this.backgroundColor = const Color(0xFFF68A2F),
    this.circleColor = const Color(0xFFE77928),
  });

  final String title;

  /// All stat items.
  ///
  /// Example:
  /// [
  ///   RoleSummaryItem(value: '10', label: 'Projects'),
  ///   RoleSummaryItem(value: '20', label: 'Tasks'),
  ///   RoleSummaryItem(value: '5', label: 'Messages'),
  /// ]
  final List<RoleSummaryItem> items;

  /// Maximum number of cards in one row.
  final int columns;

  /// Number of rows to display.
  ///
  /// 1 = one row
  /// 2 = two rows
  /// 3 = three rows
  final int rowCount;

  /// Optional fixed height.
  ///
  /// If null, height is calculated automatically.
  final double? height;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final Color backgroundColor;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    assert(columns > 0, 'columns must be greater than 0');
    assert(rowCount > 0, 'rowCount must be greater than 0');

    final rows = _buildRows();

    return Container(
      margin: margin,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Stack(
            children: [
              // ============================================================
              // DECORATIVE CIRCLE
              // ============================================================
              Positioned(
                top: -72,
                right: -55,
                child: IgnorePointer(
                  child: DecorativeCircle(
                    diameter: 190,
                    alignment: Alignment.center,
                    color: circleColor.withOpacity(0.42),
                  ),
                ),
              ),

              // ============================================================
              // SMALL DOT
              // ============================================================
              Positioned(
                top: 65,
                left: 142,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.30),
                  ),
                ),
              ),

              // ============================================================
              // CONTENT
              // ============================================================
              Padding(
                padding: padding ?? const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RoleTitlePill(title: title),

                    const SizedBox(height: 34),

                    ...List.generate(
                      rows.length,
                          (rowIndex) {
                        final row = rows[rowIndex];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: rowIndex == rows.length - 1 ? 0 : 12,
                          ),
                          child: _StatRow(
                            items: row,
                            columns: columns,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<List<RoleSummaryItem>> _buildRows() {
    if (items.isEmpty) {
      return [];
    }

    // If only one row is required, keep the original behavior.
    if (rowCount == 1) {
      return [items.take(columns).toList()];
    }

    final result = <List<RoleSummaryItem>>[];

    final actualRowCount = rowCount.clamp(1, items.length);

    // Distribute items as evenly as possible.
    final itemsPerRow = (items.length / actualRowCount).ceil();

    for (int i = 0; i < items.length; i += itemsPerRow) {
      final end = (i + itemsPerRow).clamp(0, items.length);

      result.add(
        items.sublist(i, end > items.length ? items.length : end),
      );

      if (result.length == actualRowCount) {
        break;
      }
    }

    return result;
  }
}

// ============================================================================
// STAT ROW
// ============================================================================

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.items,
    required this.columns,
  });

  final List<RoleSummaryItem> items;
  final int columns;

  @override
  Widget build(BuildContext context) {
    const spacing = 9.0;

    return Row(
      children: List.generate(
        items.length,
            (index) {
          final item = items[index];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == items.length - 1 ? 0 : spacing,
              ),
              child: _RoleStatCard(item: item),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// TITLE PILL
// ============================================================================

class _RoleTitlePill extends StatelessWidget {
  const _RoleTitlePill({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}

// ============================================================================
// STAT CARD
// ============================================================================

class _RoleStatCard extends StatelessWidget {
  const _RoleStatCard({
    required this.item,
  });

  final RoleSummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 13,),
      decoration: BoxDecoration(
        color: AppColors.accentPeach.withOpacity(0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DATA MODEL
// ============================================================================

class RoleSummaryItem {
  const RoleSummaryItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

