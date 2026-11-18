
import 'package:flutter/material.dart';
import 'studentlistscreen.dart';
import 'student_api.dart';

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

  bool isSubmitting = false;

  @override
  void dispose() {
    studentIdController.dispose();
    fullNameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();
    super.dispose();
  }

  int? getYearLevel(String value) {
    switch (value.trim().toLowerCase()) {
      case '1st year':
        return 1;
      case '2nd year':
        return 2;
      case '3rd year':
        return 3;
      case '4th year':
        return 4;
      default:
        return null;
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final studentNumber = studentIdController.text.trim();

    final alreadyExists = allStudents.any(
          (student) =>
      student.studentId.toLowerCase() ==
          studentNumber.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student ID already exists.'),
        ),
      );
      return;
    }

    final yearLevel = getYearLevel(yearLevelController.text);

    if (yearLevel == null) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await StudentApi.addStudent({
        'student_number': studentNumber,
        'student_name': fullNameController.text.trim(),
        'course': courseController.text.trim(),
        'year_level': yearLevel,
        'email': emailController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student successfully enrolled!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to enroll student: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
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
            children: [
              TextFormField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Full Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Course';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: yearLevelController,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                  hintText: 'Example: 3rd Year',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      getYearLevel(value) == null) {
                    return 'Enter 1st, 2nd, 3rd, or 4th Year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Email';
                  }

                  final emailPattern =
                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                  if (!emailPattern.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitForm,
                  child: isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Enroll Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
