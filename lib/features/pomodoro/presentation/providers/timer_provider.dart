import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerStatus { initial, running, paused }

enum PomodoroSession { focus, shortBreak, longBreak }

class TimerState {
  final int remainingTime;
  final TimerStatus status;
  final PomodoroSession session;
  final int completedPomodoros;

  const TimerState({
    required this.remainingTime,
    required this.status,
    required this.session,
    required this.completedPomodoros,
  });

  TimerState copyWith({
    int? remainingTime,
    TimerStatus? status,
    PomodoroSession? session,
    int? completedPomodoros,
  }) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      session: session ?? this.session,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
    );
  }
}

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  final int _focusDuration = 25 * 60;
  final int _shortBreakDuration = 5 * 60;
  final int _longBreakDuration = 15 * 60;

  @override
  TimerState build() {
    return TimerState(
      remainingTime: _focusDuration,
      status: TimerStatus.initial,
      session: PomodoroSession.focus,
      completedPomodoros: 0,
    );
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
    int currentCompleted = state.completedPomodoros;
    if (state.session == PomodoroSession.focus && skipped) {
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

    // TODO: Otomatik başlatma ayarı açıksa startTimer() çağrılacak
    // TODO: Bildirim ve ses çalma işlemleri burada yapılacak
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
