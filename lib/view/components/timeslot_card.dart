import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../styles/text_style.dart';

class TimeslotCard extends StatelessWidget {
  final String name;
  final Color color;
  final List<bool> weekDays;
  final TimeOfDay startTime;
  final bool padding;

  /// Creates a card that displays each course timeslot.

  //TODO: Update this to take in stream params
  const TimeslotCard({
    super.key,
    required this.name,
    required this.color,
    required this.weekDays,
    required this.startTime,
    this.padding = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.light
        ? ThemeData.light(
            useMaterial3: true,
          ).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: color,
              brightness: Brightness.light,
            ),
          )
        : ThemeData.dark(
            useMaterial3: true,
          ).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: color,
              brightness: Brightness.dark,
            ),
          );
    return Container(
      padding: padding
          ? const EdgeInsets.only(
              top: 8.0,
              left: 16.0,
              right: 16.0,
            )
          : null,
      height: MediaQuery.of(context).size.height * 0.26,
      child: Card(
        color: color.withOpacity(0.333),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: InkWell(
              onTap: () {
                // TODO: Implement onTap functionality
              },
              borderRadius: BorderRadius.circular(6.0),
              child: Padding(
                padding: CustomTextStyle.defaultPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: CustomTextStyle.titleStyle,
                        ),
                      ],
                    ),
                    Divider(color: color),
                    IgnorePointer(
                      child: WeekdaySelector(
                        color: theme.colorScheme.onSurface,
                        selectedColor: theme.colorScheme.onPrimaryContainer,
                        fillColor: theme.colorScheme.surface,
                        selectedFillColor: theme.colorScheme.primaryContainer,
                        enableFeedback: false,
                        firstDayOfWeek: 0,
                        onChanged: null,
                        values: weekDays,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Start Time',
                          style: CustomTextStyle.bodyStyle,
                        ),
                        const Spacer(),
                        Text(
                          '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
                          style: CustomTextStyle.bodyStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
