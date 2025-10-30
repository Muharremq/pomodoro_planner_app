import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_planner_app/features/stats/presentation/widgets/daily_cativity_chart.dart';
import 'package:pomodoro_planner_app/features/stats/presentation/widgets/statisticscards.dart';
import 'package:pomodoro_planner_app/features/stats/presentation/widgets/periodselector.dart';
import '../providers/statistics_provider.dart';
import '../widgets/most_productive_day_card.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsState = ref.watch(statisticsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAŞLIK
          const Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 16.0,
              top: 16.0,
              bottom: 12.0,
            ),
            child: Text(
              'Statistics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // DÖNEM SEÇİCİ
          const PeriodSelector(),

          const SizedBox(height: 20),

          // SCROLLABLE İÇERİK
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // İSTATİSTİK KARTLARI
                  StatisticsCards(state: statisticsState),

                  const SizedBox(height: 20),

                  // EN VERİMLİ GÜN KARTI
                  MostProductiveDayCard(state: statisticsState),

                  const SizedBox(height: 20),

                  // GÜNLÜK AKTİVİTE GRAFİĞİ
                  DailyActivityChart(state: statisticsState),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
