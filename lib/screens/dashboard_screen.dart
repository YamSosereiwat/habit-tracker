import 'package:flutter/material.dart';

import '../providers/habit_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/habit_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/streak_card.dart';
import 'add_habit_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: habitProvider,
      builder: (context, _) {
        final habits = habitProvider.todaysHabits;
        final completed = habitProvider.completedToday;
        final total = habits.length;
        final streak = habitProvider.habits
            .map(habitProvider.calculateCurrentStreak)
            .fold<int>(0, (best, current) => current > best ? current : best);
        final greeting = _greeting();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Habit Tracker'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.spa_outlined,
                    size: 19,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: RefreshIndicator(
                  onRefresh: () async => habitProvider.refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    children: [
                      Text(
                        greeting,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _dateLabel(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 22),
                      ProgressCard(
                        title: "Today's progress",
                        value: '$completed / $total',
                        subtitle: total == 0
                            ? 'Add a habit to begin building your routine.'
                            : '${(completed / total * 100).round()}% of today’s plan complete',
                        progress: total == 0 ? 0 : completed / total,
                        icon: Icons.check_circle_outline,
                      ),
                      const SizedBox(height: 12),
                      StreakCard(
                        streak: streak,
                        subtitle: streak == 0
                            ? 'Complete a habit to start your streak'
                            : 'Keep showing up, one day at a time',
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Today's habits",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          Text(
                            '$total ${total == 1 ? 'habit' : 'habits'}',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (habits.isEmpty)
                        EmptyState(
                          icon: Icons.event_note_outlined,
                          title: 'A fresh start',
                          message:
                              'There are no habits planned for today. Add a habit or update its planned days to see it here.',
                          actionLabel: 'Add a habit',
                          onAction: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddHabitScreen(),
                            ),
                          ),
                        )
                      else
                        ...habits.map((habit) => HabitCard(habit: habit)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _dateLabel(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
