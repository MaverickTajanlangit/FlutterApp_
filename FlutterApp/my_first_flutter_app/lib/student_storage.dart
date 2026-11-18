
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'studentlistscreen.dart';

class StudentStorage {
  static const String storageKey = 'students';

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

    final saved = await prefs.setString(storageKey, encodedData);

    debugPrint('SAVE RESULT: $saved');
    debugPrint('STUDENTS SAVED: ${students.length}');
  }

  static Future<void> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(storageKey);

    debugPrint('LOADING ORIGINAL STUDENTS...');
    debugPrint('SAVED DATA FOUND: ${savedData != null}');

    if (savedData != null) {
      final List<dynamic> studentData = jsonDecode(savedData);

      // If an earlier version saved an empty list,
      // preserve the six original students already in memory.
      if (studentData.isEmpty) {
        debugPrint('EMPTY SAVED LIST. KEEPING ORIGINAL STUDENTS.');
        await saveStudents();
        return;
      }

      students.clear();

      for (var data in studentData) {
        students.add(
          Student(
            image: data['image'] ?? '',
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

      debugPrint('ORIGINAL STUDENTS LOADED: ${students.length}');
    } else {
      debugPrint('NO SAVED RECORDS. SAVING ORIGINAL STUDENTS.');
      await saveStudents();
    }
  }
}
