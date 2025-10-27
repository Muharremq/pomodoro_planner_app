// lib/features/main/presentation/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

// Doğrudan ekran widget'larını import ediyoruz
import '../../../pomodoro/presentation/screens/timer_screen.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Sayfa listesi artık çok daha temiz. Sadece widget'ları çağırıyoruz.
  final List<Widget> pageOptions = [const TimerScreen(), const TasksScreen()];

  @override
  Widget build(BuildContext context) {
    // build metodu içindeki tüm timer'a özel kodlar kaldırıldı, çünkü
    // onlar artık kendi ekranlarının içinde yönetiliyor.

    return Scaffold(
      backgroundColor: Colors.transparent, // Arka plan Stack'ten gelecek
      body: Stack(
        children: [
          // ARKA PLAN (GRADIENT VE YILDIZLAR)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0F29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                ],
              ),
            ),
          ),
          ...List.generate(50, (index) {
            final random = math.Random(index);
            return Positioned(
              left: random.nextDouble() * MediaQuery.of(context).size.width,
              top: random.nextDouble() * MediaQuery.of(context).size.height,
              child: Container(
                width: random.nextDouble() * 3 + 1,
                height: random.nextDouble() * 3 + 1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    random.nextDouble() * 0.8 + 0.2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // SAYFA İÇERİĞİ
          IndexedStack(index: _selectedIndex, children: pageOptions),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer_rounded),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF0F0C29).withOpacity(0.85),
        selectedItemColor: Colors.cyanAccent.shade400,
        unselectedItemColor: Colors.white54,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
