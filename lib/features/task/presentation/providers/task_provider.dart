import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod/riverpod.dart';
import '../../data/task_model.dart';
// İstatistikler için oluşturduğumuz yeni PomodoroHistory modelini import ediyoruz.
// Bu dosyanın kendi projenizdeki doğru yolda olduğundan emin olun.
import '../../../pomodoro/data/pomodoro_history_model.dart';

class TasksNotifier extends Notifier<List<Task>> {
  // Hive veritabanındaki 'tasksBox' isimli kutuya erişim sağlıyoruz.
  // Bu ismin main.dart'ta açtığınız kutu ile aynı olması KRİTİKTİR.
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');

  // Pomodoro geçmişini tutacağımız 'pomodoro_history' kutusuna erişim sağlıyoruz.
  final Box<PomodoroHistory> _historyBox = Hive.box<PomodoroHistory>(
    'pomodoro_history',
  );

  @override
  List<Task> build() {
    // Uygulama ilk açıldığında veya provider ilk kez okunduğunda,
    // state'i hard-coded liste yerine doğrudan veritabanındaki görevlerle başlatıyoruz.
    return _taskBox.values.toList();
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
    // 1. Yeni görevi veritabanına ekliyoruz. Anahtar olarak görevin id'sini kullanıyoruz.
    _taskBox.put(newTask.id, newTask);
    // 2. State'i, veritabanının güncel haliyle yeniden oluşturuyoruz.
    state = _taskBox.values.toList();
  }

  void editTask({
    required String taskId,
    required String newTitle,
    required String newDescription,
    required int newTargetPomodoros,
  }) {
    // Düzenlenecek görevi state üzerinden buluyoruz.
    final taskToEdit = state.firstWhere((task) => task.id == taskId);

    // copyWith ile güncel bilgileri içeren yeni bir nesne oluşturuyoruz.
    final updatedTask = taskToEdit.copyWith(
      title: newTitle,
      description: newDescription,
      targetPomodoros: newTargetPomodoros,
    );

    // 1. Güncellenmiş görevi, aynı id ile veritabanına yazarak eskisinin üzerine yazıyoruz.
    _taskBox.put(taskId, updatedTask);
    // 2. State'i güncelliyoruz.
    state = _taskBox.values.toList();
  }

  void deleteTask(String taskId) {
    // 1. Görevi veritabanından siliyoruz.
    _taskBox.delete(taskId);
    // 2. State'i güncelliyoruz.
    state = _taskBox.values.toList();
  }

  void toggleTaskCompletion(String taskId) {
    final taskToToggle = state.firstWhere((task) => task.id == taskId);
    final updatedTask = taskToToggle.copyWith(
      isCompleted: !taskToToggle.isCompleted,
    );

    _taskBox.put(taskId, updatedTask);
    state = _taskBox.values.toList();
  }

  void incrementPomodoro(String taskId) {
    final task = state.firstWhere((t) => t.id == taskId);
    if (task.completedPomodoros < task.targetPomodoros) {
      final updatedTask = task.copyWith(
        completedPomodoros: task.completedPomodoros + 1,
      );
      _taskBox.put(taskId, updatedTask);
      state = _taskBox.values.toList();
    }
  }

  void decrementPomodoro(String taskId) {
    final task = state.firstWhere((t) => t.id == taskId);
    if (task.completedPomodoros > 0) {
      final updatedTask = task.copyWith(
        completedPomodoros: task.completedPomodoros - 1,
      );
      _taskBox.put(taskId, updatedTask);
      state = _taskBox.values.toList();
    }
  }

  /// Bir Pomodoro seansı başarıyla tamamlandığında çağrılacak yeni metot.
  /// Bu metot hem görevin pomodoro sayısını artırır hem de istatistik için kayıt oluşturur.
  void logCompletedPomodoro({
    required String taskId,
    required int durationInMinutes,
  }) {
    // --- 1. Görevi Güncelleme ---
    final taskToUpdate = state.firstWhere((task) => task.id == taskId);

    // Sadece hedef sayıya ulaşılmadıysa artır.
    if (taskToUpdate.completedPomodoros < taskToUpdate.targetPomodoros) {
      final updatedTask = taskToUpdate.copyWith(
        completedPomodoros: taskToUpdate.completedPomodoros + 1,
      );
      _taskBox.put(taskId, updatedTask);
    }

    // --- 2. Geçmiş Kaydı Oluşturma ---
    final newHistoryEntry = PomodoroHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      completedAt: DateTime.now(),
      duration: durationInMinutes,
      taskId: taskId,
    );
    _historyBox.put(newHistoryEntry.id, newHistoryEntry);

    // --- 3. State'i Güncelleme ---
    // Görev güncellendiği için UI'ın haberdar olması gerekir.
    state = _taskBox.values.toList();
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);
