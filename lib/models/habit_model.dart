
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

  // Create a new HabitModel with updated values.
  HabitModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    DateTime? createdAt,
    Set<int>? plannedDays,
    bool? isActive,
    List<HabitCompletion>? completions,
    List<Achievement>? achievements,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      plannedDays: plannedDays ?? this.plannedDays,
      isActive: isActive ?? this.isActive,
      completions: completions ?? this.completions,
      achievements: achievements ?? this.achievements,
    );
  }

  // Convert HabitModel into a Map for storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'plannedDays': plannedDays.toList(),
      'isActive': isActive,
      'completions':
          completions.map((item) => item.toMap()).toList(),
      'achievements':
          achievements.map((item) => item.toMap()).toList(),
    };
  }

  // Restore HabitModel from a stored Map.
  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      categoryId: map['categoryId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      plannedDays: Set<int>.from(map['plannedDays']),
      isActive: map['isActive'] as bool,
      completions: (map['completions'] as List).map((item) => HabitCompletion.fromMap(Map<String, dynamic>.from(item),),).toList(),
      achievements: (map['achievements'] as List).map((item) => Achievement.fromMap(Map<String, dynamic>.from(item),),).toList(),
    );
  }
}
