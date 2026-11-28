import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../widgets/achievement_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const _definitions = <Achievement>[
    Achievement(
      id: 'on_fire',
      title: 'On Fire',
      description: 'Complete 3 planned days in a row.',
      requiredStreakDays: 3,
    ),
    Achievement(
      id: 'week_warrior',
      title: 'Week Warrior',
      description: 'Complete 7 planned days in a row.',
      requiredStreakDays: 7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: habitProvider,
      builder: (context, _) {
        final habits = habitProvider.habits;
        final items = <_AchievementItem>[
          for (final habit in habits)
            for (final definition in _definitions)
              _AchievementItem(
                habitTitle: habit.title,
                achievement: definition,
                unlockedAt: _findAchievement(habit, definition.id)?.unlockedAt,
              ),
        ];
        final unlocked = items.where((item) => item.unlockedAt != null).length;
        final progress = items.isEmpty ? 0.0 : unlocked / items.length;

        return Scaffold(
          appBar: AppBar(title: const Text('Achievements')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: habits.isEmpty
                  ? ListView(
                      children: [
                        const EmptyState(
                          icon: Icons.emoji_events_outlined,
                          title: 'Your first award is waiting',
                          message: 'Keep up with your planned habits to unlock achievements and celebrate your progress.',
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                      children: [
                        Text(
                          'Celebrate the effort behind every streak.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 18),
                        ProgressCard(
                          title: 'Awards unlocked',
                          value: '$unlocked / ${items.length}',
                          subtitle: unlocked == 0
                              ? 'Complete 3 planned days in a row to earn your first award.'
                              : 'Every planned-day streak is worth celebrating.',
                          progress: progress,
                          icon: Icons.emoji_events_outlined,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Your achievements',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: AchievementCard(
                              achievement: Achievement(
                                id: item.achievement.id,
                                title: item.achievement.title,
                                description: item.achievement.description,
                                requiredStreakDays:
                                    item.achievement.requiredStreakDays,
                                unlockedAt: item.unlockedAt,
                              ),
                              habitTitle: item.habitTitle,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Achievement? _findAchievement(HabitModel habit, String id) {
    for (final achievement in habit.achievements) {
      if (achievement.id == id) return achievement;
    }
    return null;
  }
}

class _AchievementItem {
  final String habitTitle;
  final Achievement achievement;
  final DateTime? unlockedAt;

  const _AchievementItem({
    required this.habitTitle,
    required this.achievement,
    required this.unlockedAt,
  });
}
