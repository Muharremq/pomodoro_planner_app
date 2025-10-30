import 'package:flutter/material.dart';
import 'package:pomodoro_planner_app/features/stats/data/statistics_service.dart';
import 'dart:math';
import '../providers/statistics_provider.dart';

class DailyActivityChart extends StatelessWidget {
  final StatisticsState state;
  const DailyActivityChart({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.dailyActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: Colors.lightBlueAccent,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Activity Graph',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _CustomBarChart(
            activities: state.dailyActivities,
            period: state.selectedPeriod,
          ),
        ],
      ),
    );
  }
}

class _CustomBarChart extends StatelessWidget {
  final List<DailyActivity> activities;
  final StatisticsPeriod period;

  const _CustomBarChart({required this.activities, required this.period});

  String _getLabel(DateTime date, int index) {
    switch (period) {
      case StatisticsPeriod.daily:
        return '';
      case StatisticsPeriod.weekly:
        const weekdaysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return weekdaysShort[date.weekday - 1];
      case StatisticsPeriod.monthly:
        return 'W${index + 1}';
      case StatisticsPeriod.allTime:
        const monthsShort = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return monthsShort[date.month - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxVal = activities.map((a) => a.pomodoroCount).reduce(max);
    final maxValue = maxVal == 0 ? 1 : maxVal;

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final barHeight = (activity.pomodoroCount / maxValue) * 150.0;

          return _Bar(
            height: barHeight,
            label: _getLabel(activity.date, index),
            value: activity.pomodoroCount,
          );
        }).toList(),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final int value;

  const _Bar({required this.height, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (value > 0)
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          width: 35,
          height: height < 10 ? 10 : height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.cyanAccent.shade400,
                Colors.lightBlueAccent.shade200,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
        ),
      ],
    );
  }
}
