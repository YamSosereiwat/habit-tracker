class HabitCompletion {
  final DateTime completedAt;
  final String? note;

  const HabitCompletion({
    required this.completedAt,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'completeAt': completedAt.toIso8601String(),
      'note': note
    };
  }

  factory HabitCompletion.fromMap(Map<String, dynamic> map) {
    return HabitCompletion(
      completedAt: DateTime.parse(map['completedAt']),
      note: map['note'],
    );
  }
}
