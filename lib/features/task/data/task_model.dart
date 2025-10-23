class Task {
  final String id;
  final String title;
  final String description;
  final int targetPomodoros;
  final int completedPomodoros;
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
