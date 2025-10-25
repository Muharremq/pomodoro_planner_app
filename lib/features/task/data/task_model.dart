import 'package:hive/hive.dart';

part 'task_model.g.dart'; // Bu satır, oluşturulacak olan adaptör dosyasına işaret eder.

@HiveType(typeId: 0) // Her Hive nesnesi için benzersiz bir typeId gereklidir.
class Task {
  @HiveField(
    0,
  ) // Her alan için benzersiz ve sıralı bir indeks numarası verilir.
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int targetPomodoros;

  @HiveField(4)
  final int completedPomodoros;

  @HiveField(5)
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.targetPomodoros,
    required this.completedPomodoros,
    required this.isCompleted,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    int? targetPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetPomodoros: targetPomodoros ?? this.targetPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
