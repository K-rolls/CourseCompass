import 'package:course_compass/controller/schedule_controller.dart';
import 'package:course_compass/model/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course.dart';
import '../model/timeslot.dart';
import 'parse_controller.dart';

class TimeslotController {
  final user = FirebaseAuth.instance.currentUser;
  Course? course;

  final CollectionReference timeslotCollection;

  TimeslotController({required this.course})
      : timeslotCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userCourses')
            .doc(course?.id)
            .collection('courseTimeslots');

  Future<DocumentReference<Object?>> createTimeslot(Timeslot timeslot) async {
    try {
      return await timeslotCollection.add(
        timeslot.toMap(),
      );
    } catch (e) {
      throw Exception("createSchedule - $e");
    }
  }

  Future<List<Timeslot>> listTimeslots() async {
    try {
      QuerySnapshot snapshot = await timeslotCollection.get();
      return snapshot.docs
          .map(
            (doc) => Timeslot.fromMap(doc),
          )
          .toList();
    } catch (e) {
      throw Exception('listTimeslots - $e');
    }
  }

  Future<void> updateTimeslot(Timeslot timeslot) async {
    try {
      return await timeslotCollection.doc(timeslot.id).update(
            timeslot.toMap(),
          );
    } catch (e) {
      throw Exception("updateTimeslot - $e");
    }
  }

  Future<void> deleteTimeslot(Timeslot timeslot) async {
    try {
      return await timeslotCollection.doc(timeslot.id).delete();
    } catch (e) {
      throw Exception("deleteTimeslot - $e");
    }
  }

  Future<bool> timeslotExists(Timeslot timeslot) async {
    try {
      QuerySnapshot snapshot = await timeslotCollection
          .where(
            'id',
            isEqualTo: timeslot.id,
          )
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception("timeslotExists - $e");
    }
  }

  Stream<QuerySnapshot> getStream() {
    return timeslotCollection.snapshots();
  }

  Future<void> fillSchedule() async {
    try {
      List<Timeslot> timeslots = await listTimeslots();
      ScheduleController scheduleController =
          ScheduleController(course: course);

      int weeksInSemester = weeksUntilDate(course!.end);

      for (Timeslot timeslot in timeslots) {
        for (int i = 0; i < weeksInSemester; i++) {
          for (int j = 0; j < timeslot.days.length; j++) {
            if (timeslot.days[j] == true) {
              DateTime dateTime = ParseController.nextDatetimeWeekday(
                time: timeslot.time,
                targetDayIndex: j,
              );
              DateTime incrementedDateTime = dateTime.add(
                Duration(days: i * 7),
              );
              Schedule schedule = Schedule(
                name: timeslot.name,
                dateTime: incrementedDateTime,
              );
              scheduleController.createSchedule(schedule);
            }
          }
        }
      }
    } catch (e) {
      throw Exception('fillSchedule - $e');
    }
  }

  int weeksUntilDate(DateTime targetDate) {
    DateTime now = DateTime.now();
    return targetDate.difference(now).inDays ~/ 7;
  }
}
