import 'achievement.dart';
import 'habit_completion.dart';

class HabitModel {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final DateTime createdAt;
  final Set<int> plannedDays;
  final bool isActive;
  final List<HabitCompletion> completions;
  final List<Achievement> achievements;

  const HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.plannedDays,
    required this.isActive,
    required this.completions,
    required this.achievements,
  });
}
