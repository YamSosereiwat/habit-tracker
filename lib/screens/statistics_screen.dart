import 'package:flutter/material.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_card.dart';
import '../widgets/streak_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _rangeDays = 7;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: habitProvider,
      builder: (context, _) {
        final habits =
            habitProvider.habits.where((habit) => habit.isActive).toList();
        final summary = _summarize(habits, _rangeDays);
        final bestStreak = habits
            .map(habitProvider.calculateCurrentStreak)
            .fold<int>(0, (best, current) => current > best ? current : best);

        return Scaffold(
          appBar: AppBar(title: const Text('Statistics')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  Text(
                    'Small wins add up. Here is your progress.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 7, label: Text('7 days')),
                      ButtonSegment(value: 30, label: Text('30 days')),
                    ],
                    selected: {_rangeDays},
                    onSelectionChanged: (selection) {
                      setState(() => _rangeDays = selection.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (habits.isEmpty)
                    const EmptyState(
                      icon: Icons.insights_outlined,
                      title: 'Your progress starts here',
                      message:
                          'Add habits and record completions to see your streaks and completion rate.',
                    )
                  else ...[
                    ProgressCard(
                      title: 'Completion rate',
                      value: '${(summary.rate * 100).round()}%',
                      subtitle:
                          '${summary.completedDays} of ${summary.plannedDays} planned habit-days completed in the last $_rangeDays days',
                      progress: summary.rate,
                      icon: Icons.show_chart,
                    ),
                    const SizedBox(height: 12),
                    StreakCard(
                      streak: bestStreak,
                      subtitle: bestStreak == 0
                          ? 'Complete planned days to build a streak'
                          : 'Your longest current habit streak',
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Last 7 days',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Completed planned habits by day',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _WeeklyBars(data: _summarizeByDay(habits)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _ProgressSummary _summarize(List<HabitModel> habits, int rangeDays) {
    final today = DateUtils.dateOnly(DateTime.now());
    final start = today.subtract(Duration(days: rangeDays - 1));
    var plannedDays = 0;
    var completedDays = 0;

    for (var offset = 0; offset < rangeDays; offset++) {
      final date = start.add(Duration(days: offset));
      for (final habit in habits) {
        if (!habit.plannedDays.contains(date.weekday)) continue;
        plannedDays++;
        if (habitProvider.isCompletedOn(habit, date)) completedDays++;
      }
    }

    return _ProgressSummary(
      plannedDays: plannedDays,
      completedDays: completedDays,
    );
  }

  List<_ProgressSummary> _summarizeByDay(List<HabitModel> habits) {
    final today = DateUtils.dateOnly(DateTime.now());
    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      var plannedDays = 0;
      var completedDays = 0;
      for (final habit in habits) {
        if (!habit.plannedDays.contains(date.weekday)) continue;
        plannedDays++;
        if (habitProvider.isCompletedOn(habit, date)) completedDays++;
      }
      return _ProgressSummary(
        plannedDays: plannedDays,
        completedDays: completedDays,
      );
    });
  }
}

class _ProgressSummary {
  final int plannedDays;
  final int completedDays;

  const _ProgressSummary({
    required this.plannedDays,
    required this.completedDays,
  });

  double get rate => plannedDays == 0 ? 0 : completedDays / plannedDays;
}

class _WeeklyBars extends StatelessWidget {
  final List<_ProgressSummary> data;

  const _WeeklyBars({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
        child: SizedBox(
          height: 142,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(data.length, (index) {
              final summary = data[index];
              final rate = summary.rate;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                        child: FittedBox(
                          child: Text(
                            summary.plannedDays == 0
                                ? '—'
                                : '${summary.completedDays}/${summary.plannedDays}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: summary.plannedDays == 0
                                ? .06
                                : (rate == 0 ? .08 : rate),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: summary.plannedDays == 0
                                    ? colors.surfaceContainerHighest
                                    : colors.primary,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        labels[index],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
