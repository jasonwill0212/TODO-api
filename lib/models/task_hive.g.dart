// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskHiveAdapter extends TypeAdapter<TaskHive> {
  @override
  final int typeId = 0;

  @override
  TaskHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHive(
      id: fields[0] as String?,
      description: fields[2] as String,
      needsSync: fields[4] as bool,
      status: fields[3] as String,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.needsSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
