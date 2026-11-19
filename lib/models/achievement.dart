class Achievement {
  final String id;
  final String title;
  final String description;
  final int requiredStreakDays;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredStreakDays,
    this.unlockedAt,
  });
}
