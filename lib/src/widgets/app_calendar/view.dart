import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import 'logic.dart';




// enum CalendarVariant { compact, full }
//
// const Color _kHeaderColor = Color(0xFF232D42);
// const Color _kWeekdayBg = Color(0xFFF6F7F9);
// const Color _kWeekdayDivider = Color(0xFFE8E9ED);
// const Color _kWeekdayLabelColor = Color(0xFFA6A9B4);
// const Color _kCardBorderColor = Color(0xFFEEEEF1);
//
// class AppCalendar extends StatefulWidget {
//   /// Stable tag for this calendar's controller. Required if you want to
//   /// `Get.find` it from elsewhere; otherwise a unique tag is generated for
//   /// you automatically.
//   final String? tag;
//
//   /// Month initially shown. Defaults to the current month.
//   final DateTime? initialMonth;
//
//   /// Currently selected date (controlled). Pass null for no selection.
//   final DateTime? selectedDate;
//
//   final ValueChanged<DateTime>? onDateSelected;
//
//   /// Fired whenever the visible month changes (swipe or arrow tap) — use
//   /// this to fetch/refresh indicator data for the new month.
//   final ValueChanged<DateTime>? onMonthChanged;
//
//   /// Return the dot colors to render under [day]. Return an empty list
//   /// (or leave the builder null) for days with nothing to show.
//   final List<Color> Function(DateTime day)? dayIndicatorsBuilder;
//
//   /// Legend entries rendered below the card. Any length — 0 to n.
//   final List<CalendarLegendItem> legends;
//
//   final bool showLegend;
//   final bool showHeader;
//   final bool showWeekdayLabels;
//   final CalendarVariant variant;
//
//   final Color selectedColor;
//   final Color todayBorderColor;
//
//   /// Max dots drawn per day before truncating (keeps small cells tidy).
//   final int maxIndicatorsPerDay;
//
//   /// DateTime.monday .. DateTime.sunday — which weekday starts each row.
//   final int startWeekday;
//
//   final EdgeInsets padding;
//   final Color? backgroundColor;
//   final BorderRadiusGeometry borderRadius;
//   final List<BoxShadow>? boxShadow;
//   final BoxBorder? cardBorder;
//
//   /// Whether tapping a leading/trailing (other-month) day is allowed.
//   final bool allowSelectOutsideMonth;
//
//   /// If false, the controller is kept alive (not deleted) when this widget
//   /// is disposed — useful if you navigate away and back and want the
//   /// calendar to remember its month/selection. Requires a stable [tag].
//   final bool autoDisposeController;
//
//   const AppCalendar({
//     super.key,
//     this.tag,
//     this.initialMonth,
//     this.selectedDate,
//     this.onDateSelected,
//     this.onMonthChanged,
//     this.dayIndicatorsBuilder,
//     this.legends = const [],
//     this.showLegend = true,
//     this.showHeader = true,
//     this.showWeekdayLabels = true,
//     this.variant = CalendarVariant.full,
//     this.selectedColor = const Color(0xFFF2703C),
//     this.todayBorderColor = const Color(0xFFF2703C),
//     this.maxIndicatorsPerDay = 4,
//     this.startWeekday = DateTime.sunday,
//     this.padding = const EdgeInsets.all(16),
//     this.backgroundColor,
//     this.borderRadius = const BorderRadius.all(Radius.circular(20)),
//     this.boxShadow,
//     this.cardBorder,
//     this.allowSelectOutsideMonth = true,
//     this.autoDisposeController = true,
//   });
//
//   @override
//   State<AppCalendar> createState() => _AppCalendarState();
// }
//
// class _AppCalendarState extends State<AppCalendar> {
//   late final String _tag;
//   late final CalendarController _controller;
//
//   static const List<String> _weekdayLabelsMondayStart = [
//     'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN',
//   ];
//   static const List<String> _monthNames = [
//     'January', 'February', 'March', 'April', 'May', 'June',
//     'July', 'August', 'September', 'October', 'November', 'December',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _tag = widget.tag ?? 'app_calendar_${identityHashCode(this)}';
//     _controller = Get.put(
//       CalendarController(
//         initialMonth: widget.initialMonth,
//         initialSelectedDate: widget.selectedDate,
//         onDateSelected: widget.onDateSelected,
//         onMonthChanged: widget.onMonthChanged,
//       ),
//       tag: _tag,
//       permanent: !widget.autoDisposeController,
//     );
//   }
//
//   @override
//   void didUpdateWidget(covariant AppCalendar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Keep callbacks fresh (e.g. closures capturing new build context).
//     _controller.onDateSelected = widget.onDateSelected;
//     _controller.onMonthChanged = widget.onMonthChanged;
//
//     if (widget.selectedDate != oldWidget.selectedDate) {
//       _controller.syncSelectedDate(widget.selectedDate);
//     }
//     if (widget.initialMonth != null &&
//         (oldWidget.initialMonth == null ||
//             widget.initialMonth!.year != oldWidget.initialMonth!.year ||
//             widget.initialMonth!.month != oldWidget.initialMonth!.month)) {
//       _controller.syncMonth(widget.initialMonth);
//     }
//   }
//
//   @override
//   void dispose() {
//     if (widget.autoDisposeController) {
//       Get.delete<CalendarController>(tag: _tag);
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isCompact = widget.variant == CalendarVariant.compact;
//
//     return LayoutBuilder(
//       builder: (context, outerConstraints) {
//         final availableWidth =
//             outerConstraints.maxWidth - widget.padding.horizontal;
//         final rawCell = availableWidth / 7;
//         final cellSize =
//         (isCompact ? rawCell.clamp(18.0, 25.0) : rawCell.clamp(22.0, 28.0))
//             .toDouble();
//         final rowHeight = cellSize + 18;
//         final gridHeight = rowHeight * 6;
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ---- the card (header + weekday strip + date grid) ----
//             Container(
//               padding: widget.padding,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (widget.showHeader) ...[
//                     _buildHeader(),
//                     const SizedBox(height: 14),
//                   ],
//                   if (widget.showWeekdayLabels && !isCompact) ...[
//                     _buildWeekdayStrip(),
//                     // const SizedBox(height: 6),
//                   ],
//                   SizedBox(
//                     height: gridHeight,
//                     child: PageView.builder(
//                       controller: _controller.pageController,
//                       onPageChanged: _controller.handlePageChanged,
//                       itemBuilder: (context, page) => Obx(
//                             () => _buildMonthGrid(
//                           _controller.monthForPage(page),
//                           cellSize,
//                           rowHeight,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // ---- legend row: OUTSIDE the card, aligned to its padding ----
//             if (widget.showLegend && widget.legends.isNotEmpty) ...[
//               const SizedBox(height: 16),
//               Padding(
//                 padding: EdgeInsets.only(left: widget.padding.left),
//                 child: CalendarLegendRow(legends: widget.legends),
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _NavButton(icon: Icons.chevron_left, onTap: _controller.previousMonth),
//         Obx(
//               () => AnimatedSwitcher(
//             duration: const Duration(milliseconds: 180),
//             child: Text(
//               '${_monthNames[_controller.focusedMonth.value.month - 1]} '
//                   '${_controller.focusedMonth.value.year}',
//               key: ValueKey(
//                 '${_controller.focusedMonth.value.year}-${_controller.focusedMonth.value.month}',
//               ),
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w800,
//                 color: _kHeaderColor,
//               ),
//             ),
//           ),
//         ),
//         _NavButton(icon: Icons.chevron_right, onTap: _controller.nextMonth),
//       ],
//     );
//   }
//
//   /// Weekday labels sit inside their own soft grey rounded strip with a
//   /// hairline divider under it, visually separating them from the header
//   /// above and the date grid below.
//   Widget _buildWeekdayStrip() {
//     final startIndex = widget.startWeekday - DateTime.monday; // 0..6
//     final labels = List.generate(
//       7,
//           (i) => _weekdayLabelsMondayStart[(startIndex + i) % 7],
//     );
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//         border: Border(
//           bottom: BorderSide(color: _kWeekdayDivider, width: 1),
//         ),
//       ),
//       child: Row(
//         children: [
//           for (final label in labels)
//             Expanded(
//               child: Center(
//                 child: Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.4,
//                     color: _kWeekdayLabelColor,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMonthGrid(DateTime month, double cellSize, double rowHeight) {
//     final firstOfMonth = DateTime(month.year, month.month, 1);
//     final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
//
//     // DateTime.weekday: Monday=1 .. Sunday=7.
//     final leading = (firstOfMonth.weekday - widget.startWeekday + 7) % 7;
//     const totalCells = 42; // Always 6 fixed rows so page height never jumps.
//     final today = DateTime.now();
//     final selected = _controller.selectedDate.value;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           bottomRight: Radius.circular(15),
//           bottomLeft: Radius.circular(15),
//         ),
//         border: Border.all(color: _kCardBorderColor, width: 1),
//         boxShadow: widget.boxShadow ??
//             [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//       ),
//       child: GridView.builder(
//         padding: EdgeInsets.zero,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 7,
//           mainAxisExtent: rowHeight,
//         ),
//         itemCount: totalCells,
//         itemBuilder: (context, index) {
//           final dayOffset = index - leading;
//           final date = DateTime(month.year, month.month, dayOffset + 1);
//           final isCurrentMonth = dayOffset >= 0 && dayOffset < daysInMonth;
//
//           final isSelected = selected != null &&
//               date.year == selected.year &&
//               date.month == selected.month &&
//               date.day == selected.day;
//
//           final isToday = date.year == today.year &&
//               date.month == today.month &&
//               date.day == today.day;
//
//           final indicators =
//               widget.dayIndicatorsBuilder?.call(date) ?? const <Color>[];
//
//           final canTap = widget.onDateSelected != null &&
//               (isCurrentMonth || widget.allowSelectOutsideMonth);
//
//           return Center(
//             child: CalendarDayCell(
//               key: ValueKey(date.toIso8601String()),
//               date: date,
//               isCurrentMonth: isCurrentMonth,
//               isSelected: isSelected,
//               isToday: isToday,
//               indicators: indicators,
//               maxIndicators: widget.maxIndicatorsPerDay,
//               selectedColor: widget.selectedColor,
//               todayBorderColor: widget.todayBorderColor,
//               cellSize: cellSize,
//               onTap: canTap ? () => _controller.selectDate(date) : null,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _NavButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//
//   const _NavButton({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkResponse(
//       onTap: onTap,
//       radius: 20,
//       child: Padding(
//         padding: const EdgeInsets.all(4),
//         child: Icon(icon, size: 22, color: _kHeaderColor),
//       ),
//     );
//   }
// }
//
// class CalendarDayCell extends StatelessWidget {
//   final DateTime date;
//   final bool isCurrentMonth;
//   final bool isSelected;
//   final bool isToday;
//   final List<Color> indicators;
//   final int maxIndicators;
//   final Color selectedColor;
//   final Color todayBorderColor;
//   final double cellSize;
//   final VoidCallback? onTap;
//   final TextStyle? dayTextStyle;
//
//   const CalendarDayCell({
//     super.key,
//     required this.date,
//     required this.isCurrentMonth,
//     required this.isSelected,
//     required this.isToday,
//     required this.indicators,
//     required this.selectedColor,
//     required this.cellSize,
//     this.maxIndicators = 4,
//     this.todayBorderColor = const Color(0xFFF2703C),
//     this.onTap,
//     this.dayTextStyle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final dots = indicators.take(maxIndicators).toList(growable: false);
//
//     final Color numberColor = isSelected
//         ? Colors.white
//         : isCurrentMonth
//         ? (dayTextStyle?.color ?? const Color(0xFF232D42))
//         : const Color(0xFFC9CBD1);
//
//     return Semantics(
//       label: '${date.day}',
//       selected: isSelected,
//       button: onTap != null,
//       child: InkResponse(
//         onTap: onTap,
//         radius: cellSize * 0.7,
//         containedInkWell: true,
//         highlightShape: BoxShape.circle,
//         child: SizedBox(
//           width: cellSize,
//           height: cellSize + 12,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 180),
//                 curve: Curves.easeOut,
//                 width: cellSize,
//                 height: cellSize,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: isSelected ? selectedColor : Colors.transparent,
//                   border: (!isSelected && isToday)
//                       ? Border.all(color: todayBorderColor, width: 1.4)
//                       : null,
//                 ),
//                 child: Text(
//                   '${date.day}',
//                   style: (dayTextStyle ??
//                       const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))
//                       .copyWith(
//                     color: numberColor,
//                     fontWeight: (isSelected || isToday) ? FontWeight.w700 : FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               SizedBox(
//                 height: 6,
//                 child: dots.isEmpty
//                     ? const SizedBox.shrink()
//                     : Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     for (final c in dots)
//                       Container(
//                         width: 4,
//                         height: 4,
//                         margin: const EdgeInsets.symmetric(horizontal: 1),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: isSelected ? Colors.white.withOpacity(0.9) : c,
//                         ),
//                       ),
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
//
//
// /// Renders an arbitrary number of [CalendarLegendItem]s as a wrapping row of
// /// "● Label" chips, matching the legend strip at the bottom of the calendar
// /// mock (Critical / High / Medium / Low). Wraps to a new line automatically
// /// if there isn't enough width, so it scales to however many legends a
// /// screen needs.
// class CalendarLegendRow extends StatelessWidget {
//   final List<CalendarLegendItem> legends;
//   final double dotSize;
//   final double spacing;
//   final TextStyle? labelStyle;
//
//   const CalendarLegendRow({
//     super.key,
//     required this.legends,
//     this.dotSize = 8,
//     this.spacing = 18,
//     this.labelStyle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (legends.isEmpty) return const SizedBox.shrink();
//
//     return Wrap(
//       spacing: spacing,
//       runSpacing: 8,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: [
//         for (final legend in legends)
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: dotSize,
//                 height: dotSize,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: legend.color,
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 legend.label,
//                 style: labelStyle ??
//                     const TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF6B6B70),
//                       fontWeight: FontWeight.w500,
//                     ),
//               ),
//             ],
//           ),
//       ],
//     );
//   }
// }
//
//
// /// A single legend entry rendered under the calendar (e.g. "Critical" / red).
// ///
// /// The calendar widget itself has zero opinion about what colors mean —
// /// every screen that uses [AppCalendar] passes its own `List<CalendarLegendItem>`,
// /// so the same widget can show task priorities on one screen and attendance
// /// status on another.
// @immutable
// class CalendarLegendItem {
//   final String label;
//   final Color color;
//
//   const CalendarLegendItem({
//     required this.label,
//     required this.color,
//   });
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import 'logic.dart';




