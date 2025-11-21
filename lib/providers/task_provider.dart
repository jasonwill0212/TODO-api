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

  /// initialize repository
  Future<void> init() async {
    await taskRepository.init();
    await getAllTasks();
  }

  Future<void> getAllTasks() async {
    try {
      _setLoading(true);
      _tasks = await taskRepository.getAllTasks();
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.getAllTasks: $e, StackTrace: $stackTrace',
      );
      setErrorMessage('Failed to load tasks');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      _setLoading(true);
      await taskRepository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.deleteTask: $e, StackTrace: $stackTrace',
      );
      setErrorMessage('Failed to delete task');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask({required Task task}) async {
    try {
      _setLoading(true);
      notifyListeners();
      await taskRepository.updateTask(task);
      final index = _tasks.indexWhere((element) => element.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
        debugPrint('Task updated in provider: ${task.id} - ${task.title}');
      }
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.updateTask: $e, StackTrace: $stackTrace',
      );
      setErrorMessage('Failed to update task');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createTask({required Task task}) async {
    try {
      _setLoading(true);
      final newTaskId = await taskRepository.createTask(task);

      /// get new list after creating task
      final newTask = Task(
        id: newTaskId,
        title: task.title,
        description: task.description,
        status: task.status,
      );
      _tasks.add(newTask);
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskProvider.createTask: $e, StackTrace: $stackTrace',
      );
      setErrorMessage('Failed to create task');
    } finally {
      _setLoading(false);
    }
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void _setLoading(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      debugPrint('Loading state changed: $_isLoading');
      notifyListeners();
    }
  }
}
