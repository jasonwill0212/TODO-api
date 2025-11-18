import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:todo_api/models/task.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com';
  static const String _apiHost = 'task-manager-api3.p.rapidapi.com';
  static const String _apiKey =
      '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a';

  static const Map<String, String> _headers = {
    'X-RapidAPI-Host': _apiHost,
    'X-RapidAPI-Key': _apiKey,
    'Content-Type': 'application/json',
  };

  Future<List<Task>> getAllTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      debugPrint('Api url: $_baseUrl');
      debugPrint('Method: GET');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if (response.body.isEmpty) {
          throw Exception('No tasks found');
        }
        final List<dynamic> tasks = responseJson['data'];
        return tasks
            .map((json) => Task.fromJson(json))
            .where((tasks) => tasks.id != null && tasks.id!.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching tasks: $e, stackTrace: $stackTrace');
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
        // body: json.encode({'id': id}),
      );
      debugPrint('Api url: $_baseUrl/$id');
      debugPrint('Method: DELETE');
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Delete Task Success');
      } else {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error deleting task: $e, stackTrace: $stackTrace');
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${task.id}'),
        headers: _headers,
        body: json.encode(task.toJson()),
      );
      debugPrint('Api url: $_baseUrl/${task.id}');
      debugPrint('Method: PUT');
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Update Task Success');
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error updating task: $e, stackTrace: $stackTrace');
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: json.encode({
          "title": task.title,
          "description": task.description,
          "status": task.status,
        }),
      );
      debugPrint('Api url: $_baseUrl');
      debugPrint('Method: POST');
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 201) {
        debugPrint('Task created successfully: ${response.body}');
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error creating task: $e, stackTrace: $stackTrace');
      throw Exception('Failed to create task: $e');
    }
  }
}
