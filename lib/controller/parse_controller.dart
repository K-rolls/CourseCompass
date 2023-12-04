import 'package:course_compass/controller/timeslot_controller.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';

import '../model/course.dart';
import '../model/timeslot.dart';

class ParseController {
  static Map<String, int> dayIndexMap = {
    'sun': DateTime.sunday,
    'mon': DateTime.monday,
    'tue': DateTime.tuesday,
    'wed': DateTime.wednesday,
    'thu': DateTime.thursday,
    'fri': DateTime.friday,
    'sat': DateTime.saturday,
  };

  ParseController();

  static Future<String> extractTextFromPDF() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles();
    List<int> fileBytes = file!.files.first.bytes!;
    final PdfDocument document = PdfDocument(inputBytes: fileBytes);

    PdfTextExtractor extractor = PdfTextExtractor(
      document,
    );

    String text = extractor.extractText();

    String trimmedText =
        text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');

    document.dispose();

    return trimmedText;

    // print(getLecturesList(trimmedText));
    // print(getLabsList(trimmedText));

    // print(getLectureTimeslot(trimmedText).name);
    // print(getLabTimeslot(trimmedText).name);

    //TimeslotController timeslotController = TimeslotController();

    // TODO: add the list of datetimes to the users schedule
  }

  static Future<void> addTimeslotsFromPDF(Course? course) async {
    String text = await extractTextFromPDF();

    TimeslotController timeslotController = TimeslotController(course: course);
    timeslotController.createTimeslot(getLectureTimeslot(text));
    timeslotController.createTimeslot(getLabTimeslot(text));
  }

  static Timeslot getLectureTimeslot(String syllabusText) {
    RegExp regex =
        RegExp(r'lecture(\w{3}/\w{3})(\d{1,2}:\d{2})–(\d{1,2}:\d{2})');

    Match? match = regex.firstMatch(syllabusText);

    if (match != null) {
      DateTime now = DateTime.now();

      String daysOfWeek = match.group(1)!; // tue/thu
      String startTime = match.group(2)!; // 10:30

      List<String> days = daysOfWeek.split('/');
      List<String> hourAndMinute = startTime.split(':');

      List<int?> lectureDayIndexList = [
        dayIndexMap[days[0]],
        dayIndexMap[days[1]],
      ];
      int lectureHour = int.parse(hourAndMinute[0]);
      int lectureMinute = int.parse(hourAndMinute[1]);

      DateTime lectureTime = DateTime(
        now.year,
        now.month,
        now.day,
        lectureHour,
        lectureMinute,
      );

      List<bool> dayList = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];

      for (int? day in lectureDayIndexList) {
        dayList[day!] = true;
      }
      return Timeslot(
        name: 'Lecture',
        days: dayList,
        time: lectureTime,
      );
    } else {
      throw Exception("Lab pattern not found in the input text.");
    }
  }

  static Timeslot getLabTimeslot(String syllabusText) {
    RegExp regex = RegExp(r'lab([a-z]{3})(\d{1,2}:\d{2})–(\d{1,2}:\d{2}[ap]m)');

    Match? match = regex.firstMatch(syllabusText);

    if (match != null) {
      DateTime now = DateTime.now();

      String dayOfWeek = match.group(1)!;
      String startTime = match.group(2)!;
      String endTime = match.group(3)!;

      List<String> hourAndMinute = startTime.split(':');

      int? labDayIndex = dayIndexMap[dayOfWeek];
      int labHour = int.parse(hourAndMinute[0]);
      int labMinute = int.parse(hourAndMinute[1]);

      if (endTime.contains("pm")) {
        labHour = labHour + 12;
      }

      DateTime labTime = DateTime(
        now.year,
        now.month,
        now.day,
        labHour,
        labMinute,
      );

      List<bool> dayList = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];
      dayList[labDayIndex!] = true;
      return Timeslot(
        name: 'Lab',
        days: dayList,
        time: labTime,
      );
    } else {
      throw Exception("Lab pattern not found in the input text.");
    }
  }

  static List<DateTime> getLabsList(String syllabusText) {
    RegExp regex = RegExp(r'lab([a-z]{3})(\d{1,2}:\d{2})–(\d{1,2}:\d{2}[ap]m)');

    Match? match = regex.firstMatch(syllabusText);

    if (match != null) {
      DateTime now = DateTime.now();

      String dayOfWeek = match.group(1)!;
      String startTime = match.group(2)!;
      String endTime = match.group(3)!;

      List<String> hourAndMinute = startTime.split(':');

      int? labDayIndex = dayIndexMap[dayOfWeek];
      int labHour = int.parse(hourAndMinute[0]);
      int labMinute = int.parse(hourAndMinute[1]);

      if (endTime.contains("pm")) {
        labHour = labHour + 12;
      }

      DateTime labTime = DateTime(
        now.year,
        now.month,
        now.day,
        labHour,
        labMinute,
      );

      DateTime nextLab = nextDatetimeWeekday(
        time: labTime,
        targetDayIndex: labDayIndex,
      );

      List<DateTime> labList = generateRecurringDatetimes(
        initialDatetime: nextLab,
        numRecurrences: 10,
      );

      return labList;
    } else {
      throw Exception("Lab pattern not found in the input text.");
    }
  }

  static List<DateTime> getLecturesList(String syllabusText) {
    // Define a regular expression to match the lecture pattern
    RegExp regex =
        RegExp(r'lecture(\w{3}/\w{3})(\d{1,2}:\d{2})–(\d{1,2}:\d{2})');

    // Use the firstMatch method to find the first occurrence of the pattern
    Match? match = regex.firstMatch(syllabusText);

    // Check if a match is found and extract the components
    if (match != null) {
      DateTime now = DateTime.now();

      String daysOfWeek = match.group(1)!; // tue/thu
      String startTime = match.group(2)!; // 10:30

      List<String> days = daysOfWeek.split('/');
      List<String> hourAndMinute = startTime.split(':');

      int? lectureOneDayIndex = dayIndexMap[days[0]];
      int? lectureTwoDayIndex = dayIndexMap[days[1]];
      int lectureHour = int.parse(hourAndMinute[0]);
      int lectureMinute = int.parse(hourAndMinute[1]);

      DateTime lectureTime = DateTime(
        now.year,
        now.month,
        now.day,
        lectureHour,
        lectureMinute,
      );

      DateTime nextLectureOne = nextDatetimeWeekday(
        time: lectureTime,
        targetDayIndex: lectureOneDayIndex,
      );

      DateTime nextLectureTwo = nextDatetimeWeekday(
        time: lectureTime,
        targetDayIndex: lectureTwoDayIndex,
      );

      List<DateTime> lectureOneList = generateRecurringDatetimes(
        initialDatetime: nextLectureOne,
        numRecurrences: 10,
      );

      List<DateTime> lectureTwoList = generateRecurringDatetimes(
        initialDatetime: nextLectureTwo,
        numRecurrences: 10,
      );

      return lectureOneList + lectureTwoList;
    } else {
      throw Exception("Pattern not found in the input text.");
    }
  }

  static DateTime nextDatetimeWeekday({
    required DateTime time,
    required int? targetDayIndex,
  }) {
    int currentDayIndex = time.weekday;

    int daysUntilNext = (targetDayIndex! - currentDayIndex + 7) % 7;

    return time.add(Duration(days: daysUntilNext));
  }

  static List<DateTime> generateRecurringDatetimes({
    required DateTime initialDatetime,
    required int numRecurrences,
  }) {
    int startDayIndex = initialDatetime.weekday;
    int startHour = initialDatetime.hour;
    int startMinute = initialDatetime.minute;

    List<DateTime> recurringDatetimes = [];
    int dayInterval = 7;

    for (int i = 0; i < numRecurrences; i++) {
      DateTime datetime = DateTime.now()
          .subtract(
            Duration(days: DateTime.now().weekday - startDayIndex),
          )
          .add(
            Duration(
              days: i * dayInterval,
              hours: startHour,
              minutes: startMinute,
            ),
          );

      recurringDatetimes.add(
        DateTime(
          datetime.year,
          datetime.month,
          datetime.day,
          initialDatetime.hour,
          initialDatetime.minute,
          initialDatetime.second,
          initialDatetime.microsecond,
        ),
      );
    }

    return recurringDatetimes.sublist(1);
  }
}
