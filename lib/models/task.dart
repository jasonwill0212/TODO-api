import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String? id;
  final String title;
  final String description;
  final String status;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.status = 'pendiente',
  });

  bool get isCompleted => status == 'completada';
  bool get isPending => status == 'pendiente';

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
