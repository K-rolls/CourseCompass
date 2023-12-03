import 'package:cloud_firestore/cloud_firestore.dart';

class Deliverable {
  final String? id;
  final String name;
  final DateTime due;
  final double weight;
  final bool? done;
  final double? grade;

  Deliverable({
    this.id,
    required this.name,
    required this.due,
    required this.weight,
    this.done,
    this.grade,
  });

  // Need toMap for firebase collections
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'due': Timestamp.fromDate(
        due, // Firebase uses Timestamp instead of DateTime
      ),
      'weight': weight,
      'done': done,
      'grade': grade,
    };
  }

  static Deliverable fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Deliverable(
      id: doc.id,
      name: map['name'],
      due: DateTime.parse(
        map['due'].toDate().toString(),
      ), // Convert back to DateTime
      weight: map['weight'],
      done: map['done'],
      grade: map['grade'],
    );
  }
}
