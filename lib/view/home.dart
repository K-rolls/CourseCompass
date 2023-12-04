import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import './styles/calendar_style.dart';
import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './components/due_date_card.dart';
import './components/lecture_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

bool _showDeliverables = true;

class _HomeViewState extends State<HomeView> {
  late DateTime _selectedDate;
  final int n = 6;
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setState,
          ) {
            return SizedBox(
              height: MediaQuery.of(context).copyWith().size.height * 0.65,
              child: RawScrollbar(
                radius: const Radius.circular(8.0),
                thumbColor: Theme.of(context).colorScheme.background,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showDeliverables = true;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: _showDeliverables
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                  backgroundColor: _showDeliverables
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                ),
                                child: const Text('Deliverables'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showDeliverables = false;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: !_showDeliverables
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                  backgroundColor: !_showDeliverables
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                ),
                                child: const Text('Time Slots'),
                              ),
                            ],
                          ),
                          if (_showDeliverables)
                            Column(
                              children: List.generate(
                                10,
                                (index) => DueDateCard(
                                  color: Colors.red,
                                  name: 'Course $index',
                                  type: 'Assignment $index',
                                  dueDate: DateTime.now(),
                                ),
                              ),
                            ),
                          if (!_showDeliverables)
                            Column(
                              children: List.generate(
                                3,
                                (index) => LectureCard(
                                  name: "Course ${index + 1}",
                                  type: "Lecture ${index + 1}",
                                  color: Colors.green,
                                  lectureTime: DateTime.now(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.height * 0.55,
                child: TableCalendar(
                  calendarStyle: CalendarStyleHelper.getCalendarStyle(context),
                  shouldFillViewport: true,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  headerStyle: CalendarStyleHelper.getHeaderStyle(context),
                  // TODO: Update with actual events from firestore
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2023, 12, 31),
                  focusedDay: DateTime.now(),
                  eventLoader: (day) {
                    return [DateTime.now()];
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                    _showBottomSheet();
                  },
                ),
              ),
              Column(
                children: [
                  const Divider(
                    thickness: 2,
                    indent: 15.0,
                    endIndent: 15.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Due Date Digest:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < n; i++)
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.compass_calibration_sharp),
                              title: Text('Due Date'),
                              subtitle: Text('Course Name'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
