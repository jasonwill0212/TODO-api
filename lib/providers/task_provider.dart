import 'package:flutter/material.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository taskRepository = TaskRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  Future<void> getAllTasks() async {
    try {
      _isLoading = true;
      notifyListeners();
      _tasks = await taskRepository.getAllTasks();
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.getAllTasks: $e, StackTrace: $stackTrace',
      );
      _errorMessage = 'Failed to load tasks';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await taskRepository.deleteTask(id);
      await getAllTasks();
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.deleteTask: $e, StackTrace: $stackTrace',
      );
      _errorMessage = 'Failed to delete task';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask({required Task task}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await taskRepository.updateTask(task);
      await getAllTasks();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.updateTask: $e, StackTrace: $stackTrace',
      );
      _errorMessage = 'Failed to update task';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask({required Task task}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await taskRepository.createTask(task);
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.createTask: $e, StackTrace: $stackTrace',
      );
      _errorMessage = 'Failed to create task';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }
}
