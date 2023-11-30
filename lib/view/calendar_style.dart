import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStyleHelper {
  static CalendarStyle getCalendarStyle(BuildContext context) {
    return CalendarStyle(
      selectedDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      selectedTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      todayDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      weekendTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      outsideDaysVisible: false,
      markersMaxCount: 5,
      markerSize: 5,
      markersAutoAligned: true,
      markersAlignment: Alignment.bottomCenter,
      markersOffset: const PositionedOffset(bottom: 10),
      markerMargin: const EdgeInsets.symmetric(
        horizontal: 1.0,
        vertical: 6.0,
      ),
      markerDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        shape: BoxShape.circle,
      ),
    );
  }

  static HeaderStyle getHeaderStyle(BuildContext context) {
    return HeaderStyle(
      titleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 20,
      ),
      formatButtonVisible: false,
      titleCentered: true,
    );
  }
}
