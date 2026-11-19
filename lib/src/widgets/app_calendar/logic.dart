import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// All calendar state lives here — the widget layer is just a `View`
/// reacting to this controller via `Obx`. Each `AppCalendar` instance gets
/// its own tagged controller (see `AppCalendar`'s `tag` param), so you can
/// have several calendars on screen at once (dashboard + tasks screen +
/// attendance screen) without them fighting over shared state.
class CalendarController extends GetxController {
  CalendarController({
    DateTime? initialMonth,
    DateTime? initialSelectedDate,
    this.onDateSelected,
    this.onMonthChanged,
  }) {
    final now = DateTime.now();
    baseMonth = DateTime(now.year, now.month);
    focusedMonth = Rx<DateTime>(
      initialMonth != null
          ? DateTime(initialMonth.year, initialMonth.month)
          : baseMonth,
    );
    selectedDate = Rx<DateTime?>(initialSelectedDate);
    currentPage = (basePage + _monthDiff(baseMonth, focusedMonth.value)).obs;
    pageController = PageController(initialPage: currentPage.value);
  }

  /// Large-but-finite page space so both directions swipe freely for years
  /// without special-casing bounds.
  static const int basePage = 6000;

  late final DateTime baseMonth;
  late final Rx<DateTime> focusedMonth;
  late final Rx<DateTime?> selectedDate;
  late final RxInt currentPage;
  late final PageController pageController;

  /// Kept mutable (not final) so the owning widget can refresh these on
  /// `didUpdateWidget` without recreating the whole controller.
  ValueChanged<DateTime>? onDateSelected;
  ValueChanged<DateTime>? onMonthChanged;

  int _monthDiff(DateTime a, DateTime b) =>
      (b.year - a.year) * 12 + (b.month - a.month);

  DateTime monthForPage(int page) {
    final diff = page - basePage;
    return DateTime(baseMonth.year, baseMonth.month + diff);
  }

  void nextMonth() => _animateToPage(currentPage.value + 1);

  void previousMonth() => _animateToPage(currentPage.value - 1);

  void _animateToPage(int page) {
    if (!pageController.hasClients) return;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  /// Called from `PageView.onPageChanged`.
  void handlePageChanged(int page) {
    currentPage.value = page;
    final month = monthForPage(page);
    focusedMonth.value = month;
    onMonthChanged?.call(month);
  }

  /// Called when a day cell is tapped.
  void selectDate(DateTime date) {
    selectedDate.value = date;
    onDateSelected?.call(date);
  }

  /// Public API so other parts of the app can drive this calendar from
  /// outside, e.g.:
  /// `Get.find<CalendarController>(tag: 'tasks_calendar').jumpToMonth(d);`
  void jumpToMonth(DateTime month) {
    final target = DateTime(month.year, month.month);
    if (target == focusedMonth.value) return;
    focusedMonth.value = target;
    final targetPage = basePage + _monthDiff(baseMonth, target);
    currentPage.value = targetPage;
    if (pageController.hasClients) {
      pageController.jumpToPage(targetPage);
    }
  }

  /// Keeps the controller in sync when the parent widget's `selectedDate`
  /// / `initialMonth` props change externally (controlled usage).
  void syncSelectedDate(DateTime? date) {
    if (date != selectedDate.value) selectedDate.value = date;
  }

  void syncMonth(DateTime? month) {
    if (month != null) jumpToMonth(month);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}