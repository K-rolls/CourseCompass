import '../../custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../course_view.dart';
import 'nav_course.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  /// Returns the named route for the selected option.
  /// TODO: Will need to update this to use a streambuilder
  /// if int is within range of course pages, determine name of page to push to
  /// and since CoursePage has input parameters we will need to return a 2 index list
  ///
  /// we can check the length of the list to determine if we need to push to a
  /// defined page or dynamic page later
  List<String> _intToRoute(int option) {
    String namedRoute;
    switch (option) {
      case 0:
        namedRoute = '/home';
        break;
      case 1:
        namedRoute = '/grades';
        break;
      case 2:
        namedRoute = '/profile';
        break;
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        namedRoute = 'Course 1';
        break;
      case 9:
        namedRoute = '/add_course';
        break;
      default:
        namedRoute = '/';
    }
    // print(namedRoute);
    return [namedRoute];
  }

  /// Returns the option for the given named route.
  int _routeToInt(String? namedRoute) {
    int option;
    switch (namedRoute) {
      case '/home':
        option = 0;
        break;
      case '/grades':
        option = 1;
        break;
      case '/profile':
        option = 2;
        break;
      case 'course 1':
        option = 3;
        break;
      default:
        option = 0;
    }
    return option;
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = _routeToInt(ModalRoute.of(context)!.settings.name);
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        selectedIndex = index;
        String namedRoute = _intToRoute(index)[0];

        if (!namedRoute.startsWith('/')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseView(
                courseName: namedRoute,
              ),
            ),
          );
        } else if (namedRoute == '/') {
          () async {
            await FirebaseAuth.instance.signOut();
          }();
        }
        Navigator.of(context).pushNamed(namedRoute);
      },
      tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            leading: Icon(
              CustomIcons.mycoursecompass,
              size: 40.0,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            title: Text(
              'My Course Compass',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        const NavigationDrawerDestination(
          icon: Icon(
            Symbols.home_rounded,
          ),
          selectedIcon: Icon(
            Icons.home_filled,
          ),
          label: Text('Home'),
          // onTap: () => Navigator.of(context).pushNamed('/home'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(
            Symbols.history_edu_rounded,
          ),
          selectedIcon: Icon(
            Icons.history_edu,
          ),
          label: Text('Grades'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(
            Symbols.account_circle_rounded,
          ),
          selectedIcon: Icon(
            Icons.account_circle,
          ),
          label: Text('Profile'),
        ),
        const Divider(),
        // TODO: Update with streambuilder
        const NavCourse(
          color: Colors.red,
          name: 'Course 1',
          icon: Icon(Icons.circle),
          label: Text(''),
        ),
        const NavCourse(
          color: Colors.blue,
          name: 'Course 2',
          icon: Icon(Icons.circle),
          label: Text(''),
        ),
        const NavCourse(
          color: Colors.green,
          name: 'Course 3',
          icon: Icon(Icons.circle),
          label: Text(''),
        ),
        const NavCourse(
          color: Colors.yellow,
          name: 'Course 4',
          icon: Icon(Icons.circle),
          label: Text(''),
        ),
        const NavCourse(
          color: Colors.orange,
          name: 'Course 5',
          icon: Icon(Icons.circle),
          label: Text(''),
        ),
        const NavCourse(
          color: Colors.purple,
          name: 'Course 6',
          icon: Icon(Icons.circle),
          label: Text(''),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          label: Text(
            'Add Course',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          icon: Icon(
            Symbols.add,
            size: 25.0,
          ),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(
            Symbols.logout_rounded,
          ),
          label: Text('Logout'),
        ),
      ],
    );
  }
}
