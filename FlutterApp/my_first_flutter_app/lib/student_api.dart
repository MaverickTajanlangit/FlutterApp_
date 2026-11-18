
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StudentApi {
  // Automatically select the correct backend address.
  static const String baseUrl = kIsWeb
      ? 'http://127.0.0.1:8000'
      : 'http://10.0.2.2:8000';

  // GET: Retrieve all students from Neon.
  static Future<List<dynamic>> getStudents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/students'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception(
      'Failed to load students: ${response.body}',
    );
  }

  // POST: Add a new student to Neon.
  static Future<Map<String, dynamic>> addStudent(
      Map<String, dynamic> student,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(student),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Failed to add student: ${response.body}',
    );
  }

  // PUT: Update an existing student in Neon.
  static Future<Map<String, dynamic>> updateStudent(
      int id,
      Map<String, dynamic> student,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/students/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(student),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Failed to update student: ${response.body}',
    );
  }

  // DELETE: Remove a student from Neon.
  static Future<void> deleteStudent(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/students/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete student: ${response.body}',
      );
    }
  }
}
