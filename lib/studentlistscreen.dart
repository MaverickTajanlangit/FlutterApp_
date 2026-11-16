
import 'package:flutter/material.dart';
import 'student_storage.dart';

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
    name: 'Maverick Tajanlangit',
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

// Shared Edit Student modal
Future<bool?> showStudentEditDialog(
    BuildContext context,
    Student student,
    ) async {
  final idController =
  TextEditingController(text: student.studentId);
  final nameController =
  TextEditingController(text: student.name);
  final courseController =
  TextEditingController(text: student.course);
  final yearController =
  TextEditingController(text: student.yearLevel);
  final emailController =
  TextEditingController(text: student.email);

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                ),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                ),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newId = idController.text.trim();
              final newName = nameController.text.trim();
              final newCourse = courseController.text.trim();
              final newYear = yearController.text.trim();
              final newEmail = emailController.text.trim();

              if (newId.isEmpty ||
                  newName.isEmpty ||
                  newCourse.isEmpty ||
                  newYear.isEmpty ||
                  newEmail.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields.'),
                  ),
                );
                return;
              }

              final duplicateId = students.any(
                    (other) =>
                !identical(other, student) &&
                    other.studentId.toLowerCase() ==
                        newId.toLowerCase(),
              );

              if (duplicateId) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Student ID already exists.'),
                  ),
                );
                return;
              }

              final emailPattern =
              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

              if (!emailPattern.hasMatch(newEmail)) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a valid email address.'),
                  ),
                );
                return;
              }

              student.studentId = newId;
              student.name = newName;
              student.course = newCourse;
              student.yearLevel = newYear;
              student.email = newEmail;

              await StudentStorage.saveStudents();

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext, true);
            },
            child: const Text('Save Changes'),
          ),
        ],
      );
    },
  );

  idController.dispose();
  nameController.dispose();
  courseController.dispose();
  yearController.dispose();
  emailController.dispose();

  return result;
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudentRecords();
  }

  Future<void> loadStudentRecords() async {
    await StudentStorage.loadStudents();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    students.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Updated List'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/add-student',
              );

              if (result == true && mounted) {
                setState(() {});
              }
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
          style: TextStyle(fontSize: 20),
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
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/student-details',
                        arguments: student,
                      );

                      if (mounted) {
                        setState(() {});
                      }
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
                                  fontWeight:
                                  FontWeight.bold,
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
                                  fontWeight:
                                  FontWeight.bold,
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
                                      fontWeight:
                                      FontWeight.bold,
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
                        onPressed: () async {
                          setState(() {
                            student.isFavorite =
                            !student.isFavorite;
                          });

                          await StudentStorage.saveStudents();
                        },
                        icon: Icon(
                          student.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result =
                          await showStudentEditDialog(
                            context,
                            student,
                          );

                          if (result == true && mounted) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      if (student.isActive)
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              students.removeAt(index);
                            });

                            await StudentStorage.saveStudents();
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
