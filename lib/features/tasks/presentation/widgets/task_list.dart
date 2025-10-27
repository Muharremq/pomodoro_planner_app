import 'package:flutter/material.dart';
import 'package:pomodoro_planner_app/features/tasks/data/task_model.dart';
import 'package:pomodoro_planner_app/features/tasks/presentation/widgets/task_card.dart';

class TaskList extends StatelessWidget {
  final List<Task> task;

  const TaskList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    if (task.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.task_alt,
                size: 64,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No tasks available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first task to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: task.length,
      itemBuilder: (context, index) {
        final currentTask = task[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TaskCard(task: currentTask),
        );
      },
    );
  }
}
