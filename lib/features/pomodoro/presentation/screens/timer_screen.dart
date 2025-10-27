// lib/features/pomodoro/presentation/screens/timer_screen.dart

import 'package:flutter/material.dart';
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
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final totalDuration = timerNotifier.getDurationForSession(
      timerState.session,
    );

    return SafeArea(
      child: Column(
        children: [
          // BAŞLIK (TasksScreen ile aynı stilde)
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 16.0,
              top: 16.0,
              bottom: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Planet Focus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32, // Görevler ekranı ile aynı font boyutu
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // SEANS TÜRÜ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getSessionIcon(timerState.session),
                  color: Colors.lightBlueAccent.shade100,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  _getSessionTitle(timerState.session),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // ZAMANLAYICI
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: totalDuration > 0
                      ? timerState.remainingTime / totalDuration
                      : 1.0,
                  strokeWidth: 12,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.cyanAccent.shade400,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                _formatTime(timerState.remainingTime),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // KONTROL BUTONLARI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: timerNotifier.skipSession,
                icon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (timerState.status == TimerStatus.running)
                    timerNotifier.pauseTimer();
                  else
                    timerNotifier.startTimer();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(28),
                  backgroundColor: Colors.cyanAccent.shade400,
                  foregroundColor: Colors.blue.shade900,
                ),
                child: Icon(
                  timerState.status == TimerStatus.running
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 48,
                  color: const Color(0xFF0F0C29),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: timerNotifier.resetTimer,
                icon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
