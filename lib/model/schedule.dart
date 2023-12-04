import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String? id;
  final String name;
  final DateTime dateTime;
  final bool? attended;
  String? summary;

  Schedule({
    this.id,
    required this.name,
    required this.dateTime,
    this.attended = false,
    this.summary,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateTime': Timestamp.fromDate(
        dateTime,
      ),
      'summary': summary,
      'attended': attended,
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
      summary: map['summary'],
      attended: map['attended'],
    );
  }
}
