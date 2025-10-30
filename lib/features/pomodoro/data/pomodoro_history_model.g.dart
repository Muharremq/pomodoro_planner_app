// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroHistoryAdapter extends TypeAdapter<PomodoroHistory> {
  @override
  final int typeId = 1;

  @override
  PomodoroHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroHistory(
      id: fields[0] as String,
      completedAt: fields[1] as DateTime,
      duration: fields[2] as int,
      taskId: fields[3] as String?,
      sessionType: fields[4] != null
          ? PomodoroSession.values[fields[4] as int]
          : null,
      wasInterrupted: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.taskId)
      ..writeByte(4)
      ..write(obj.sessionTypeIndex)
      ..writeByte(5)
      ..write(obj.wasInterrupted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
