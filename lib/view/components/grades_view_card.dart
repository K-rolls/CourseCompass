import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../styles/card_style.dart';

class GradesCard extends StatelessWidget {
  final String name;
  final Color color;

  /// Creates a card that displays the average for a course and how much is needed to get x %.
  ///
  /// The `name` parameter is a string representing the name of the course.
  /// The `color` parameter is a color representing the color of the card.
  // TODO: Update this to take in stream params
  const GradesCard({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      height: MediaQuery.of(context).size.height * 0.17,
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
                padding: CardStyle.defaultPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: CardStyle.titleStyle,
                        ),
                        const Spacer(),
                        Icon(
                          Symbols.circle,
                          color: color,
                          size: 25,
                          weight: 1000,
                        ),
                      ],
                    ),
                    Divider(color: color),
                    Row(
                      children: [
                        Text(
                          'Grade',
                          style: CardStyle.bodyStyle,
                        ),
                        const Spacer(),
                        Text(
                          '80%',
                          style: CardStyle.bodyStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Needed to get 100%',
                          style: CardStyle.bodyStyle,
                        ),
                        const Spacer(),
                        Text(
                          '90%',
                          style: CardStyle.bodyStyle,
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
