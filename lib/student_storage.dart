
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'studentlistscreen.dart';

class StudentStorage {
  static const String storageKey = 'students';

  // Save all student records locally
  static Future<void> saveStudents() async {
    final prefs = await SharedPreferences.getInstance();

    final studentData = students.map((student) {
      return {
        'image': student.image,
        'name': student.name,
        'course': student.course,
        'yearLevel': student.yearLevel,
        'age': student.age,
        'hobby': student.hobby,
        'studentId': student.studentId,
        'email': student.email,
        'favoriteSubject': student.favoriteSubject,
        'isFavorite': student.isFavorite,
        'isActive': student.isActive,
      };
    }).toList();

    final encodedData = jsonEncode(studentData);

    final saved = await prefs.setString(
      storageKey,
      encodedData,
    );

    debugPrint('SAVE RESULT: $saved');
    debugPrint('STUDENTS SAVED: ${students.length}');
    debugPrint('SAVED DATA: $encodedData');
  }

  // Load student records from local storage
  static Future<void> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString(storageKey);

    debugPrint('LOADING STUDENTS...');
    debugPrint('SAVED DATA FOUND: ${savedData != null}');

    if (savedData != null) {
      final List<dynamic> studentData = jsonDecode(savedData);

      students.clear();

      for (var data in studentData) {
        students.add(
          Student(
            image: data['image'] ?? 'assets/student1.jpg',
            name: data['name'] ?? '',
            course: data['course'] ?? '',
            yearLevel: data['yearLevel'] ?? '',
            age: data['age'] ?? 0,
            hobby: data['hobby'] ?? 'Not specified',
            studentId: data['studentId'] ?? '',
            email: data['email'] ?? '',
            favoriteSubject:
            data['favoriteSubject'] ?? 'Not specified',
            isFavorite: data['isFavorite'] ?? false,
            isActive: data['isActive'] ?? true,
          ),
        );
      }

      debugPrint('STUDENTS LOADED: ${students.length}');
    } else {
      debugPrint('NO SAVED RECORDS FOUND.');
      debugPrint('SAVING INITIAL STUDENT RECORDS...');

      // Save the original student records on first launch
      await saveStudents();
    }
  }
}
