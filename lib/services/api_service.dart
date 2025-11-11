import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:todo_api/models/task.dart';
import 'package:http/http.dart' as http;

class ApiService {
  //  final response = await http.get(
  //   Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
  //   headers: {
  //     'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
  //     'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
  //   },
  // );
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com';
  static const String _apiKey =
      '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a';
  static const String _apiHost = 'task-manager-api3.p.rapidapi.com';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  /// Get All Tasks
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> tasksJson = jsonResponse['data'];
          return tasksJson
              .map((json) => Task.fromJson(json))
              .where((task) => task.id != null) // filter task id != null
              .toList();
        } else {
          throw Exception(
            'API returned error status: ${jsonResponse['status']}',
          );
        }
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching tasks: $e, StackTrace: $stackTrace');
      throw Exception('Failed to load tasks: $e');
    }
  }

  /// Create task

  /// Delete task

  /// Edit task
}