enum CalendarVariant { compact, full }

/// Visual skin of the calendar card.
///
/// - [classic] (default): the original look - header outside the card, grey
///   3-letter weekday strip, bordered date grid, number-only selection circle.
/// - [board]: one flat white card holding header, single-letter weekday row
///   (Sat/Sun muted) and the grid; round grey nav buttons; and a selection
///   circle that wraps the number *and* its dots. Used by the Dispatch Board.
enum CalendarSkin { classic, board }

const Color _kHeaderColor = Color(0xFF232D42);
const Color _kWeekdayBg = Color(0xFFF6F7F9);
const Color _kWeekdayDivider = Color(0xFFE8E9ED);
const Color _kWeekdayLabelColor = Color(0xFFA6A9B4);
const Color _kCardBorderColor = Color(0xFFEEEEF1);
const Color _kNavButtonBg = Color(0xFFF3F4F6);
const List<BoxShadow> _kBoardShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
];

/// A single, fully reusable, **GetX-driven** calendar widget.
///
/// State (focused month, selected date, page index) lives in a
/// [CalendarController] — the widget itself only builds `Obx` regions that
/// react to that controller. There is no `setState` anywhere in this view.
///
/// Each `AppCalendar` instance manages its own tagged controller instance
/// (via `Get.put(..., tag: tag)` / `Get.delete(tag: tag)`), so dropping
/// several calendars on one screen — a dashboard widget, a Tasks screen
/// calendar, an Attendance screen calendar — just works, each with
/// independent state and independent legends.
///
/// Note: the legend row is rendered **outside** the card (as a sibling
/// below it, aligned to the card's left padding) — not inside the card's
/// padded/decorated box — matching the reference layout.
///
/// Screens supply two things:
/// - [dayIndicatorsBuilder]: given a date, return the dot colors to draw
///   under that day. Each screen decides what those colors mean.
/// - [legends]: the n legend entries rendered below the card.
///
/// ```dart
/// AppCalendar(
///   tag: 'tasks_calendar',
///   selectedDate: selected,
///   onDateSelected: (d) => tasksController.loadDay(d),
///   onMonthChanged: (m) => tasksController.loadMonth(m),
///   dayIndicatorsBuilder: (day) => tasksController.colorsFor(day),
///   legends: const [
///     CalendarLegendItem(label: 'Critical', color: Color(0xFFE53935)),
///     CalendarLegendItem(label: 'High', color: Color(0xFFF2703C)),
///     CalendarLegendItem(label: 'Medium', color: Color(0xFF3E7BFA)),
///     CalendarLegendItem(label: 'Low', color: Color(0xFFA0A0A6)),
///   ],
/// )
/// ```
class AppCalendar extends StatefulWidget {
  /// Stable tag for this calendar's controller. Required if you want to
  /// `Get.find` it from elsewhere; otherwise a unique tag is generated for
  /// you automatically.
  final String? tag;

