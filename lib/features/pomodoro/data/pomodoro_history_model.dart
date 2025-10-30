import 'package:hive/hive.dart';
import 'package:pomodoro_planner_app/features/pomodoro/presentation/providers/timer_provider.dart';
import 'package:collection/collection.dart';
part 'pomodoro_history_model.g.dart';

@HiveType(typeId: 1)
class PomodoroHistory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime completedAt;

  @HiveField(2)
  final int duration; // dakika cinsinden

  @HiveField(3)
  final String? taskId; // Görevsiz olabilir, bu yüzden nullable (?)

  @HiveField(4)
  final int sessionTypeIndex; // PomodoroSession enum'unu int olarak sakla

  @HiveField(5)
  final bool wasInterrupted;

  PomodoroHistory({
    required this.id,
    required this.completedAt,
    required this.duration,
    this.taskId,
    PomodoroSession? sessionType,
    this.wasInterrupted = false,
  }) : sessionTypeIndex = (sessionType ?? PomodoroSession.focus).index;

  // Enum'u kolayca almak için getter
  PomodoroSession get sessionType => PomodoroSession.values[sessionTypeIndex];
}

class PomodoroAnalytics {
  final List<PomodoroHistory> history;

  PomodoroAnalytics({required this.history});

  // GÜNLÜK TOPLAM SÜRE HESAPLAMA
  int calculateDailyPomodoros(DateTime? date) {
    final targetDate = date ?? DateTime.now();

    final dailyPomodoros = history.where(
      (p) =>
          !p.wasInterrupted &&
          p.completedAt.year == targetDate.year &&
          p.completedAt.month == targetDate.month &&
          p.completedAt.day == targetDate.day,
    );

    if (dailyPomodoros.isEmpty) {
      return 0;
    }

    final totalMinutes = dailyPomodoros.fold<int>(
      0,
      (previousValue, pomodoro) => previousValue + pomodoro.duration,
    );
    return totalMinutes;
  }

  // HAFTALIK TOPLAM SÜRE HESAPLAMA
  int calculateWeeklyPomodoros(DateTime? date) {
    final targetDate = date ?? DateTime.now();

    // Hedef tarihin bulunduğu haftanın ilk gününü (Pazartesi) bulur.
    final startOfWeek = targetDate.subtract(
      Duration(days: targetDate.weekday - 1),
    );
    // Haftanın son gününü (Pazar) bulur.
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Geçmişi, haftanın başlangıç ve bitiş tarihleri arasına göre filtreler.
    final weeklyPomodoros = history.where((p) {
      final completedDate = p.completedAt;
      return !p.wasInterrupted &&
          (completedDate.isAfter(startOfWeek) ||
              isSameDate(completedDate, startOfWeek)) &&
          (completedDate.isBefore(endOfWeek) ||
              isSameDate(completedDate, endOfWeek));
    });

    if (weeklyPomodoros.isEmpty) {
      return 0;
    }
    return weeklyPomodoros.fold<int>(
      0,
      (previousValue, pomodoro) => previousValue + pomodoro.duration,
    );
  }

  // AYLIK TOPLAM SÜRE HESAPLAMA
  int calculateMonthlyPomodoros(DateTime? date) {
    final targetDate = date ?? DateTime.now();

    final monthlyPomodoros = history.where(
      (p) =>
          !p.wasInterrupted &&
          p.completedAt.year == targetDate.year &&
          p.completedAt.month == targetDate.month,
    );

    if (monthlyPomodoros.isEmpty) {
      return 0;
    }

    // Filtrelenmiş pomodoroların sürelerini toplayarak sonucu döndürür.
    return monthlyPomodoros.fold<int>(
      0,
      (previousValue, pomodoro) => previousValue + pomodoro.duration,
    );
  }

  // EN VERİMLİ GÜNÜ BULMA
  Map<String, dynamic>? findMostProductiveDay() {
    final completedPomodoros = history.where((p) => !p.wasInterrupted);

    if (completedPomodoros.isEmpty) {
      return null;
    }

    // Pomodoroları tamamlandıkları güne göre gruplar.
    final groupedByDay = groupBy(
      completedPomodoros,
      (PomodoroHistory p) =>
          '${p.completedAt.year}-${p.completedAt.month.toString().padLeft(2, '0')}-${p.completedAt.day.toString().padLeft(2, '0')}',
    );

    // Her bir gün için toplam süreyi hesaplar.
    final dailyTotals = groupedByDay.map((date, pomodoros) {
      final totalDuration = pomodoros.fold<int>(
        0,
        (sum, p) => sum + p.duration,
      );
      return MapEntry(date, totalDuration);
    });

    if (dailyTotals.isEmpty) {
      return null;
    }

    // En yüksek süreye sahip günü bulur.
    final mostProductiveEntry = dailyTotals.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return {
      'date': mostProductiveEntry.key,
      'totalDuration': mostProductiveEntry.value,
    };
  }

  // İki DateTime nesnesinin aynı gün, ay ve yılda olup olmadığını kontrol eden yardımcı fonksiyon.
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
