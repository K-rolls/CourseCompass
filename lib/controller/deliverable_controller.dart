import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Will be needed
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:io';

import '../model/deliverable.dart';

class DeliverableController {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference deliverableCollection;

  // Collections need to be changed
  DeliverableController()
      : deliverableCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userEntries');

  Future<void> create(Deliverable deliverable) async {}

  Future<void> read() async {}

  Future<void> update(Deliverable deliverable) async {}

  Future<void> delete(Deliverable deliverable) async {}
}
