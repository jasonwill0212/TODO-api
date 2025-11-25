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
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    debugPrint('Deleted task with id $id from local storage.');
  }

  /// Add - Save task to sync queue
  Future<String> saveTask(Task task) async {
    final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    await _taskBox.put(key, task.copyWith(id: key));
    debugPrint('Saved task with id $key to local storage.');
    return key;
  }

  //// Update Task
  Future<void> updateTask(Task task) async {
    if (task.id == null) return;
    await _taskBox.put(task.id, task);
    debugPrint('Updated task with id ${task.id} in local storage.');
  }

  /// Clear All Tasks
  Future<void> clearAllTasks() async {
    await _taskBox.clear();
    debugPrint('Cleared all tasks from local storage.');
  }

  /// Sync queue operations
  /// Map contains 'task' and 'operation' and 'timestamp'
  /// operations: 'create', 'update', 'delete' -> map with api call when online
  /// task -> data of Task need to save
  /// timestamp -> time of operation
  /// 1 -> 2 -> 3 -> 4 -> 5 -> 6 ... ( queue order need to sync to server )
  Future<void> addToSyncQueueBox({
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();

    /// Queue item map data
    final queueItem = {
      'operation': operation,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    /// Save data to sync queue
    await _syncQueueBox.put(key, queueItem);
    debugPrint('Added task with id $key to sync queue for $operation.');
  }

  /// Remove from sync queue
  /// Remove task from _syncQueueBox by time stamp
  Future<void> removeFromSyncQueueBox(String timestamp) async {
    /// Find the item with the matching timestamp
    final listMatchingItems = _syncQueueBox.keys.where((dynamic key) {
      final item = _syncQueueBox.get(key);
      return item != null && item['timestamp'] == timestamp;
    }).toList();

    /// Remove all matching items
    for (final key in listMatchingItems) {
      await _syncQueueBox.delete(key);
      debugPrint('Removed task with key $key from sync queue.');
    }
  }

  /// Get Sync Queue Items
  /// Return list of maps from sync queue box -> check if there is any item need to sync
  Future<List<Map<String, dynamic>>> getSyncQueueItems() async {
    /// item represents each item value in the sync queue box
    /// .map to convert each item to Map<String, dynamic>
    return _syncQueueBox.values.map<Map<String, dynamic>>((item) {
      final map = <String, dynamic>{};
      (item).forEach((key, value) {
        map[key.toString()] = value;
      });
      return map;
    }).toList();
  }
}
