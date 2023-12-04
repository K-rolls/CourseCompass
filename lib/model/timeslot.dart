import 'package:cloud_firestore/cloud_firestore.dart';

class Timeslot {
  final String? id;
  final String name;
  final List<dynamic> days;
  final DateTime time;

  Timeslot({
    this.id,
    required this.name,
    required this.days,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'days': days,
      'time': Timestamp.fromDate(
        time,
      ),
    };
  }

  static Timeslot fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;

    List<dynamic> daysCopy = map['days'];

    return Timeslot(
      id: doc.id,
      name: map['name'],
      days: daysCopy,
      time: DateTime.parse(
        map['time'].toDate().toString(),
      ),
    );
  }
}