  /// Month initially shown. Defaults to the current month.
  final DateTime? initialMonth;

  /// Currently selected date (controlled). Pass null for no selection.
  final DateTime? selectedDate;

  final ValueChanged<DateTime>? onDateSelected;

  /// Fired whenever the visible month changes (swipe or arrow tap) — use
  /// this to fetch/refresh indicator data for the new month.
  final ValueChanged<DateTime>? onMonthChanged;

  /// Return the dot colors to render under [day]. Return an empty list
  /// (or leave the builder null) for days with nothing to show.
  final List<Color> Function(DateTime day)? dayIndicatorsBuilder;

  /// Legend entries rendered below the card. Any length — 0 to n.
  final List<CalendarLegendItem> legends;

  final bool showLegend;
  final bool showHeader;
  final bool showWeekdayLabels;
  final CalendarVariant variant;

  final Color selectedColor;
  final Color todayBorderColor;

  /// Max dots drawn per day before truncating (keeps small cells tidy).
  final int maxIndicatorsPerDay;

  /// DateTime.monday .. DateTime.sunday — which weekday starts each row.
  final int startWeekday;

  final EdgeInsets padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? cardBorder;

  /// Whether tapping a leading/trailing (other-month) day is allowed.
  final bool allowSelectOutsideMonth;

