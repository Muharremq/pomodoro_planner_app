// lib/features/stats/data/statistics_models.dart

// Kullanıcının seçebileceği zaman dilimleri
enum StatisticsPeriod { daily, weekly, monthly, allTime }

// Bir güne ait aktivite verisi
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
