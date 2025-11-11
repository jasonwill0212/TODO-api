import 'package:flutter/foundation.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/services/api_service.dart';

class TaskRepository {
  final ApiService apiService = ApiService();

  /// Get All Tasks
  Future<List<Task>> getAllTasks() async {
    try {
      return await apiService.getAllTasks();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.getAllTasks: $e, StackTrace: $stackTrace',
      );
      throw Exception(
        'Failed to get all tasks in TaskRepository.getAllTasks: $e',
      );
    }
  }

  /// Create task

  /// Delete task

  /// Edit task
}
