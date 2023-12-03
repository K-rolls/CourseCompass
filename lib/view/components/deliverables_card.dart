import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/text_style.dart';

class DeliverablesCard extends StatelessWidget {
  final String name;
  final Color color;
  final num weight;
  final DateTime dueDate;
  final TimeOfDay dueTime;
  final bool padding;
  final Function? onTap;

  /// Creates a card that displays each course deliverable.
  //TODO: Update this to take in stream params
  const DeliverablesCard({
    super.key,
    required this.name,
    required this.color,
    required this.weight,
    required this.dueDate,
    required this.dueTime,
    required this.onTap,
    this.padding = true,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: () => onTap!(),
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
                    Row(
                      children: [
                        Text(
                          'Weight',
                          style: CustomTextStyle.bodyStyle,
                        ),
                        const Spacer(),
                        Text(
                          '${weight.toString()}%',
                          style: CustomTextStyle.bodyStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Due Date',
                          style: CustomTextStyle.bodyStyle,
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('MMMEd').format(dueDate),
                          style: CustomTextStyle.bodyStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Due Time',
                          style: CustomTextStyle.bodyStyle,
                        ),
                        const Spacer(),
                        Text(
                          '${dueTime.hour}:${dueTime.minute.toString().padLeft(2, '0')}',
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
