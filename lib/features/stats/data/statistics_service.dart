import 'package:collection/collection.dart';
import "package:hive/hive.dart";
import 'package:pomodoro_planner_app/features/pomodoro/data/pomodoro_history_model.dart';
import 'package:pomodoro_planner_app/features/pomodoro/presentation/providers/timer_provider.dart';

enum StatisticsPeriod { daily, weekly, monthly, allTime }

class DailyActivity {
  final DateTime date;
  final int pomodoroCount;
  final int totalMinutes;

  DailyActivity({
    required this.date,
    required this.pomodoroCount,
    required this.totalMinutes,
  });
}

class StatisticsService {
  final Box<PomodoroHistory> _historyBox;

  StatisticsService(this._historyBox);

  // FİLTRELEME
  List<PomodoroHistory> filterByPeriod(StatisticsPeriod period) {
    final now = DateTime.now();
    final allEntries = _historyBox.values
        .where(
          (entry) =>
              !entry.wasInterrupted &&
              entry.sessionType == PomodoroSession.focus,
        )
        .toList();

    switch (period) {
      case StatisticsPeriod.daily:
        return allEntries.where((entry) {
          final completed = entry.completedAt;
          return completed.year == now.year &&
              completed.month == now.month &&
              completed.day == now.day;
        }).toList();
      case StatisticsPeriod.weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        return allEntries.where((entry) {
          final completedDate = entry.completedAt;
          final normalizedCompleted = DateTime(
            completedDate.year,
            completedDate.month,
            completedDate.day,
          );
          final normalizedStart = DateTime(
            startOfWeek.year,
            startOfWeek.month,
            startOfWeek.day,
          );
          final normalizedEnd = DateTime(
            endOfWeek.year,
            endOfWeek.month,
            endOfWeek.day,
          );

          return (normalizedCompleted.isAfter(normalizedStart) ||
                  normalizedCompleted.isAtSameMomentAs(normalizedStart)) &&
              (normalizedCompleted.isBefore(normalizedEnd) ||
                  normalizedCompleted.isAtSameMomentAs(normalizedEnd));
        }).toList();

      case StatisticsPeriod.monthly:
        return allEntries.where((entry) {
          return entry.completedAt.year == now.year &&
              entry.completedAt.month == now.month;
        }).toList();

      case StatisticsPeriod.allTime:
        return allEntries;
      default:
        return [];
    }
  }

  // TOPLAM ODAKLANMA SÜRESİ
  int calculateTotalFocusTime(StatisticsPeriod period) {
    final entries = filterByPeriod(period);
    if (entries.isEmpty) {
      return 0;
    }
    return entries.fold(0, (sum, entry) => sum + entry.duration);
  }

  // TOPLAM POMODORO SAYISI
  int calculateTotalPomodoros(StatisticsPeriod period) {
    final entries = filterByPeriod(period);
    return entries.length;
  }

  // EN VERİMLİ GÜN (Most Productive Day)
  DateTime? findMostProductiveDay(StatisticsPeriod period) {
    final entries = filterByPeriod(period);
    if (entries.isEmpty) {
      return null;
    }

    final groupedByDay = groupBy(entries, (PomodoroHistory entry) {
      return DateTime(
        entry.completedAt.year,
        entry.completedAt.month,
        entry.completedAt.day,
      );
    });

    final dailyTotals = groupedByDay.map((date, historyList) {
      final totalDuration = historyList.fold<int>(
        0,
        (sum, p) => sum + p.duration,
      );
      return MapEntry(date, totalDuration);
    });

    if (dailyTotals.isEmpty) {
      return null;
    }

    final mostProductiveEntry = dailyTotals.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return mostProductiveEntry.key;
  }

  // GÜNLÜK AKTİVİTE VERİSİ
  List<DailyActivity> getDailyActivityData(StatisticsPeriod period) {
    final entries = filterByPeriod(period);
    if (entries.isEmpty) {
      return [];
    }

    final groupedByDay = groupBy(entries, (PomodoroHistory entry) {
      return DateTime(
        entry.completedAt.year,
        entry.completedAt.month,
        entry.completedAt.day,
      );
    });

    final activityList = groupedByDay.entries.map((entry) {
      final date = entry.key;
      final pomodorosForDay = entry.value;

      final totalMinutes = pomodorosForDay.fold<int>(
        0,
        (sum, p) => sum + p.duration,
      );
      final pomodoroCount = pomodorosForDay.length;

      return DailyActivity(
        date: date,
        pomodoroCount: pomodoroCount,
        totalMinutes: totalMinutes,
      );
    }).toList();

    activityList.sort((a, b) => a.date.compareTo(b.date));

    return activityList;
  }
}
