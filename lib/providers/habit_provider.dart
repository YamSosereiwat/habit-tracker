import 'package:flutter/material.dart';

import '../models/habit_model.dart';
import '../models/habit_completion.dart';

class HabitProvider extends ChangeNotifier {
  final List<HabitModel> _habits = [];

  List<HabitModel> get habits => List.unmodifiable(_habits);

  List<HabitModel> get todaysHabits {
    final weekday = DateTime.now().weekday;
    return _habits
        .where((habit) => habit.isActive && habit.plannedDays.contains(weekday))
        .toList();
  }

  int get completedToday =>
      todaysHabits.where(isCompletedToday).length;

  void addHabit(HabitModel habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void updateHabit(HabitModel habit) {
    final index = _habits.indexWhere((item) => item.id == habit.id);
    if (index == -1) return;
    _habits[index] = habit;
    notifyListeners();
  }

  void deleteHabit(String habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  bool isCompletedToday(HabitModel habit) =>
      isCompletedOn(habit, DateTime.now());

  bool isCompletedOn(HabitModel habit, DateTime date) {
    return habit.completions.any((completion) {
      final completed = completion.completedAt;
      return completed.year == date.year &&
          completed.month == date.month &&
          completed.day == date.day;
    });
  }

  void toggleHabit(String habitId) {
    final index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final completions = List<HabitCompletion>.from(habit.completions);
    if (isCompletedToday(habit)) {
      completions.removeWhere((completion) {
        final completed = completion.completedAt;
        final today = DateTime.now();
        return completed.year == today.year &&
            completed.month == today.month &&
            completed.day == today.day;
      });
    } else {
      final now = DateTime.now();
      completions.add(HabitCompletion(completedAt: now));
    }

    _habits[index] = HabitModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      categoryId: habit.categoryId,
      createdAt: habit.createdAt,
      plannedDays: habit.plannedDays,
      isActive: habit.isActive,
      completions: completions,
      achievements: habit.achievements,
    );
    notifyListeners();
  }

  int calculateCurrentStreak(HabitModel habit) {
    var date = DateTime.now();
    var streak = 0;

    if (!isCompletedOn(habit, date)) {
      date = date.subtract(const Duration(days: 1));
    }

    while (isCompletedOn(habit, date)) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

final habitProvider = HabitProvider();
