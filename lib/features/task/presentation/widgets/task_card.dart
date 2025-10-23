import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_planner_app/features/task/data/task_model.dart';
import 'package:pomodoro_planner_app/features/task/presentation/providers/task_provider.dart';
import 'package:pomodoro_planner_app/features/task/presentation/widgets/add_edit_task_dialog.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksNotifier = ref.read(tasksProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  tasksNotifier.toggleTaskCompletion(task.id);
                },
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.lightBlueAccent.shade200;
                  }
                  return Colors.white.withOpacity(0.3);
                }),
                checkColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              // Görev Başlığı ve Açıklaması
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Düzenle Butonu
              IconButton(
                onPressed: () {
                  showAddEditTaskDialog(context, taskToEdit: task);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.lightBlueAccent.shade200,
                    size: 20,
                  ),
                ),
              ),
              // Sil Butonu
              IconButton(
                onPressed: () {
                  tasksNotifier.deleteTask(task.id);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Pomodoro Sayacı ve Progress Bar
          SizedBox(height: 16),
          Row(
            children: [
              // Pomodoro Sayacı
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Eksi Butonu
                    InkWell(
                      onTap: () => tasksNotifier.decrementPomodoro(task.id),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Emoji ve Sayı
                    Text(
                      '🍅 ${task.completedPomodoros} / ${task.targetPomodoros}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Artı Butonu
                    InkWell(
                      onTap: () => tasksNotifier.incrementPomodoro(task.id),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              // İlerleme Çubuğu (Progress Bar)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: task.targetPomodoros > 0
                        ? task.completedPomodoros / task.targetPomodoros
                        : 0,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      task.completedPomodoros >= task.targetPomodoros
                          ? Colors.lightGreenAccent.shade400
                          : Colors.lightBlueAccent.shade200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
