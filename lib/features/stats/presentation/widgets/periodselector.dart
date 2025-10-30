import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_planner_app/features/stats/data/statistics_service.dart';
import '../providers/statistics_provider.dart';

class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsProvider);
    final notifier = ref.read(statisticsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildButton('Today', StatisticsPeriod.daily, state, notifier),
            _buildButton('Week', StatisticsPeriod.weekly, state, notifier),
            _buildButton('Month', StatisticsPeriod.monthly, state, notifier),
            _buildButton('All', StatisticsPeriod.allTime, state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String label,
    StatisticsPeriod period,
    StatisticsState state,
    StatisticsNotifier notifier,
  ) {
    final isSelected = state.selectedPeriod == period;

    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.changePeriod(period),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.lightBlueAccent.shade100, Colors.white],
                  )
                : null,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF0F0C29)
                    : Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
