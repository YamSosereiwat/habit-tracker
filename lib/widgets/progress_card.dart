import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String title;

  const ProgressCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(title));
  }
}