  /// If false, the controller is kept alive (not deleted) when this widget
  /// is disposed — useful if you navigate away and back and want the
  /// calendar to remember its month/selection. Requires a stable [tag].
  final bool autoDisposeController;

  /// Visual skin - see [CalendarSkin]. Defaults to the original look, so
  /// existing screens are unaffected.
  final CalendarSkin skin;

  const AppCalendar({
    super.key,
    this.tag,
    this.initialMonth,
    this.selectedDate,
    this.onDateSelected,
    this.onMonthChanged,
    this.dayIndicatorsBuilder,
    this.legends = const [],
    this.showLegend = true,
    this.showHeader = true,
    this.showWeekdayLabels = true,
    this.variant = CalendarVariant.full,
    this.selectedColor = const Color(0xFFF2703C),
    this.todayBorderColor = const Color(0xFFF2703C),
    this.maxIndicatorsPerDay = 4,
    this.startWeekday = DateTime.sunday,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.boxShadow,
    this.cardBorder,
    this.allowSelectOutsideMonth = true,
    this.autoDisposeController = true,
    this.skin = CalendarSkin.classic,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late final String _tag;
  late final CalendarController _controller;

  static const List<String> _weekdayLabelsMondayStart = [
    'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN',
  ];
  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _tag = widget.tag ?? 'app_calendar_${identityHashCode(this)}';
    _controller = Get.put(
      CalendarController(
        initialMonth: widget.initialMonth,
        initialSelectedDate: widget.selectedDate,
        onDateSelected: widget.onDateSelected,
        onMonthChanged: widget.onMonthChanged,
      ),
      tag: _tag,
      permanent: !widget.autoDisposeController,
    );
  }

  @override
  void didUpdateWidget(covariant AppCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep callbacks fresh (e.g. closures capturing new build context).
    _controller.onDateSelected = widget.onDateSelected;
    _controller.onMonthChanged = widget.onMonthChanged;

    if (widget.selectedDate != oldWidget.selectedDate) {
      _controller.syncSelectedDate(widget.selectedDate);
    }
    if (widget.initialMonth != null &&
        (oldWidget.initialMonth == null ||
            widget.initialMonth!.year != oldWidget.initialMonth!.year ||
            widget.initialMonth!.month != oldWidget.initialMonth!.month)) {
      _controller.syncMonth(widget.initialMonth);
    }
  }

  @override
  void dispose() {
    if (widget.autoDisposeController) {
      Get.delete<CalendarController>(tag: _tag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = widget.variant == CalendarVariant.compact;
    final isBoard = widget.skin == CalendarSkin.board;

    return LayoutBuilder(
      builder: (context, outerConstraints) {
        final availableWidth =
            outerConstraints.maxWidth - widget.padding.horizontal;
        final rawCell = availableWidth / 7;
        final cellSize =
        (isCompact ? rawCell.clamp(18.0, 25.0) : rawCell.clamp(22.0, 28.0))
            .toDouble();
        final rowHeight = cellSize + 18;
        final gridHeight = rowHeight * 6;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- the card (header + weekday strip + date grid) ----
            Container(
              padding: widget.padding,
              decoration: isBoard
                  ? BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                borderRadius: widget.borderRadius,
                border: widget.cardBorder ??
                    Border.all(color: _kCardBorderColor, width: 1),
                boxShadow: widget.boxShadow ?? _kBoardShadow,
              )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showHeader) ...[
                    _buildHeader(),
                    const SizedBox(height: 14),
                  ],
                  if (widget.showWeekdayLabels && !isCompact) ...[
                    _buildWeekdayStrip(),
                    // const SizedBox(height: 6),
                  ],
                  SizedBox(
                    height: gridHeight,
                    child: PageView.builder(
                      controller: _controller.pageController,
                      onPageChanged: _controller.handlePageChanged,
                      itemBuilder: (context, page) => Obx(
                            () => _buildMonthGrid(
                          _controller.monthForPage(page),
                          cellSize,
                          rowHeight,
                          rawCell,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ---- legend row: OUTSIDE the card, aligned to its padding ----
            if (widget.showLegend && widget.legends.isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: widget.padding.left),
                child: CalendarLegendRow(legends: widget.legends),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(
          icon: Icons.chevron_left,
          onTap: _controller.previousMonth,
          filled: widget.skin == CalendarSkin.board,
        ),
        Obx(
              () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              '${_monthNames[_controller.focusedMonth.value.month - 1]} '
                  '${_controller.focusedMonth.value.year}',
              key: ValueKey(
                '${_controller.focusedMonth.value.year}-${_controller.focusedMonth.value.month}',
              ),
              style: TextStyle(
                fontSize: widget.skin == CalendarSkin.board ? 16.0 : 18.0,
                fontWeight: FontWeight.w800,
                color: _kHeaderColor,
              ),
            ),
          ),
        ),
        _NavButton(
          icon: Icons.chevron_right,
          onTap: _controller.nextMonth,
          filled: widget.skin == CalendarSkin.board,
        ),
      ],
    );
  }

  /// Weekday labels sit inside their own soft grey rounded strip with a
  /// hairline divider under it, visually separating them from the header
  /// above and the date grid below.
  Widget _buildWeekdayStrip() {
    final startIndex = widget.startWeekday - DateTime.monday; // 0..6
    final labels = List.generate(
      7,
          (i) => _weekdayLabelsMondayStart[(startIndex + i) % 7],
    );
    if (widget.skin == CalendarSkin.board) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    labels[i].substring(0, 1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      // Sat/Sun are the last two entries of the Monday-first list.
                      color: (startIndex + i) % 7 >= 5
                          ? _kWeekdayLabelColor
                          : _kHeaderColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        border: Border(
          bottom: BorderSide(color: _kWeekdayDivider, width: 1),
        ),
      ),
      child: Row(
        children: [
          for (final label in labels)
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: _kWeekdayLabelColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(
      DateTime month,
      double cellSize,
      double rowHeight,
      double cellWidth,
      ) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // DateTime.weekday: Monday=1 .. Sunday=7.
    final leading = (firstOfMonth.weekday - widget.startWeekday + 7) % 7;
    const totalCells = 42; // Always 6 fixed rows so page height never jumps.
    final today = DateTime.now();
    final selected = _controller.selectedDate.value;

    final isBoard = widget.skin == CalendarSkin.board;
    // Board skin: the surrounding card is drawn by the parent column, so the
    // grid itself is undecorated and the selection circle fills the cell.
    final double? selectionExtent = isBoard
        ? ((rowHeight - 2) < cellWidth ? rowHeight - 2 : cellWidth)
        : null;

    return Container(
      decoration: isBoard
          ? null
          : BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        border: Border.all(color: _kCardBorderColor, width: 1),
        boxShadow: widget.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: rowHeight,
        ),
        itemCount: totalCells,
        itemBuilder: (context, index) {
          final dayOffset = index - leading;
          final date = DateTime(month.year, month.month, dayOffset + 1);
          final isCurrentMonth = dayOffset >= 0 && dayOffset < daysInMonth;

          final isSelected = selected != null &&
              date.year == selected.year &&
              date.month == selected.month &&
              date.day == selected.day;

          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          final indicators =
              widget.dayIndicatorsBuilder?.call(date) ?? const <Color>[];

          final canTap = widget.onDateSelected != null &&
              (isCurrentMonth || widget.allowSelectOutsideMonth);

          return Center(
            child: CalendarDayCell(
              key: ValueKey(date.toIso8601String()),
              date: date,
              isCurrentMonth: isCurrentMonth,
              isSelected: isSelected,
              isToday: isToday,
              indicators: indicators,
              maxIndicators: widget.maxIndicatorsPerDay,
              selectedColor: widget.selectedColor,
              todayBorderColor: widget.todayBorderColor,
              cellSize: cellSize,
              boardStyle: isBoard,
              selectionExtent: selectionExtent,
              isWeekend: date.weekday == DateTime.saturday ||
                  date.weekday == DateTime.sunday,
              onTap: canTap ? () => _controller.selectDate(date) : null,
            ),
          );
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  /// Board skin: round grey background behind the chevron.
  final bool filled;

  const _NavButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return InkResponse(
        onTap: onTap,
        radius: 20,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: _kNavButtonBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: _kHeaderColor),
        ),
      );
    }
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 22, color: _kHeaderColor),
      ),
    );
  }
}


/// Renders a single day: the number, plus up to [maxIndicators] small
/// colored dots beneath it (the per-day "legend" markers).
///
/// - Selected day -> filled circle in [selectedColor], number in white,
///   dots switch to a soft white tint so they stay visible on the fill.
/// - Today (not selected) -> outlined circle in [todayBorderColor].
/// - Days outside the focused month -> greyed-out number, still tappable
///   only if [onTap] is provided (the parent decides whether cross-month
///   taps are allowed).
class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final List<Color> indicators;
  final int maxIndicators;
  final Color selectedColor;
  final Color todayBorderColor;
  final double cellSize;
  final VoidCallback? onTap;
  final TextStyle? dayTextStyle;

