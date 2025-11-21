import 'package:flutter/foundation.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/services/api_service.dart';
import 'package:todo_api/services/local_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TaskRepository {
  final ApiService apiService = ApiService();
  final LocalService localService = LocalService();
  final Connectivity connectivity = Connectivity();

  Future<void> init() async {
    await localService.init();
    _setupConnectivityListener();
  }

  /// Setup connectivity listener tro trigger sync when online
  void _setupConnectivityListener() {
    connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) async {
      /// If online, trigger sync
      if (!result.contains(ConnectivityResult.none)) {
        /// sync with server logic here
      }
    });
  }

  /// Check if online or not
  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error checking connectivity: $e, StackTrace: $stackTrace');
      return false;
    }
  }

  /// Get All Tasks
  Future<List<Task>> getAllTasks() async {
    try {
      if (await _isOnline()) {
        /// if online, fetch from API
        debugPrint('Device is online. Fetching tasks from API.');
        final apiTasks = await apiService.getAllTasks();

        /// clear all local tasks and save fresh tasks from server
        await localService.saveAllTasks(apiTasks);

        return apiTasks;
      } else {
        // If offline, get tasks from local storage
        debugPrint('Device is offline. Fetching tasks from local storage.');
        return await localService.getAllTasks();
      }
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.getAllTasks: $e, StackTrace: $stackTrace',
      );
      return await localService.getAllTasks();
    }
  }

  /// Delete task
  Future<void> deleteTask(String id) async {
    try {
      await apiService.deleteTask(id);
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.deleteTask: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to delete task in TaskRepository.deleteTask: $e');
    }
  }

  /// Update task
  Future<void> updateTask(Task task) async {
    try {
      await apiService.updateTask(task);
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.updateTask: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to update task in TaskRepository.updateTask: $e');
    }
  }

  /// Create task
  Future<String> createTask(Task task) async {
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
