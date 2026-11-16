import 'package:flutter/material.dart';
import 'studentlistscreen.dart';
import 'student_storage.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController studentIdController =
  TextEditingController();

  final TextEditingController fullNameController =
  TextEditingController();

  final TextEditingController courseController =
  TextEditingController();

  final TextEditingController yearLevelController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Student ID';
    }

    bool exists = students.any(
          (student) =>
      student.studentId.toLowerCase() ==
          value.trim().toLowerCase(),
    );

    if (exists) {
      return 'Student ID already exists';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Email Address';
    }

    final emailPattern =
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validateYearLevel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Year Level';
    }

    const validYears = [
      '1st Year',
      '2nd Year',
      '3rd Year',
      '4th Year',
    ];

    if (!validYears.contains(value.trim())) {
      return 'Enter 1st, 2nd, 3rd, or 4th Year';
    }

    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }

    return null;
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      Student newStudent = Student(
        image: 'assets/student1.jpg',
        name: fullNameController.text.trim(),
        course: courseController.text.trim(),
        yearLevel: yearLevelController.text.trim(),
        age: 0,
        hobby: 'Not specified',
        studentId: studentIdController.text.trim(),
        email: emailController.text.trim(),
        favoriteSubject: 'Not specified',
      );

      students.add(newStudent);

      await StudentStorage.saveStudents();

      studentIdController.clear();
      fullNameController.clear();
      courseController.clear();
      yearLevelController.clear();
      emailController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student successfully enrolled!'),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    studentIdController.dispose();
    fullNameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Student Enrollment Form',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: validateStudentId,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateRequired(value, 'Full Name'),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateRequired(value, 'Course'),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: yearLevelController,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                  hintText: 'Example: 1st Year',
                  border: OutlineInputBorder(),
                ),
                validator: validateYearLevel,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: validateEmail,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Enroll Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
