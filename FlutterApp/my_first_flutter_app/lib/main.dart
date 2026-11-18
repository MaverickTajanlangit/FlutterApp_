import 'package:flutter/material.dart';
import 'studentlistscreen.dart';
import 'studentdetailscreen.dart';
import 'addstudentscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const StudentListScreen(),
        '/student-details': (context) {
          final student =
          ModalRoute.of(context)!.settings.arguments as Student;

          return StudentDetailsScreen(
            student: student,
          );
        },
        '/add-student': (context) => const AddStudentScreen(),
      },
    );
  }
}