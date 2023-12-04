import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course.dart';
import '../model/schedule.dart';

class ScheduleController {
  final user = FirebaseAuth.instance.currentUser;
  Course? course;

  final CollectionReference scheduleCollection;

  ScheduleController({required this.course})
      : scheduleCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userCourses')
            .doc(course?.id)
            .collection('courseSchedule');

  Future<DocumentReference<Object?>> createSchedule(Schedule schedule) async {
    try {
      return await scheduleCollection.add(
        schedule.toMap(),
      );
    } catch (e) {
      throw Exception("createSchedule - $e");
    }
  }

  Future<void> createFromList({
    required String name,
    required List<DateTime> list,
  }) async {
    for (DateTime dateTime in list) {
      Schedule schedule = Schedule(
        name: name,
        dateTime: dateTime,
      );
      createSchedule(schedule);
    }
  }

  Future<List<Schedule>> listSchedule() async {
    try {
      QuerySnapshot snapshot = await scheduleCollection.get();
      return snapshot.docs
          .map(
            (doc) => Schedule.fromMap(doc),
          )
          .toList();
    } catch (e) {
      throw Exception('listSchedule - $e');
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    try {
      return await scheduleCollection.doc(schedule.id).update(
            schedule.toMap(),
          );
    } catch (e) {
      throw Exception("updateSchedule - $e");
    }
  }

  Future<void> deleteSchedule(Schedule schedule) async {
    // if (!await scheduleExists(schedule)) {
    //   throw Exception('deleteSchedule - Not found');
    // }
    try {
      return await scheduleCollection.doc(schedule.id).delete();
    } catch (e) {
      throw Exception("deleteSchedule - $e");
    }
  }

  Future<bool> scheduleExists(Schedule schedule) async {
    try {
      QuerySnapshot snapshot = await scheduleCollection
          .where(
            'id',
            isEqualTo: schedule.id,
          )
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception("scheduleExists - $e");
    }
  }
}
