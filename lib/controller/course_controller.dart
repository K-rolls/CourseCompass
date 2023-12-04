import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course.dart';

class CourseController {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference courseCollection;

  CourseController()
      : courseCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userCourses');

  Future<Course?> createCourse(Course course) async {
    if (await courseExists(course)) {
      deleteCourse(course);
      return createCourse(course);
    }
    try {
      await courseCollection.add(
        course.toMap(),
      );
      return await getCourseByName(courseName: course.name);
    } catch (e) {
      throw Exception("createCourse - $e");
    }
  }

  Future<List<Course>> listCourses() async {
    try {
      QuerySnapshot snapshot = await courseCollection.get();
      return snapshot.docs
          .map(
            (doc) => Course.fromMap(doc),
          )
          .toList();
    } catch (e) {
      throw Exception('listCourses - $e');
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      return await courseCollection.doc(course.id).update(
            course.toMap(),
          );
    } catch (e) {
      throw Exception("updateCourse - $e");
    }
  }

  Future<void> deleteCourse(Course course) async {
    if (!await courseExists(course)) {
      throw Exception('deleteCourse - No course found');
    }
    try {
      return await courseCollection.doc(course.id).delete();
    } catch (e) {
      throw Exception("deleteCourse - $e");
    }
  }

  Future<bool> courseExists(Course course) async {
    try {
      QuerySnapshot snapshot = await courseCollection
          .where(
            'name',
            isEqualTo: course.name,
          )
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception("courseExists - $e");
    }
  }

  Future<Course?> getCourseByName({required String courseName}) async {
    try {
      QuerySnapshot snapshot = await courseCollection
          .where(
            'name',
            isEqualTo: courseName,
          )
          .get();

      // Should only ever be one course with given name
      return snapshot.docs
          .map(
            (doc) => Course.fromMap(doc),
          )
          .toList()
          .firstOrNull;
    } catch (e) {
      throw Exception("getCourseByName - $e");
    }
  }
}
