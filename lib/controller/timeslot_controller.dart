import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course.dart';
import '../model/timeslot.dart';

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
}
