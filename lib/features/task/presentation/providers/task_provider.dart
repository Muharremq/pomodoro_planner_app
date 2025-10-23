import 'package:riverpod/riverpod.dart';
import '../../data/task_model.dart';

class TasksNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    return [
      Task(
        id: '1',
        title: 'Design landing page mockups',
        description: 'Focus on hero section and CTA placement',
        targetPomodoros: 5,
        completedPomodoros: 2,
        isCompleted: false,
      ),
      Task(
        id: '2',
        title: 'Prepare weekly presentation',
        description: '',
        targetPomodoros: 4,
        completedPomodoros: 1,
        isCompleted: false,
      ),
      Task(
        id: '3',
        title: 'Update dependencies',
        description: 'Check for new package versions',
        targetPomodoros: 2,
        completedPomodoros: 2,
        isCompleted: true,
      ),
    ];
  }

  void addTask(String title, String description, int targetPomodoros) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      targetPomodoros: targetPomodoros,
      completedPomodoros: 0,
      isCompleted: false,
    );
    state = [...state, newTask];
  }

  void editTask({
    required String taskId,
    required String newTitle,
    required String newDescription,
    required int newTargetPomodoros,
  }) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            title: newTitle,
            description: newDescription,
            targetPomodoros: newTargetPomodoros,
          )
        else
          task,
    ];
  }

  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  void toggleTaskCompletion(String taskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(isCompleted: !task.isCompleted)
        else
          task,
    ];
  }

  void incrementPomodoro(String taskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          if (task.completedPomodoros < task.targetPomodoros)
            task.copyWith(completedPomodoros: task.completedPomodoros + 1)
          else
            task
        else
          task,
    ];
  }

  void decrementPomodoro(String taskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          if (task.completedPomodoros > 0)
            task.copyWith(completedPomodoros: task.completedPomodoros - 1)
          else
            task
        else
          task,
    ];
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);
