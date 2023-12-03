import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String? id;
  final String name;
  final DateTime dateTime;

  Schedule({
    this.id,
    required this.name,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': name,
      'dateTime': Timestamp.fromDate(
        dateTime,
      ),
    };
  }

  static Schedule fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Schedule(
      id: doc.id,
      name: map['name'],
      dateTime: DateTime.parse(
        map['dateTime'].toDate().toString(),
      ),
    );
  }
}
