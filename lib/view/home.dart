import 'package:course_compass/controller/schedule_controller.dart';
import 'package:course_compass/view/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../controller/course_controller.dart';
import '../controller/deliverable_controller.dart';
import '../model/course.dart';
import '../controller/notification_controller.dart';
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

class _HomeViewState extends State<HomeView> {
  bool _showDeliverables = true;
  bool loaded = false;
  final notificationController = NotificationController();
  late DateTime _selectedDate;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final CourseController _courseController = CourseController();

  late DeliverableController? _deliverableController;
  late List<dynamic> _deliverables = [];

  late ScheduleController? _scheduleController;
  late List<dynamic> _schedules = [];

  late List<DateTime> events = [];
  late List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        await _fetchCourseData().then(
          (_) {
            super.setState(
              () {
                loaded = true;
              },
            );
          },
        );
      },
    );
    Future.delayed(
      Duration.zero,
      () async {
        notificationController.addUserToken();
      },
    );
    setupMessages();
    FirebaseMessaging.onMessage.listen(
      (event) {
        if (event.notification == null) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                event.notification?.title ?? '',
                style: const TextStyle(fontSize: 25),
              ),
              content: SizedBox(
                width: 200,
                child: Text(
                  event.notification?.body ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Dismiss', style: TextStyle(fontSize: 15)),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Visit', style: TextStyle(fontSize: 15)),
                  onPressed: () => handleNavigation(event),
                ),
              ],
            );
          },
        );
      },
    );
    _selectedDate = DateTime.now();
  }

  Future<void> _fetchCourseData() async {
    courses = await _courseController.listCourses();
    List<dynamic> deliverablesWaited = [];
    List<dynamic> schedulesWaited = [];
    List<DateTime> eventList = [];

    for (var course in courses) {
      if (course.start.isBefore(_startDate)) {
        setState(
          () {
            _startDate = course.start;
          },
        );
      }
      if (course.end.isAfter(_endDate)) {
        setState(
          () {
            _endDate = course.end;
          },
        );
      }
      _deliverableController = DeliverableController(course: course);
      await _deliverableController!.listDeliverables().then(
        (deliverables) {
          for (var deliverable in deliverables) {
            eventList.add(deliverable.due);
            deliverablesWaited.add([deliverable, course]);
          }
        },
      );
      _scheduleController = ScheduleController(course: course);
      await _scheduleController!.listSchedule().then(
        (schedule) {
          for (var timeslot in schedule) {
            eventList.add(timeslot.dateTime);
            schedulesWaited.add([timeslot, course]);
          }
        },
      );
      _deliverableController = null;
      _scheduleController = null;
    }
    setState(() {
      _deliverables = deliverablesWaited;
      _schedules = schedulesWaited;
      events = eventList;
    });
  }

  List<Widget> _showCards({required bool isDeliverable}) {
    List<Widget> cards = [];
    List<dynamic> filteredDeliverables = [];
    if (isDeliverable) {
      for (var deliverable in _deliverables) {
        if (deliverable[0].due.day == _selectedDate.day &&
            deliverable[0].due.month == _selectedDate.month &&
            deliverable[0].due.year == _selectedDate.year) {
          filteredDeliverables.add(deliverable);
        }
      }

      if (filteredDeliverables.isEmpty) {
        cards.add(
          SizedBox(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            width: MediaQuery.of(context).copyWith().size.width * 0.75,
            child: Center(
              child: Text(
                "Nothing is due today! 🥳",
                style: CustomTextStyle.titleStyle,
              ),
            ),
          ),
        );
      }

      for (var deliverable in filteredDeliverables) {
        cards.add(
          DueDateCard(
            name: deliverable[0].name,
            dueDate: deliverable[0].due,
            color: deliverable[1].color ?? Colors.blueGrey,
            courseName: deliverable[1].name,
          ),
        );
      }
    } else if (!isDeliverable) {
      for (var timeslot in _schedules) {
        if (timeslot[0].dateTime.day == _selectedDate.day &&
            timeslot[0].dateTime.month == _selectedDate.month &&
            timeslot[0].dateTime.year == _selectedDate.year) {
          filteredDeliverables.add(timeslot);
        }
      }

      if (filteredDeliverables.isEmpty) {
        cards.add(
          SizedBox(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            width: MediaQuery.of(context).copyWith().size.width * 0.75,
            child: Center(
              child: Text(
                "No lectures today! 😎",
                style: CustomTextStyle.titleStyle,
              ),
            ),
          ),
        );
      }

      for (var schedule in filteredDeliverables) {
        cards.add(
          LectureCard(
            schedule: schedule[0],
            name: schedule[0].name,
            lectureTime: schedule[0].dateTime,
            color: schedule[1].color ?? Colors.blueGrey,
            courseName: schedule[1].name,
          ),
        );
      }
    }
    return cards;
  }

  List<Widget> _dueDateDigest() {
    List<Widget> cards = [];

    _deliverables.sort((a, b) => a[0].due.compareTo(b[0].due));

    for (var deliverable in _deliverables) {
      cards.add(
        DueDateCard(
          name: deliverable[0].name,
          dueDate: deliverable[0].due,
          color: deliverable[1].color ?? Colors.blueGrey,
          courseName: deliverable[1].name,
        ),
      );
    }

    return cards;
  }

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
                      Column(
                        children: _showCards(
                          isDeliverable: _showDeliverables,
                        ),
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

  Future<void> setupMessages() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleNavigation(message);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(handleNavigation);
  }

  void handleNavigation(RemoteMessage message) {
    if (message.data['type'] == 'timeslot') {
      Navigator.pushNamed(context, '/grades');
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).copyWith().size.height * 0.55,
              child: loaded
                  ? SizedBox(
                      child: TableCalendar(
                        calendarStyle:
                            CalendarStyleHelper.getCalendarStyle(context),
                        shouldFillViewport: true,
                        calendarFormat: CalendarFormat.month,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        headerStyle:
                            CalendarStyleHelper.getHeaderStyle(context),
                        firstDay: _startDate,
                        lastDay: _endDate,
                        focusedDay: DateTime.now(),
                        eventLoader: (day) {
                          return events.where((event) {
                            return isSameDay(day, event);
                          }).toList();
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
                    )
                  : const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
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
                  children: _dueDateDigest(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
