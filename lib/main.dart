import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/pomodoro/presentation/screens/timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Sistem UI'ını özelleştir (opsiyonel)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F0C29),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planet Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: TimerScreen(),
    );
  }
}