import 'package:hive/hive.dart';

part 'pomodoro_history_model.g.dart';

@HiveType(typeId: 1) // typeId'ler benzersiz olmalı (Task için 0 kullanmıştık)
class PomodoroHistory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime completedAt;

  @HiveField(2)
  final int duration; // dakika cinsinden

  @HiveField(3)
  final String? taskId; // Görevsiz olabilir, bu yüzden nullable (?)

  PomodoroHistory({
    required this.id,
    required this.completedAt,
    required this.duration,
    this.taskId,
  });
}
