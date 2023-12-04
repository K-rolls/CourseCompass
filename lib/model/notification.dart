import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String? id;
  final String name;
  final String courseName;
  final String type;
  final DateTime time;

  Notification({
    this.id,
    required this.name,
    required this.courseName,
    required this.type,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'courseName': courseName,
      'type': type,
      'time': Timestamp.fromDate(
        time,
      ),
    };
  }

  static Notification fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Notification(
      id: doc.id,
      name: map['name'],
      courseName: map['courseName'],
      type: map['type'],
      time: DateTime.parse(
        map['time'].toDate().toString(),
      ),
    );
  }
}
