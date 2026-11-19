import 'package:flutter/material.dart';

import '../models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(achievement.title)),
    );
  }
}
