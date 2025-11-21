import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_api/models/task.dart';

class LocalService {
  static const String _taskBoxName = 'taskBox';
  static const String _syncQueueBoxName = 'syncQueueBox';

  /// We have 2 boxes:
  /// 1. taskBox: to store tasks locally
  /// 2. syncQueueBox: to store tasks that need to be synced with the server
  late Box<Task> _taskBox;
  late Box<Map> _syncQueueBox;

  Future<void> init() async {
    debugPrint('Initializing LocalService...');
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    debugPrint(
      'LocalService initialized successfully.: Existing tasks: ${_taskBox.values.length}, Sync queue items: ${_syncQueueBox.values.length}',
    );
  }

  /// Save all tasks from the server to local Hive box
  Future<void> saveAllTasks(List<Task> tasks) async {
    debugPrint('Saving ${tasks.length} tasks to local storage...');
    await _taskBox.clear();
    for (var task in tasks) {
      if (task.id != null) {
        await _taskBox.put(task.id, task);
      }
    }
    debugPrint(
      'All tasks saved locally. Total tasks: ${_taskBox.values.length}',
    );
  }

  /// Get all tasks from local Hive box
  Future<List<Task>> getAllTasks() async {
    debugPrint('Fetching all tasks from local storage...');
    final tasks = _taskBox.values.toList();
    debugPrint('Fetched ${tasks.length} tasks from local storage.');
    return tasks;
  }

  /// DeleteTask by id from local Hive box

  /// /// Add - Save task to sync queue

  //// Update Task

  /// Clear All Tasks

  /// Sync queue operations
  /// Map contains 'task' and 'operation' and 'timestamp'
  /// operations: 'create', 'update', 'delete' -> map with api call when online
  /// task -> data of Task need to save
  /// timestamp -> time of operation
  /// 1 -> 2 -> 3 -> 4 -> 5 -> 6 ... ( queue order need to sync to server )
}
