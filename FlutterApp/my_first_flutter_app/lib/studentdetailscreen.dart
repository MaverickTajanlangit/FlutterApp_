
import 'package:flutter/material.dart';
import 'studentlistscreen.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailsScreen> createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {
  Future<void> editStudent() async {
    final result = await showStudentEditDialog(
      context,
      widget.student,
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text('Student ID: ${student.studentId}'),
            const SizedBox(height: 10),
            Text('Course: ${student.course}'),
            const SizedBox(height: 10),
            Text('Year Level: ${student.yearLevel}'),
            const SizedBox(height: 10),
            Text('Age: ${student.age}'),
            const SizedBox(height: 10),
            Text('Hobby: ${student.hobby}'),
            const SizedBox(height: 10),
            Text('Email: ${student.email}'),
            const SizedBox(height: 10),
            Text(
              'Favorite Subject: ${student.favoriteSubject}',
            ),
            const SizedBox(height: 10),
            Text(
              student.isActive
                  ? 'Status: Active'
                  : 'Status: Inactive',
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: editStudent,
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
