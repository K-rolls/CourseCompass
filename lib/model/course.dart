import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String? id;
  final DateTime start;
  final DateTime end;
  final String? questions;

  Course({
    this.id,
    required this.start,
    required this.end,
    this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'start': Timestamp.fromDate(
        start,
      ),
      'end': Timestamp.fromDate(
        end,
      ),
      'questions': questions,
    };
  }

  static Course fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      start: DateTime.parse(
        map['start'].toDate().toString(),
      ),
      end: DateTime.parse(
        map['end'].toDate().toString(),
      ),
      questions: map['questions'],
    );
  }
}
