import './course_controller.dart';

class NavDrawerController {
  /// Returns the named route for the selected option.
  /// TODO: Will need to update this to use a streambuilder
  /// if int is within range of course pages, determine name of page to push to
  /// and since CoursePage has input parameters we will need to return a 2 index list
  static Future<String?> intToRoute(int? option) async {
    CourseController courseController = CourseController();
    final courses = await courseController.listCourses();
    String? namedRoute;

    if (option! >= 0 && option < 3) {
      // Home, Grades, or Profile
      namedRoute = ['/home', '/grades', '/profile'][option];
    } else if (option >= 3 && option < 3 + courses.length) {
      // Course Pages
      namedRoute = courses[option - 3].name;
    } else if (option == 3 + courses.length) {
      // Add Course
      namedRoute = '/add_course';
    } else {
      return null;
    }

    return namedRoute;
  }

  /// Returns the option for the given named route.
  static Future<int> routeToInt(String? namedRoute) async {
    CourseController courseController = CourseController();
    final courses = await courseController.listCourses();
    int option;

    switch (namedRoute) {
      case '/':
        option = 0;
        break;
      case '/grades':
        option = 1;
        break;
      case '/profile':
        option = 2;
        break;
      case '/add_course':
        option = 3 + courses.length;
        break;
      default:
        if (namedRoute != null && namedRoute.startsWith('/')) {
          final courseIndex = courses
              .indexWhere((course) => course.name == namedRoute.substring(1));
          if (courseIndex != -1) {
            option = 3 + courseIndex;
          } else {
            option = 0;
          }
        } else {
          option = 0;
        }
    }
    return option;
  }
}
