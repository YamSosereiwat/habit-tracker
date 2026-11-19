import '../models/habit_completion.dart';
import '../models/habit_model.dart';

abstract class HabitService {
  void addHabit(HabitModel habit);

  void editHabit(HabitModel habit);

  void deleteHabit(String habitId);

  HabitModel? getHabit(String habitId);

  List<HabitModel> findHabit(String query);

  void markHabitComplete(String habitId, HabitCompletion completion);

  void removeCompletion(String habitId, DateTime completedAt);

  List<HabitCompletion> getCalendarEntries(String habitId, DateTime date);

  int calculateCurrentStreak(HabitModel habit);

  double calculateCompletionRate(
    HabitModel habit,
    DateTime startDate,
    DateTime endDate,
  );
}
