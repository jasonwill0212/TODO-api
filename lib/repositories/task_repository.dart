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
  Future<List<Task>> deleteTask(String id) async {
    try {
      return await apiService.deleteTask(id);
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.deleteTask: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to delete task in TaskRepository.deleteTask: $e');
    }
  }

  /// Update task
  Future<List<Task>> updateTask(Task task) async {
    try {
      return await apiService.updateTask(task);
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.updateTask: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to update task in TaskRepository.updateTask: $e');
    }
  }

  Future<List<Task>> createTask(Task task) async {
    try {
      return await apiService.createTask(task);
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.createTask: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to create task in TaskRepository.createTask: $e');
    }
  }
}
