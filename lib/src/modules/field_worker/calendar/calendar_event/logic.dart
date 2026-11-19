import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/calendar_event_model.dart';
import '../model/event_mock_data.dart';
import 'view.dart';

class CalendarEventLogic extends GetxController {
  CalendarEventLogic({DateTime? initialSelectedDate})
    : selectedDate = Rx<DateTime>(initialSelectedDate ?? DateTime.now());

  final Rx<DateTime> selectedDate;

  final RxList<CalendarEvent> events = <CalendarEvent>[].obs;

  final RxBool isLoading = false.obs;

  final Set<String> _loadedMonths = {};

  @override
  void onInit() {
    super.onInit();
    loadEventsForMonth(selectedDate.value);
  }

  String _monthKey(DateTime month) {
    return '${month.year}-${month.month}';
  }

  Future<void> loadEventsForMonth(DateTime month) async {
    final key = _monthKey(month);

    if (_loadedMonths.contains(key)) {
      return;
    }

    try {
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 150));

      final fresh = CalendarEventMockData.forMonth(month);

      for (final event in fresh) {
        final exists = events.any((item) => item.id == event.id);

        if (!exists) {
          events.add(event);
        }
      }

      _loadedMonths.add(key);
    } finally {
      isLoading.value = false;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  List<CalendarEvent> eventsForDate(DateTime date) {
    final matches = events.where((event) => event.occursOn(date)).toList();

    matches.sort((a, b) {
      if (a.isAllDay != b.isAllDay) {
        return a.isAllDay ? -1 : 1;
      }

      final aTime = a.startTime;
      final bTime = b.startTime;

      if (aTime == null || bTime == null) {
        return 0;
      }

      final aMinutes = aTime.hour * 60 + aTime.minute;

      final bMinutes = bTime.hour * 60 + bTime.minute;

      return aMinutes.compareTo(bMinutes);
    });

    return matches;
  }

  List<Color> colorsForDate(DateTime date) {
    final types = eventsForDate(date).map((event) => event.type).toSet();

    return types.map((type) => type.color).toList(growable: false);
  }

  void addEvent(CalendarEvent event) {
    events.add(event);
    selectedDate.value = event.startDate;

    // Make sure the calendar has data for the new month.
    loadEventsForMonth(event.startDate);
  }

  Future<void> openCreateEvent() async {
    final created = await Get.to<CalendarEvent>(
      () => CreateEventScreen(initialDate: selectedDate.value),
    );

    if (created != null) {
      addEvent(created);
    }
  }
}
