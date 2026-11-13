import 'dart:async';
import 'package:flutter/material.dart';

class Student {
  String image;
  String name;
  String course;
  String yearLevel;
  int age;
  String hobby;
  String studentId;
  String email;
  String favoriteSubject;
  bool isFavorite;
  bool isActive;

  Student({
    required this.image,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
    this.isFavorite = false,
    this.isActive = true,
  });
}

List<Student> students = [
  Student(
    image: 'assets/student1.jpg',
    name: 'lol',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Dancing',
    studentId: '0001',
    email: 'maverick@mamamail.com',
    favoriteSubject: 'Programming',
    isActive: true,
  ),
  Student(
    image: 'assets/student2.jpg',
    name: 'Bryan Kinnot',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Reading',
    studentId: '0002',
    email: 'bryan@mamamail.com',
    favoriteSubject: 'Database',
    isActive: false,
  ),
  Student(
    image: 'assets/student3.jpg',
    name: 'Chimmy Ksks',
    course: 'BS Information Technology',
    yearLevel: '2nd Year',
    age: 19,
    hobby: 'Gaming',
    studentId: '0003',
    email: 'chimmy@mamamail.com',
    favoriteSubject: 'Web Development',
    isActive: true,
  ),
  Student(
    image: 'assets/student4.jpg',
    name: 'Julia Yashipakaka',
    course: 'BS Information Technology',
    yearLevel: '1st Year',
    age: 18,
    hobby: 'Basketball',
    studentId: '0004',
    email: 'julia@mamamail.com',
    favoriteSubject: 'Computer Fundamentals',
    isActive: false,
  ),
  Student(
    image: 'assets/student5.jpg',
    name: 'James Gulaugh',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'Photography',
    studentId: '0005',
    email: 'james@mamamail.com',
    favoriteSubject: 'Networking',
    isActive: true,
  ),
  Student(
    image: 'assets/student6.jpg',
    name: 'Marick Sumalangitka',
    course: 'BS Information Technology',
    yearLevel: '2nd Year',
    age: 19,
    hobby: 'Drawing',
    studentId: '0006',
    email: 'marick@mamamail.com',
    favoriteSubject: 'Mobile Development',
    isActive: true,
  ),
];

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void showEditDialog(Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: Text(
            'Edit information for ${student.name}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    students.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-student',
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : students.isEmpty
          ? const Center(
        child: Text(
          'No students found',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      )
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/student-details',
                        arguments: student,
                      );
                    },
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            student.image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(student.course),
                              Text(student.yearLevel),
                              Text('Age: ${student.age}'),
                              Text('Hobby: ${student.hobby}'),
                              Text(
                                'Student ID: ${student.studentId}',
                              ),
                              Text(
                                'Email: ${student.email}',
                              ),
                              Text(
                                'Favorite Subject: ${student.favoriteSubject}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                student.isActive
                                    ? 'Active'
                                    : 'Inactive',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (student.isFavorite)
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Text(
                                    'Favorite',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            student.isFavorite =
                            !student.isFavorite;
                          });
                        },
                        icon: Icon(
                          student.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showEditDialog(student);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      if (student.isActive)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              students.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
