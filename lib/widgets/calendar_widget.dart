import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime initialDate;

  const CalendarWidget({
    super.key,
    required this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
