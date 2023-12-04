import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course.dart';
import '../model/deliverable.dart';

class DeliverableController {
  final user = FirebaseAuth.instance.currentUser;
  Course? course;

  final CollectionReference deliverableCollection;

  DeliverableController({required this.course})
      : deliverableCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userCourses')
            .doc(course?.id)
            .collection('courseDeliverables');

  Future<DocumentReference<Object?>> createDeliverable(
    Deliverable deliverable,
  ) async {
    try {
      return await deliverableCollection.add(
        deliverable.toMap(),
      );
    } catch (e) {
      throw Exception("createDeliverable - $e");
    }
  }

  Future<List<Deliverable>> listDeliverables() async {
    try {
      QuerySnapshot snapshot = await deliverableCollection.get();
      return snapshot.docs
          .map(
            (doc) => Deliverable.fromMap(doc),
          )
          .toList();
    } catch (e) {
      throw Exception('listDeliverables - $e');
    }
  }

  Future<void> updateDeliverable(Deliverable deliverable) async {
    try {
      return await deliverableCollection.doc(deliverable.id).update(
            deliverable.toMap(),
          );
    } catch (e) {
      throw Exception("updateDeliverable - $e");
    }
  }

  Future<void> deleteDeliverable(Deliverable deliverable) async {
    try {
      return await deliverableCollection.doc(deliverable.id).delete();
    } catch (e) {
      throw Exception("deleteDeliverable - $e");
    }
  }

  Future<bool> deliverableExists(Deliverable deliverable) async {
    try {
      QuerySnapshot snapshot = await deliverableCollection
          .where(
            'id',
            isEqualTo: deliverable.id,
          )
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception("deliverableExists - $e");
    }
  }

  Stream<QuerySnapshot> getStream() {
    return deliverableCollection.snapshots();
  }
}
