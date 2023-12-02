import 'package:flutter/material.dart';

final List<List<dynamic>> _colors = [
  [Colors.blueGrey, 'Default'],
  [Colors.indigo, 'Indigo'],
  [Colors.teal, 'Teal'],
  [Colors.green, 'Green'],
  [Colors.amber, 'Amber'],
  [Colors.deepOrange, 'Deep Orange'],
  [Colors.pinkAccent, 'Pink'],
  [const Color(0xFF800020), 'Burgundy Red'],
];

class CourseConfigGeneral extends StatefulWidget {
  const CourseConfigGeneral({super.key});

  @override
  State<CourseConfigGeneral> createState() => _CourseConfigGeneralState();
}

class _CourseConfigGeneralState extends State<CourseConfigGeneral> {
  final TextEditingController courseNameController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  Future<void> _selectStartDate(
    BuildContext context,
    StateSetter setState,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(
    BuildContext context,
    StateSetter setState,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: _selectedStartDate,
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('General'),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Next'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: TextField(
                    controller: courseNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter course name',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Course Color',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      FilledButton(
                        onPressed: () => showModalBottomSheet(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (
                                BuildContext context,
                                StateSetter setState,
                              ) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GridView.count(
                                          shrinkWrap: true,
                                          crossAxisCount: 4,
                                          children: List.generate(
                                              _colors.length, (index) {
                                            final color = _colors[index];
                                            return IconButton(
                                              icon: Icon(
                                                Icons.circle,
                                                color: color[0],
                                              ),
                                              tooltip: color[1],
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/general',
                                                );
                                              },
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select Start Date:',
                        style: TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () => _selectStartDate(context, setState),
                        icon: const Icon(Icons.calendar_month),
                        iconSize: 38,
                      ),
                      Text(
                        _selectedStartDate.toLocal().toString().split(' ')[0],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select End Date:',
                        style: TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () => _selectEndDate(context, setState),
                        icon: const Icon(Icons.calendar_month),
                        iconSize: 38,
                      ),
                      Text(
                        _selectedEndDate.toLocal().toString().split(' ')[0],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
