import '../models/achievement.dart';
import '../models/habit_model.dart';

abstract class AchievementService {
  List<Achievement> evaluateAchievements(HabitModel habit);
}
