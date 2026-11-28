import 'package:flutter/material.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback? onTap;

  const HabitCard({super.key, required this.habit, this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = habitProvider;
    final completed = provider.isCompletedToday(habit);
    final streak = provider.calculateCurrentStreak(habit);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: completed ? Colors.green.withValues(alpha: .12) :
              Theme.of(context).colorScheme.primary.withValues(alpha: .12),
          child: Icon(completed ? Icons.check : Icons.flag_outlined,
              color: completed ? Colors.green : Theme.of(context).colorScheme.primary),
        ),
        title: Text(habit.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(streak > 0 ? '${streak} day streak' :
            (habit.description.isEmpty ? 'Your daily habit' : habit.description),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          tooltip: completed ? 'Mark as not completed' : 'Mark as completed',
          onPressed: () => provider.toggleHabit(habit.id),
          icon: Icon(completed ? Icons.check_circle : Icons.circle_outlined,
              color: completed ? Colors.green : null, size: 28),
        ),
      ),
    );
  }
}
