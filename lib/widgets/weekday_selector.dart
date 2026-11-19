import 'package:flutter/material.dart';

class WeekdaySelector extends StatelessWidget {
  final Set<int> selectedDays;

  const WeekdaySelector({
    super.key,
    required this.selectedDays,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
