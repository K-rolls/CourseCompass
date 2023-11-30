# course_compass

## **Team Members and GitHub Accounts:**

Cole Matthews - https://github.com/cmatthews20

Keegan Rolls - https://github.com/K-rolls

Kirkland Keeping - https://github.com/KirklandKeeping

Robert Lush - https://github.com/rwlush

## **App Description:**

Our app is intended to combine all aspects of several group members' custom spreadsheets used to keep track of various academic semester information (i.e. grades, due dates, class schedule, class attendance, study strategies, questions for the professor, class summaries). This app will help students stay focused, give them a bird's eye view of the semester, track performance, and develop study plans, thus making their lives easier.

## **Target Audience:**

This app is designed for university students. Particularly those with full and chaotic schedules who want to ensure they are getting the most out of their education.

## **Key Features:**

1. **Due Date Tracking:**
   Users can upload due dates and times for each course so they can keep track of when they are due. This feature will be divided into course and due date types. For example, a midterm due date differs from an assignment due date as less preparation is needed for assignments.

2. **Grade Tracking:**
   Users can upload their syllabus and upload grades as they come in to keep track of their performance, get a birds-eye view of the progression of the semester, and evaluate where their efforts are best placed.

3. **Attendance Tracking:**
   When a syllabus is added, the app will be made aware of when classes take place and office hours. The app will notify the users about upcoming classes and prompt them to input their attendance.

4. **Question Tracking:** When a user has questions about a class they discover after class or would like to email the professor later, they can enter this information into a class and store it for later.

5. **Class Summaries:** At the end of each class, a notification will prompt the user to input a very brief summary of the class. I.e. “prof covered slides 10-50, placed importance on agile development for midterm 1”.

6. **Multi-View Calendar (home page):** Different calendar view types will be provided (month view, week view, and list view). The user can filter each view based on course or event type. Some example events include tests, classes, labs, office hours, and others.

7. **Course Tabs:** Although maybe not an explicit feature, the app is intended to have a class-centric focus rather than a feature focus. More specifically, the features laid out above will be tools to track individual courses within each course tab rather than disjoint app features.

## **Tech Stack:**

- **UI Development:** Flutter:

- **User Management:** FirebaseAuth

- **Database:** Firestore

- **File Storage:** Firebase Cloud Storage (for storing syllabi)

- **Flutter Libraries/Packages:** Syncfusion (time permitting, we would like to leverage this library to extract text from syllabus PDFs to automatically fill class schedules and due dates) and table_calendar (calendar creation)
