import 'package:flutter/material.dart';

class HabitForm extends StatelessWidget {
  final String title;

  const HabitForm({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
