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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'requiredStreakDays': requiredStreakDays,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      requiredStreakDays: map['requiredStreakDays'],
      unlockedAt: map['unlockedAt'] == null ? null : DateTime.parse(map['unlockedAt']),
    );
  }
}