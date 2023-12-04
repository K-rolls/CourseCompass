import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Course {
  final String? id;
  final String name;
  final DateTime start;
  final DateTime end;
  final String? questions;
  final Color? color;
  final num? currentGrade;
  final num? gradeWanted;
  final num? gradeNeeded;

  Course({
    this.id,
    required this.name,
    required this.start,
    required this.end,
    this.color,
    this.questions,
    this.currentGrade,
    this.gradeWanted,
    this.gradeNeeded,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'start': Timestamp.fromDate(
        start,
      ),
      'end': Timestamp.fromDate(
        end,
      ),
      'questions': questions,
      'color': color?.value.toString(),
      'currentGrade': currentGrade,
      'gradeWanted': gradeWanted,
      'gradeNeeded': gradeNeeded,
    };
  }

  static Course fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      name: map['name'],
      start: DateTime.parse(
        map['start'].toDate().toString(),
      ),
      end: DateTime.parse(
        map['end'].toDate().toString(),
      ),
      questions: map['questions'],
      color: map['color'] != null ? Color(int.parse(map['color'])) : null,
      currentGrade: map['currentGrade'],
      gradeWanted: map['gradeWanted'],
      gradeNeeded: map['gradeNeeded'],
    );
  }
}
