import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Will be needed
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:io';

import '../model/timeslot.dart';

class TimeslotController {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference timeslotCollection;

  // Collections need to be changed
  TimeslotController()
      : timeslotCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userEntries');

  Future<void> create(Timeslot timeslot) async {}

  Future<void> read() async {}

  Future<void> update(Timeslot timeslot) async {}

  Future<void> delete(Timeslot timeslot) async {}
}
