import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_planner_app/features/pomodoro/data/pomodoro_history_model.dart';
import 'package:pomodoro_planner_app/features/stats/data/statistics_service.dart';

// State'in kendisi (UI'ın ihtiyaç duyduğu tüm veriler)
class StatisticsState {
  final StatisticsPeriod selectedPeriod;
  final int totalFocusTime; // Dakika cinsinden
  final int totalPomodoros;
  final DateTime? mostProductiveDay;
  final List<DailyActivity> dailyActivities;

  StatisticsState({
    this.selectedPeriod = StatisticsPeriod.weekly,
    this.totalFocusTime = 0,
    this.totalPomodoros = 0,
    this.mostProductiveDay,
    this.dailyActivities = const [],
  });
}

// Notifier (State'i yöneten mantık)
class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final StatisticsService _statisticsService;

  StatisticsNotifier(this._statisticsService) : super(StatisticsState()) {
    // Başlangıçta 'Weekly' verilerini yükle
    changePeriod(StatisticsPeriod.weekly);
  }

  void changePeriod(StatisticsPeriod period) {
    // Gerçek verilerle state'i güncelle
    final totalFocusTime = _statisticsService.calculateTotalFocusTime(period);
    final totalPomodoros = _statisticsService.calculateTotalPomodoros(period);
    final mostProductiveDay = _statisticsService.findMostProductiveDay(period);
    final dailyActivities = _statisticsService.getDailyActivityData(period);

    state = StatisticsState(
      selectedPeriod: period,
      totalFocusTime: totalFocusTime,
      totalPomodoros: totalPomodoros,
      mostProductiveDay: mostProductiveDay,
      dailyActivities: dailyActivities,
    );
  }
}

// Provider'ın kendisi
final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
      // Hive box'ını al
      final historyBox = Hive.box<PomodoroHistory>('pomodoro_history');

      // StatisticsService'i oluştur
      final statisticsService = StatisticsService(historyBox);

      return StatisticsNotifier(statisticsService);
    });
