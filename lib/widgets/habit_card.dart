import 'package:flutter/material.dart';

import '../models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;

  const HabitCard({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(habit.title)),
    );
  }
}
