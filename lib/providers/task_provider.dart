import 'package:flutter/material.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/repositories/task_repository.dart';

// class TaskProvider extends ChangeNotifier {
//   int counter = 0;
//   int age = 15;

//   void increment() {
//     counter++;
//     notifyListeners();
//   }

//   void decrement() {
//     counter--;
//     notifyListeners();
//   }

//   void increaseAge() {
//     age++;
//     notifyListeners();
//   }

//   void decreaseAge() {
//     age--;
//     notifyListeners();
//   }
// }

class TaskProvider extends ChangeNotifier {
  final TaskRepository taskRepository = TaskRepository();

  /// Define status
  /// private variable -> encapsulated OOP
  /// gettter and setter
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  /// pending task and completed task can be derived from _tasks
  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  /// Get All Tasks
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
      _errorMessage = 'Failed to get all tasks in TaskProvider.getAllTasks: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create task
  ///
  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      _isLoading = true;
      notifyListeners();
      // _tasks = await taskRepository.deleteTask(taskId);
      /// do something
      /// getAllTasks() again
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.getAllTasks: $e, StackTrace: $stackTrace',
      );
      _errorMessage = 'Failed to get all tasks in TaskProvider.deleteTask: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Edit task
}
