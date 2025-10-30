// lib/features/task/presentation/screens/tasks_screen.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_planner_app/features/tasks/presentation/providers/task_provider.dart';
import 'package:pomodoro_planner_app/features/tasks/presentation/widgets/task_list.dart';
import '../widgets/add_edit_task_dialog.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(tasksProvider);
    final activeTasks = allTasks.where((task) => !task.isCompleted).toList();
    final completedTasks = allTasks.where((task) => task.isCompleted).toList();

    // "No tasks available" mesajını gösteren yardımcı widget
    Widget buildEmptyState() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white.withOpacity(0.4),
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No tasks available",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Create your first task to get started",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAŞLIK VE BUTON BÖLÜMÜ
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 16.0,
                top: 16.0,
                bottom: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Task'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      showAddEditTaskDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // SEKMELER (TAB BAR)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  labelColor: const Color(0xFF0F0C29), // Seçili metin rengi
                  unselectedLabelColor: Colors.white.withOpacity(
                    0.8,
                  ), // Seçili olmayan metin rengi
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent.shade100, Colors.white],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(child: Text('Active (${activeTasks.length})')),
                    Tab(child: Text('Completed (${completedTasks.length})')),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // GÖREV LİSTELERİ
            Expanded(
              child: TabBarView(
                children: [
                  activeTasks.isEmpty
                      ? buildEmptyState()
                      : TaskList(task: activeTasks),
                  completedTasks.isEmpty
                      ? buildEmptyState()
                      : TaskList(task: completedTasks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
