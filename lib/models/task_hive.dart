import 'package:hive/hive.dart';

part 'task_hive.g.dart';

@HiveType(typeId: 0)
class TaskHive extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status;

  @HiveField(4)
  bool needsSync;

  TaskHive({
    this.id,
    required this.description,
    required this.needsSync,
    required this.status,
    required this.title,
  });
}
