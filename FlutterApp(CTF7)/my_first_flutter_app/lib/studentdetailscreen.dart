import 'package:flutter/material.dart';
import 'studentlistscreen.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  void showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${student.name}'),
              const SizedBox(height: 10),
              Text('Student ID: ${student.studentId}'),
              const SizedBox(height: 10),
              Text('Course: ${student.course}'),
              const SizedBox(height: 10),
              Text('Year Level: ${student.yearLevel}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Text('Favorite Subject: ${student.favoriteSubject}'),
            const SizedBox(height: 10),
            Text(
              student.isActive ? 'Status: Active' : 'Status: Inactive',
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showEditDialog(context);
                },
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}