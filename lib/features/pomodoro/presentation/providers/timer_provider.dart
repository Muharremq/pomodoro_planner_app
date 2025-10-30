import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/pomodoro_history_model.dart';

enum TimerStatus { initial, running, paused }

enum PomodoroSession { focus, shortBreak, longBreak }

class TimerState {
  final int remainingTime;
  final TimerStatus status;
  final PomodoroSession session;
  final int completedPomodoros;
  final String? currentTaskId; // Hangi görev için çalışıldığını takip et

  const TimerState({
    required this.remainingTime,
    required this.status,
    required this.session,
    required this.completedPomodoros,
    this.currentTaskId,
  });

  TimerState copyWith({
    int? remainingTime,
    TimerStatus? status,
    PomodoroSession? session,
    int? completedPomodoros,
    String? currentTaskId,
  }) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      session: session ?? this.session,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      currentTaskId: currentTaskId ?? this.currentTaskId,
    );
  }
}

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  final int _focusDuration = 25 * 60;
  final int _shortBreakDuration = 5 * 60;
  final int _longBreakDuration = 15 * 60;

  // Hive box'ı tanımla
  late Box<PomodoroHistory> _historyBox;

  @override
  TimerState build() {
    // Box'ı al
    _historyBox = Hive.box<PomodoroHistory>('pomodoro_history');

    return TimerState(
      remainingTime: _focusDuration,
      status: TimerStatus.initial,
      session: PomodoroSession.focus,
      completedPomodoros: 0,
    );
  }

  // Görev seçme metodu
  void setCurrentTask(String? taskId) {
    state = state.copyWith(currentTaskId: taskId);
  }

  void startTimer() {
    if (state.status == TimerStatus.running) return;
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      } else {
        _sessionCompleted();
      }
    });
  }

  void pauseTimer() {
    if (state.status != TimerStatus.running) return;
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resetTimer() {
    _timer?.cancel();
    state = state.copyWith(
      remainingTime: getDurationForSession(state.session),
      status: TimerStatus.initial,
    );
  }

  void skipSession() {
    _timer?.cancel();
    _sessionCompleted(skipped: true);
  }

  void _sessionCompleted({bool skipped = false}) {
    _timer?.cancel();

    // Eğer focus seansı başarıyla tamamlandıysa kaydet
    if (state.session == PomodoroSession.focus && !skipped) {
      _savePomodoroHistory(wasInterrupted: false);
    }

    int currentCompleted = state.completedPomodoros;
    if (state.session == PomodoroSession.focus && !skipped) {
      currentCompleted++;
    }

    PomodoroSession nextSession;
    if (currentCompleted > 0 && currentCompleted % 4 == 0) {
      nextSession = PomodoroSession.longBreak;
    } else if (state.session == PomodoroSession.focus) {
      nextSession = PomodoroSession.shortBreak;
    } else {
      nextSession = PomodoroSession.focus;
    }

    state = state.copyWith(
      session: nextSession,
      remainingTime: getDurationForSession(nextSession),
      status: TimerStatus.initial,
      completedPomodoros: nextSession == PomodoroSession.focus
          ? currentCompleted
          : state.completedPomodoros,
    );
  }

  // Pomodoro geçmişini kaydetme
  void _savePomodoroHistory({required bool wasInterrupted}) {
    final newHistory = PomodoroHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      completedAt: DateTime.now(),
      duration: _focusDuration ~/ 60, // Dakika cinsinden
      taskId: state.currentTaskId,
      sessionType: state.session,
      wasInterrupted: wasInterrupted,
    );

    _historyBox.put(newHistory.id, newHistory);

    // Eğer görev varsa, task provider'a bildir
    if (state.currentTaskId != null) {
      // TasksNotifier'ın logCompletedPomodoro metodunu çağır
      // Bu, ref.read(tasksProvider.notifier) ile yapılabilir
      // Ancak burada ref'e erişimimiz yok, bu yüzden alternatif yol:
      // TasksNotifier'da direkt Hive'a erişim zaten var
    }
  }

  // Zamanlayıcıyı iptal etme (kullanıcı durdurunca)
  void interruptTimer() {
    if (state.status == TimerStatus.running &&
        state.session == PomodoroSession.focus) {
      // Yarım kalan pomodoro'yu kaydet
      _savePomodoroHistory(wasInterrupted: true);
    }
    resetTimer();
  }

  int getDurationForSession(PomodoroSession session) {
    switch (session) {
      case PomodoroSession.focus:
        return _focusDuration;
      case PomodoroSession.shortBreak:
        return _shortBreakDuration;
      case PomodoroSession.longBreak:
        return _longBreakDuration;
    }
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);
