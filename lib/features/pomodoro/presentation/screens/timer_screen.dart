// lib/features/pomodoro/presentation/screens/timer_screen.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  // Süreyi "dakika:saniye" formatına çeviren yardımcı fonksiyon
  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  // Seans türüne göre metin döndüren yardımcı fonksiyon
  String _getSessionTitle(PomodoroSession session) {
    switch (session) {
      case PomodoroSession.focus:
        return 'Odaklanma Zamanı';
      case PomodoroSession.shortBreak:
        return 'Kısa Mola';
      case PomodoroSession.longBreak:
        return 'Uzun Mola';
    }
  }

  // Seans türüne göre ikon döndüren yardımcı fonksiyon
  IconData _getSessionIcon(PomodoroSession session) {
    switch (session) {
      case PomodoroSession.focus:
        return Icons.psychology_outlined;
      case PomodoroSession.shortBreak:
        return Icons.coffee_outlined;
      case PomodoroSession.longBreak:
        return Icons.self_improvement_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // timerProvider'ı izle ve state'i al
    final timerState = ref.watch(timerProvider);
    // timerProvider'ın notifier'ını (fonksiyonları) al
    final timerNotifier = ref.read(timerProvider.notifier);

    // Toplam süreyi hesapla (ilerleme çubuğu için)
    final totalDuration = timerNotifier.getDurationForSession(timerState.session);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E),
              Color(0xFF0F0C29),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Yıldızlar arka plan
            ...List.generate(50, (index) {
              final random = math.Random(index);
              return Positioned(
                left: random.nextDouble() * 400,
                top: random.nextDouble() * 800,
                child: Container(
                  width: random.nextDouble() * 3 + 1,
                  height: random.nextDouble() * 3 + 1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(random.nextDouble() * 0.8 + 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            }),

            SafeArea(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.withOpacity(0.3),
                                    Colors.blue.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.public,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Planet Study',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
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
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Seans Türü - DİNAMİK
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getSessionIcon(timerState.session),
                          color: Colors.lightBlueAccent.shade200,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getSessionTitle(timerState.session),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Gezegen Timer - DİNAMİK
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dış parlama efekti
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.blue.withOpacity(0.3),
                              Colors.purple.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Ana gezegen çemberi
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withOpacity(0.2),
                              Colors.purple.withOpacity(0.3),
                              Colors.blue.withOpacity(0.2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Progress indicator - DİNAMİK
                            CircularProgressIndicator(
                              value: totalDuration > 0
                                  ? timerState.remainingTime / totalDuration
                                  : 1.0,
                              strokeWidth: 8,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightBlueAccent.shade200,
                              ),
                              strokeCap: StrokeCap.round,
                            ),

                            // Timer metni - DİNAMİK
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatTime(timerState.remainingTime),
                                    style: TextStyle(
                                      fontSize: 68,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.blue.withOpacity(0.5),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'dakika kaldı',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.7),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Kontrol Butonları - DİNAMİK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Skip Butonu
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => timerNotifier.skipSession(),
                          icon: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),

                      // Play/Pause Butonu - DİNAMİK
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.lightBlueAccent.shade200,
                              Colors.blueAccent.shade400,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (timerState.status == TimerStatus.running) {
                              timerNotifier.pauseTimer();
                            } else {
                              timerNotifier.startTimer();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(28),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Icon(
                            timerState.status == TimerStatus.running
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),

                      // Reset Butonu
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => timerNotifier.resetTimer(),
                          icon: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Pomodoro Sayacı - DİNAMİK
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: index < timerState.completedPomodoros % 4
                                  ? Colors.lightBlueAccent.shade200
                                  : Colors.white.withOpacity(0.3),
                            ),
                          );
                        }),
                        const SizedBox(width: 12),
                        Text(
                          '${timerState.completedPomodoros % 4}/4',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Pomodoro',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Görev Seçme Alanı
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.lightBlueAccent.shade200,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Bir görev seç',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white.withOpacity(0.5),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}