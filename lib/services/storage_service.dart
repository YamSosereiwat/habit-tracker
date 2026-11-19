import '../models/habit_model.dart';

abstract class StorageService {
  Future<void> saveHabit(HabitModel habit);

  Future<List<HabitModel>> loadHabits();

  Future<void> deleteHabit(String habitId);
}
