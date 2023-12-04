import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../model/notification.dart';

class NotificationController {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference notificationCollection;

  NotificationController()
      : notificationCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notifications');

  Future<DocumentReference<Object?>> createNotification(
    Notification notification,
  ) async {
    try {
      return await notificationCollection.add(
        notification.toMap(),
      );
    } catch (e) {
      throw Exception("createDeliverable - $e");
    }
  }

  Future<List<Notification>> listNotifications() async {
    try {
      QuerySnapshot snapshot = await notificationCollection.get();
      return snapshot.docs
          .map(
            (doc) => Notification.fromMap(doc),
          )
          .toList();
    } catch (e) {
      throw Exception('listDeliverables - $e');
    }
  }

  Future<void> updateNotification(Notification notification) async {
    try {
      return await notificationCollection.doc(notification.id).update(
            notification.toMap(),
          );
    } catch (e) {
      throw Exception("updateNotification - $e");
    }
  }

  Future<void> deleteDeliverable(Notification notification) async {
    try {
      return await notificationCollection.doc(notification.id).delete();
    } catch (e) {
      throw Exception("deleteNotification - $e");
    }
  }

  Future<void> addUserToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final token = await messaging.getToken(
      vapidKey:
          'BJJDYx7ZNNDB9GSwHsysFPDD9-McAxe2Y3wyUkqNCvQ_QuxRagDQV9KjkmneiYDbrjtD-We1046BanuJ6WxeCZs',
    );

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final tokenRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tokens')
        .doc(token);

    final tokenDoc = await tokenRef.get();

    if (tokenDoc.exists) {
      return;
    } else {
      tokenRef.set(
        {
          'token': token,
        },
      );
    }
  }
}
