
import 'package:flutter/material.dart';
import 'student_api.dart';
import 'student_storage.dart';

class Student {
  int? databaseId;
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
    this.databaseId,
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

// Your original six students and their exact image assignments.
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
  ),
];

// Database records are kept separately in memory,
// but displayed together with the original students.
List<Student> databaseStudents = [];

// One combined list for displaying and checking student records.
List<Student> get allStudents => [
  ...students,
  ...databaseStudents,
];

String formatYearLevel(dynamic value) {
  if (value == null) return '';

  final year = int.tryParse(value.toString());

  switch (year) {
    case 1:
      return '1st Year';
    case 2:
      return '2nd Year';
    case 3:
      return '3rd Year';
    case 4:
      return '4th Year';
    default:
      return '';
  }
}

int? parseYearLevel(String value) {
  final match = RegExp(r'[1-4]').firstMatch(value);
  if (match == null) return null;
  return int.tryParse(match.group(0)!);
}

// Convert a Neon database record into a Student object.
// Notice that image is empty: database records never use sample images.
Student studentFromJson(Map<String, dynamic> data) {
  return Student(
    databaseId: int.tryParse(data['student_id'].toString()),
    image: '',
    name: data['student_name']?.toString() ?? 'Unknown Student',
    course: data['course']?.toString() ?? 'Not specified',
    yearLevel: formatYearLevel(data['year_level']),
    age: 0,
    hobby: 'Not specified',
    studentId: data['student_number']?.toString() ?? '',
    email: data['email']?.toString() ?? '',
    favoriteSubject: 'Not specified',
  );
}

// Shared Edit Student modal.
Future<bool?> showStudentEditDialog(
    BuildContext context,
    Student student,
    ) async {
  final idController = TextEditingController(text: student.studentId);
  final nameController = TextEditingController(text: student.name);
  final courseController = TextEditingController(text: student.course);
  final yearController = TextEditingController(text: student.yearLevel);
  final emailController = TextEditingController(text: student.email);

  bool isSaving = false;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
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
                onPressed: isSaving
                    ? null
                    : () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
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

                  final yearNumber = parseYearLevel(newYear);

                  if (yearNumber == null) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Enter a valid year level (1st Year to 4th Year).',
                        ),
                      ),
                    );
                    return;
                  }

                  final duplicateId = allStudents.any(
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

                  setDialogState(() {
                    isSaving = true;
                  });

                  try {
                    if (student.databaseId != null) {
                      // Update a Neon database record.
                      await StudentApi.updateStudent(
                        student.databaseId!,
                        {
                          'student_number': newId,
                          'student_name': newName,
                          'course': newCourse,
                          'year_level': yearNumber,
                          'email': newEmail,
                        },
                      );
                    }

                    // Update the displayed student object.
                    student.studentId = newId;
                    student.name = newName;
                    student.course = newCourse;
                    student.yearLevel = newYear;
                    student.email = newEmail;

                    // Save only original local students.
                    if (student.databaseId == null) {
                      await StudentStorage.saveStudents();
                    }

                    if (!dialogContext.mounted) return;

                    Navigator.pop(dialogContext, true);
                  } catch (error) {
                    if (!dialogContext.mounted) return;

                    setDialogState(() {
                      isSaving = false;
                    });

                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to update student: $error',
                        ),
                      ),
                    );
                  }
                },
                child: isSaving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Save Changes'),
              ),
            ],
          );
        },
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
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadStudentRecords();
  }

  Future<void> loadStudentRecords() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load the six original students from local storage.
      await StudentStorage.loadStudents();

      // Load database students without changing the original list.
      final records = await StudentApi.getStudents();

      databaseStudents = records.map((record) {
        return studentFromJson(
          Map<String, dynamic>.from(record),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    }
  }

  Widget buildStudentImage(Student student) {
    if (student.image.isEmpty) {
      return const CircleAvatar(
        radius: 35,
        child: Icon(Icons.person, size: 40),
      );
    }

    return ClipOval(
      child: Image.asset(
        student.image,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const CircleAvatar(
            radius: 35,
            child: Icon(Icons.person, size: 40),
          );
        },
      ),
    );
  }

  Future<void> deleteStudent(Student student) async {
    try {
      if (student.databaseId != null) {
        // Delete only the selected Neon database record.
        await StudentApi.deleteStudent(student.databaseId!);
        databaseStudents.remove(student);
      } else {
        // Delete only the selected original local student.
        students.remove(student);
        await StudentStorage.saveStudents();
      }

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student deleted successfully.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete student: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedStudents = [...allStudents]
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Updated List'),
        actions: [
          IconButton(
            onPressed: loadStudentRecords,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/add-student',
              );

              if (!mounted) return;

              if (result == true) {
                await loadStudentRecords();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : displayedStudents.isEmpty
          ? Center(
        child: Text(
          errorMessage ?? 'No students found',
          textAlign: TextAlign.center,
        ),
      )
          : Column(
        children: [
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade100,
              child: Text(
                'Database could not be refreshed. '
                    'Showing available local students.\n$errorMessage',
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedStudents.length,
              itemBuilder: (context, index) {
                final student = displayedStudents[index];

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

                            if (!mounted) return;

                            setState(() {});
                          },
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              buildStudentImage(student),
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
                                    Text(
                                      student.yearLevel.isEmpty
                                          ? 'Year Level: Not specified'
                                          : student.yearLevel,
                                    ),
                                    Text(
                                      student.age == 0
                                          ? 'Age: Not specified'
                                          : 'Age: ${student.age}',
                                    ),
                                    Text('Hobby: ${student.hobby}'),
                                    Text(
                                      'Student ID: ${student.studentId.isEmpty ? 'Not provided' : student.studentId}',
                                    ),
                                    Text(
                                      'Email: ${student.email.isEmpty ? 'Not provided' : student.email}',
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
                                        padding:
                                        EdgeInsets.only(top: 5),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                setState(() {
                                  student.isFavorite =
                                  !student.isFavorite;
                                });

                                if (student.databaseId == null) {
                                  await StudentStorage.saveStudents();
                                }
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

                                if (!mounted) return;

                                if (result == true) {
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            if (student.isActive)
                              IconButton(
                                onPressed: () async {
                                  await deleteStudent(student);
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
          ),
        ],
      ),
    );
  }
}
