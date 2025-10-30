import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_planner_app/features/navigation/presentation/screens/main_screen.dart';
import 'package:pomodoro_planner_app/features/pomodoro/data/pomodoro_history_model.dart';
import 'package:pomodoro_planner_app/features/tasks/data/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Adapter'ları kaydet
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PomodoroHistoryAdapter());

  // Box'ları aç - İSİMLERE DİKKAT!
  await Hive.openBox<Task>('tasksBox');
  await Hive.openBox<PomodoroHistory>(
    'pomodoro_history',
  ); // 'pomodoroHistoryBox' değil!

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F0C29),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planet Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}
