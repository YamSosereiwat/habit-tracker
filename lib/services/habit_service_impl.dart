
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

  HabitModel _getRequiredHabit(String habitId) {
    if (habitId.trim().isEmpty) {
      throw ArgumentError('Habit ID cannot be empty');
    }

    final habit = getHabit(habitId);

    if (habit == null) {
      throw StateError('Habit not found');
    }

    return habit;
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
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
    final habit = _getRequiredHabit(habitId);

    _habits.remove(habit);
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

    return List.unmodifiable(
      _habits.where((habit) {
        return habit.title.toLowerCase().contains(searchQuery) ||
            habit.description.toLowerCase().contains(searchQuery);
      }),
    );
  }

  @override
  void markHabitComplete(
    String habitId,
    HabitCompletion completion,
  ) {
    final habit = _getRequiredHabit(habitId);

    if (!habit.isActive) {
      throw StateError('Cannot complete an inactive habit');
    }

    if (!habit.plannedDays.contains(completion.completedAt.weekday)) {
      throw StateError('Today is not a planned day');
    }

    final alreadyCompleted = habit.completions.any(
      (item) => _isSameDate(
        item.completedAt,
        completion.completedAt,
      ),
    );

    if (alreadyCompleted) {
      throw StateError('Habit already completed today');
    }

    habit.completions.add(completion);
  }

  @override
  void removeCompletion(String habitId, DateTime completedAt) {
    final habit = _getRequiredHabit(habitId);

    final index = habit.completions.indexWhere(
      (item) => _isSameDate(item.completedAt, completedAt),
    );

    if (index == -1) {
      throw StateError('Completion not found');
    }

    habit.completions.removeAt(index);
  }

  @override
  List<HabitCompletion> getCalendarEntries(
    String habitId,
    DateTime date,
  ) {
    final habit = _getRequiredHabit(habitId);

    return List.unmodifiable(
      habit.completions.where(
        (item) => _isSameDate(item.completedAt, date),
      ),
    );
  }

  @override
  int calculateCurrentStreak(HabitModel habit) {
    int streak = 0;

    DateTime currentDate = DateTime.now();

    currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    if (habit.plannedDays.contains(currentDate.weekday)) {
      final completedToday = habit.completions.any(
        (item) => _isSameDate(item.completedAt, currentDate),
      );

      if (completedToday) {
        streak++;
      }
    }

    currentDate = currentDate.subtract(
      const Duration(days: 1),
    );

    while (true) {
      // Skip days that are not planned.
      if (!habit.plannedDays.contains(currentDate.weekday)) {
        currentDate = currentDate.subtract(
          const Duration(days: 1),
        );
        continue;
      }

      final isCompleted = habit.completions.any(
        (item) => _isSameDate(item.completedAt, currentDate),
      );

      if (!isCompleted) {
        break;
      }

      streak++;

      currentDate = currentDate.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  @override
  double calculateCompletionRate(
    HabitModel habit,
    DateTime startDate,
    DateTime endDate,
  ) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date cannot be after end date');
    }

    int totalPlannedDays = 0;
    int completedDays = 0;

    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day
    );

    final lastDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day
    );

    while(!currentDate.isAfter(lastDate)){
      if (habit.plannedDays.contains(currentDate.weekday)) {
        totalPlannedDays++;

        final isCompleted = habit.completions.any(
          (item) => _isSameDate(item.completedAt, currentDate)
        );

        if (isCompleted){
          completedDays++;
        }
      }

      currentDate = currentDate.add(
        const Duration(days: 1)
      );
    }

    if (totalPlannedDays == 0){
      return 0;
    }
    return (completedDays / totalPlannedDays) *100;
  }
}