  /// Board skin: circle wraps number + dots; weekend numbers are muted.
  final bool boardStyle;
  final double? selectionExtent;
  final bool isWeekend;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.indicators,
    required this.selectedColor,
    required this.cellSize,
    this.maxIndicators = 4,
    this.todayBorderColor = const Color(0xFFF2703C),
    this.onTap,
    this.dayTextStyle,
    this.boardStyle = false,
    this.selectionExtent,
    this.isWeekend = false,
  });

  @override
  Widget build(BuildContext context) {
    final dots = indicators.take(maxIndicators).toList(growable: false);

    final Color numberColor = isSelected
        ? Colors.white
        : isCurrentMonth
        ? (dayTextStyle?.color ?? const Color(0xFF232D42))
        : const Color(0xFFC9CBD1);

    if (boardStyle) {
      return _BoardDayCell(
        date: date,
        isCurrentMonth: isCurrentMonth,
        isSelected: isSelected,
        isToday: isToday,
        isWeekend: isWeekend,
        dots: dots,
        selectedColor: selectedColor,
        todayBorderColor: todayBorderColor,
        extent: selectionExtent ?? cellSize,
        onTap: onTap,
      );
    }

    return Semantics(
      label: '${date.day}',
      selected: isSelected,
      button: onTap != null,
      child: InkResponse(
        onTap: onTap,
        radius: cellSize * 0.7,
        containedInkWell: true,
        highlightShape: BoxShape.circle,
        child: SizedBox(
          width: cellSize,
          height: cellSize + 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: cellSize,
                height: cellSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? selectedColor : Colors.transparent,
                  border: (!isSelected && isToday)
                      ? Border.all(color: todayBorderColor, width: 1.4)
                      : null,
                ),
                child: Text(
                  '${date.day}',
                  style: (dayTextStyle ??
                      const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))
                      .copyWith(
                    color: numberColor,
                    fontWeight: (isSelected || isToday) ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 6,
                child: dots.isEmpty
                    ? const SizedBox.shrink()
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final c in dots)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.white.withOpacity(0.9) : c,
                        ),
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
}


/// Renders an arbitrary number of [CalendarLegendItem]s as a wrapping row of
/// "● Label" chips, matching the legend strip at the bottom of the calendar
/// mock (Critical / High / Medium / Low). Wraps to a new line automatically
/// if there isn't enough width, so it scales to however many legends a
/// screen needs.
class CalendarLegendRow extends StatelessWidget {
  final List<CalendarLegendItem> legends;
  final double dotSize;
  final double spacing;
  final TextStyle? labelStyle;

  const CalendarLegendRow({
    super.key,
    required this.legends,
    this.dotSize = 8,
    this.spacing = 18,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (legends.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final legend in legends)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: legend.color,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                legend.label,
                style: labelStyle ??
                    const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B6B70),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
      ],
    );
  }
}


