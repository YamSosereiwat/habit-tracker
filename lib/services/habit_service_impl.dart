import '../models/habit_completion.dart';
import '../models/habit_model.dart';
import 'habit_service.dart';

class HabitServiceImpl implements HabitService {
  final List<HabitModel> _habits = [];

  void _validateHabit(HabitModel habit) {
    if (habit.id.trim().isEmpty) {
      throw ArgumentError('Habit ID cannot be empty');
    }

    if (habit.title.trim().isEmpty) {
      throw ArgumentError('Habit title cannot be empty');
    }

    if (habit.plannedDays.isEmpty) {
      throw ArgumentError('Select at least one planned day');
    }

    if (habit.plannedDays.any((day) => day < 1 || day > 7)) {
      throw ArgumentError('Invalid weekday. Use values from 1 to 7');
    }
  }
  @override
  void addHabit(HabitModel habit) {
    _validateHabit(habit);

    if (_habits.any((item) => item.id == habit.id)) {
      throw ArgumentError('Habit ID already exists');
    }

    _habits.add(habit);
  }

  @override
  void editHabit(HabitModel habit) {
    _validateHabit(habit);

    final index = _habits.indexWhere(
      (item) => item.id == habit.id,
    );

    if (index == -1) {
      throw StateError('Habit not found');
    }

    _habits[index] = habit;
  }

  @override
  void deleteHabit(String habitId) {
    if (habitId.trim().isEmpty) {
      throw ArgumentError('Habit ID cannot be empty');
    }

    final index = _habits.indexWhere(
      (item) => item.id == habitId,
    );

    if (index == -1) {
      throw StateError('Habit not found');
    }

    _habits.removeAt(index);
  }

  @override
  HabitModel? getHabit(String habitId) {
    if (habitId.trim().isEmpty) {
      throw ArgumentError('Habit ID cannot be empty');
    }

    for (final habit in _habits) {
      if (habit.id == habitId) {
        return habit;
      }
    }

    return null;
  }

  @override
  List<HabitModel> findHabit(String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return List.unmodifiable(_habits);
    }

    return _habits.where((habit) {
      return habit.title.toLowerCase().contains(searchQuery) ||
          habit.description.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  void markHabitComplete(
    String habitId,
    HabitCompletion completion,
  ) {
    
  }

  @override
  void removeCompletion(String habitId, DateTime completedAt) {
    // 
  }

  @override
  List<HabitCompletion> getCalendarEntries(
    String habitId,
    DateTime date,
  ) {
    
    return [];
  }

  @override
  int calculateCurrentStreak(HabitModel habit) {
    
    return 0;
  }

  @override
  double calculateCompletionRate(
    HabitModel habit,
    DateTime startDate,
    DateTime endDate,
  ) {
    
    return 0;
  }
}