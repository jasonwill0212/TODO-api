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
        if (await hasPendingSyncOperations()) {
          /// There are pending operations to sync
          debugPrint(
            'Device is online. Syncing pending operations with server.',
          );
          await syncPendingOperationsWithServer();
        } else {
          debugPrint('Device is online. No pending operations to sync.');
        }
      }
    });
  }

  /// Check if there are any pending sync operations
  Future<bool> hasPendingSyncOperations() async {
    final syncQueueBox = await localService.getSyncQueueItems();
    return syncQueueBox.isNotEmpty;
  }

  /// Sync all pending operations with the server
  Future<void> syncPendingOperationsWithServer() async {
    if (!await _isOnline()) {
      debugPrint('Device is offline. Cannot sync pending operations.');
      return;
    }

    try {
      /// Get all pending operations item from sync queue box
      final syncQueueItems = await localService.getSyncQueueItems();
      if (syncQueueItems.isEmpty) {
        debugPrint('No pending operations to sync.');
        return;
      }

      /// Process each operation in the queue
      for (final item in syncQueueItems) {
        /// -> api create , update, delete
        final operation = item['operation'] as String;
        final data = item['data'] as Map<String, dynamic>;
        final timestamp = item['timestamp'] as String;

        /// Perform the operation based on its type
        try {
          switch (operation) {
            case 'create':
              final task = Task.fromJson(data);
              await apiService.createTask(task);
              break;

            case 'update':
              final task = Task.fromJson(data);
              await apiService.updateTask(task);
              break;

            case 'delete':
              final taskId = data['id'] as String;
              await apiService.deleteTask(taskId);
              break;
          }

          /// Remove from sync queue after successful operation
          await localService.removeFromSyncQueueBox(timestamp);
          debugPrint(
            'Successfully synced operation $operation for task ${data['id']} with server.',
          );
        } catch (e, stackTrace) {
          debugPrint(
            'Error processing operation $operation for task ${data['id']}: $e, StackTrace: $stackTrace',
          );
          // Optionally, you can choose to continue or break based on the error
          continue; // Continue with the next operation
        }
      }
    } catch (e, stackTrace) {
      debugPrint(
        'Error syncing pending operations: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to sync pending operations: $e');
    }
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
      if (await _isOnline()) {
        await apiService.deleteTask(id);
        await localService.deleteTask(id);
        debugPrint(
          'TaskRepository (deleteTask): Task with id $id deleted from server.',
        );
      } else {
        await localService.deleteTask(id);

        /// After deleting locally, add to sync queue -> online sync logic
        await localService.addToSyncQueueBox(
          operation: 'delete',
          data: {'id': id},
        );
        debugPrint(
          'TaskRepository (deleteTask): Task with id $id deleted from local storage.',
        );
      }
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
      if (await _isOnline()) {
        await apiService.updateTask(task);
        await localService.updateTask(task);
        debugPrint(
          'TaskRepository (updateTask): Task with id ${task.id} updated on server.',
        );
      } else {
        await localService.updateTask(task);

        /// After updating locally, add to sync queue -> online sync logic
        await localService.addToSyncQueueBox(
          operation: 'update',
          data: task.toJson(),
        );
        debugPrint(
          'TaskRepository (updateTask): Task with id ${task.id} updated in local storage.',
        );
      }
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
      if (await _isOnline()) {
        final apiTaskId = await apiService.createTask(task);
        await localService.saveTask(task.copyWith(id: apiTaskId));
        debugPrint(
          'TaskRepository (createTask): Task with id $apiTaskId created on server.',
        );
        return apiTaskId;
      } else {
        /// If not online, save to local and add to sync queue
        final localId = await localService.saveTask(task);
        await localService.addToSyncQueueBox(
          operation: 'create',
          data: task.copyWith(id: localId).toJson(),
        );
        debugPrint(
          'TaskRepository (createTask): Task with local id $localId created in local storage.',
        );
        return localId;
      }
    } catch (e, stackTrace) {
      debugPrint(
        'Error in TaskRepository.createTask: $e, StackTrace: $stackTrace',
      );
      throw Exception('Failed to create task in TaskRepository.createTask: $e');
    }
  }
}
