import 'package:flutter/material.dart';

import '../models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final String habitTitle;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.habitTitle,
  });

  @override
  Widget build(BuildContext context) {
    final unlockedAt = achievement.unlockedAt;
    final unlocked = unlockedAt != null;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: unlocked
                    ? colors.tertiaryContainer
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                unlocked ? Icons.emoji_events_rounded : Icons.lock_outline,
                color: unlocked ? colors.tertiary : colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    unlocked
                        ? '$habitTitle · Unlocked ${_formatDate(unlockedAt)}'
                        : '$habitTitle · ${achievement.requiredStreakDays}-day streak',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: unlocked ? colors.tertiary : colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            if (unlocked)
              Icon(Icons.check_circle, color: colors.tertiary, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