/// A single legend entry rendered under the calendar (e.g. "Critical" / red).
///
/// The calendar widget itself has zero opinion about what colors mean —
/// every screen that uses [AppCalendar] passes its own `List<CalendarLegendItem>`,
/// so the same widget can show task priorities on one screen and attendance
/// status on another.
@immutable
class CalendarLegendItem {
  final String label;
  final Color color;

  const CalendarLegendItem({
    required this.label,
    required this.color,
  });
}


/// Day cell for [CalendarSkin.board]. The selection / today circle fills the
/// cell and wraps both the day number and its dots; the dot row always
/// reserves its height so numbers stay on one baseline across a row.
class _BoardDayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool isWeekend;
  final List<Color> dots;
  final Color selectedColor;
  final Color todayBorderColor;
  final double extent;
  final VoidCallback? onTap;

  const _BoardDayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.isWeekend,
    required this.dots,
    required this.selectedColor,
    required this.todayBorderColor,
    required this.extent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color numberColor = isSelected
        ? Colors.white
        : !isCurrentMonth
        ? const Color(0xFFC9CBD1)
        : isWeekend
        ? _kWeekdayLabelColor
        : _kHeaderColor;

    return Semantics(
      label: '${date.day}',
      selected: isSelected,
      button: onTap != null,
      child: InkResponse(
        onTap: onTap,
        radius: extent / 2,
        containedInkWell: true,
        highlightShape: BoxShape.circle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: extent,
          height: extent,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? selectedColor : Colors.transparent,
            border: (!isSelected && isToday)
                ? Border.all(color: todayBorderColor, width: 1.4)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight:
                  (isSelected || isToday) ? FontWeight.w700 : FontWeight.w500,
                  color: numberColor,
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 4,
                child: dots.isEmpty
                    ? const SizedBox.shrink()
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final c in dots)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : c,
                        ),
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
}
