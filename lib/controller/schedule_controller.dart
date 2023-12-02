import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Will be needed
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:io';

import '../model/schedule.dart';

class ClassController {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference scheduleCollection;

  // Collections need to be changed
  ClassController()
      : scheduleCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userEntries');

  Future<void> create(Schedule schedule) async {}

  Future<void> read() async {}

  Future<void> update(Schedule schedule) async {}

  Future<void> delete(Schedule schedule) async {}
}
