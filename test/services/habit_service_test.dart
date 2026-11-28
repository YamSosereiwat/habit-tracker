
import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/models/habit_completion.dart';
import 'package:habit_tracker/services/habit_service_impl.dart';

void main() {
  late HabitServiceImpl habitService;

  setUp(() {
    habitService = HabitServiceImpl();
  });

  // Helper to create test habits.
  HabitModel createHabit({
    String id = 'habit_1',
    String title = 'Exercise',
    String description = 'Daily workout',
    Set<int>? plannedDays,
    bool isActive = true,
  }) {
    return HabitModel(
      id: id,
      title: title,
      description: description,
      categoryId: 'category_1',
      createdAt: DateTime(2026, 1, 1),
      plannedDays: plannedDays ?? {1, 2, 3, 4, 5, 6, 7},
      isActive: isActive,
      completions: [],
      achievements: [],
    );
  }

  // Helper to create completions.
  HabitCompletion createCompletion(
    DateTime date, {
    String? note,
  }) {
    return HabitCompletion(
      completedAt: date,
      note: note,
    );
  }

  // --------------------------------------------------
  // ADD HABIT
  // --------------------------------------------------

  group('Add Habit', () {
    test('Should add a valid habit', () {
      final habit = createHabit();

      habitService.addHabit(habit);

      expect(habitService.getHabit('habit_1'), equals(habit));
    });

    test('Should reject an empty habit ID', () {
      final habit = createHabit(id: '');

      expect(
        () => habitService.addHabit(habit),
        throwsArgumentError,
      );
    });

    test('Should reject an empty habit title', () {
      final habit = createHabit(title: '   ');

      expect(
        () => habitService.addHabit(habit),
        throwsArgumentError,
      );
    });

    test('Should reject empty planned days', () {
      final habit = createHabit(plannedDays: {});

      expect(
        () => habitService.addHabit(habit),
        throwsArgumentError,
      );
    });

    test('Should reject an invalid weekday', () {
      final habit = createHabit(plannedDays: {1, 8});

      expect(
        () => habitService.addHabit(habit),
        throwsArgumentError,
      );
    });

    test('Should reject duplicate habit IDs', () {
      final habit1 = createHabit();
      final habit2 = createHabit(title: 'Reading');

      habitService.addHabit(habit1);

      expect(
        () => habitService.addHabit(habit2),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------
  // EDIT HABIT
  // --------------------------------------------------

  group('Edit Habit', () {
    test('Should update an existing habit', () {
      habitService.addHabit(createHabit());

      final updatedHabit = createHabit(
        title: 'Morning Exercise',
      );

      habitService.editHabit(updatedHabit);

      expect(
        habitService.getHabit('habit_1')!.title,
        equals('Morning Exercise'),
      );
    });

    test('Should reject editing a missing habit', () {
      final habit = createHabit(id: 'missing');

      expect(
        () => habitService.editHabit(habit),
        throwsStateError,
      );
    });

    test('Should reject invalid habit data', () {
      habitService.addHabit(createHabit());

      final invalidHabit = createHabit(title: '');

      expect(
        () => habitService.editHabit(invalidHabit),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------
  // DELETE HABIT
  // --------------------------------------------------

  group('Delete Habit', () {
    test('Should delete an existing habit', () {
      habitService.addHabit(createHabit());

      habitService.deleteHabit('habit_1');

      expect(habitService.getHabit('habit_1'), isNull);
    });

    test('Should reject deleting a missing habit', () {
      expect(
        () => habitService.deleteHabit('missing'),
        throwsStateError,
      );
    });

    test('Should reject an empty habit ID', () {
      expect(
        () => habitService.deleteHabit(''),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------
  // GET HABIT
  // --------------------------------------------------

  group('Get Habit', () {
    test('Should return an existing habit', () {
      final habit = createHabit();

      habitService.addHabit(habit);

      expect(
        habitService.getHabit('habit_1'),
        equals(habit),
      );
    });

    test('Should return null for a missing habit', () {
      expect(
        habitService.getHabit('missing'),
        isNull,
      );
    });

    test('Should reject an empty habit ID', () {
      expect(
        () => habitService.getHabit(''),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------
  // FIND HABIT
  // --------------------------------------------------

  group('Find Habit', () {
    setUp(() {
      habitService.addHabit(
        createHabit(
          id: '1',
          title: 'Morning Exercise',
          description: 'Workout every morning',
        ),
      );

      habitService.addHabit(
        createHabit(
          id: '2',
          title: 'Reading',
          description: 'Read books daily',
        ),
      );
    });

    test('Should search by habit title', () {
      final result = habitService.findHabit('exercise');

      expect(result.length, equals(1));
      expect(result.first.title, equals('Morning Exercise'));
    });

    test('Should search by habit description', () {
      final result = habitService.findHabit('books');

      expect(result.length, equals(1));
      expect(result.first.title, equals('Reading'));
    });

    test('Should return all habits for an empty query', () {
      final result = habitService.findHabit('');

      expect(result.length, equals(2));
    });

    test('Should ignore uppercase and surrounding spaces', () {
      final result = habitService.findHabit('  EXERCISE  ');

      expect(result.length, equals(1));
    });

    test('Should return an empty list when no habit matches', () {
      final result = habitService.findHabit('swimming');

      expect(result, isEmpty);
    });
  });

  // --------------------------------------------------
  // MARK HABIT COMPLETE
  // --------------------------------------------------

  group('Mark Habit Complete', () {
    test('Should mark a habit as complete on a planned day', () {
      final habit = createHabit(plannedDays: {1});

      habitService.addHabit(habit);

      final completion = createCompletion(
        DateTime(2026, 11, 23), // Monday
      );

      habitService.markHabitComplete('habit_1', completion);

      expect(habit.completions.length, equals(1));
    });

    test('Should reject completion for an inactive habit', () {
      habitService.addHabit(
        createHabit(
          isActive: false,
          plannedDays: {1},
        ),
      );

      final completion = createCompletion(
        DateTime(2026, 11, 23),
      );

      expect(
        () => habitService.markHabitComplete(
          'habit_1',
          completion,
        ),
        throwsStateError,
      );
    });

    test('Should reject completion on an unplanned day', () {
      habitService.addHabit(
        createHabit(plannedDays: {1}),
      );

      final completion = createCompletion(
        DateTime(2026, 11, 24), // Tuesday
      );

      expect(
        () => habitService.markHabitComplete(
          'habit_1',
          completion,
        ),
        throwsStateError,
      );
    });

    test('Should reject duplicate completion on the same date', () {
      habitService.addHabit(
        createHabit(plannedDays: {1}),
      );

      habitService.markHabitComplete(
        'habit_1',
        createCompletion(DateTime(2026, 11, 23, 8, 0)),
      );

      expect(
        () => habitService.markHabitComplete(
          'habit_1',
          createCompletion(DateTime(2026, 11, 23, 18, 0)),
        ),
        throwsStateError,
      );
    });

    test('Should reject completion for a missing habit', () {
      expect(
        () => habitService.markHabitComplete(
          'missing',
          createCompletion(DateTime(2026, 11, 23)),
        ),
        throwsStateError,
      );
    });
  });

  // --------------------------------------------------
  // REMOVE COMPLETION
  // --------------------------------------------------

  group('Remove Completion', () {
    test('Should remove an existing completion', () {
      final habit = createHabit(plannedDays: {1});

      habitService.addHabit(habit);

      habitService.markHabitComplete(
        'habit_1',
        createCompletion(DateTime(2026, 11, 23)),
      );

      habitService.removeCompletion(
        'habit_1',
        DateTime(2026, 11, 23),
      );

      expect(habit.completions, isEmpty);
    });

    test('Should reject removing a missing completion', () {
      habitService.addHabit(createHabit());

      expect(
        () => habitService.removeCompletion(
          'habit_1',
          DateTime(2026, 11, 23),
        ),
        throwsStateError,
      );
    });

    test('Should reject removing completion from a missing habit', () {
      expect(
        () => habitService.removeCompletion(
          'missing',
          DateTime(2026, 11, 23),
        ),
        throwsStateError,
      );
    });
  });

  // --------------------------------------------------
  // GET CALENDAR ENTRIES
  // --------------------------------------------------

  group('Get Calendar Entries', () {
    test('Should return completions for the requested date', () {
      final habit = createHabit(plannedDays: {1, 2});

      habitService.addHabit(habit);

      habitService.markHabitComplete(
        'habit_1',
        createCompletion(DateTime(2026, 11, 23, 8)),
      );

      habitService.markHabitComplete(
        'habit_1',
        createCompletion(DateTime(2026, 11, 24, 8)),
      );

      final result = habitService.getCalendarEntries(
        'habit_1',
        DateTime(2026, 11, 23),
      );

      expect(result.length, equals(1));
      expect(
        result.first.completedAt.day,
        equals(23),
      );
    });

    test('Should return an empty list when no completion exists', () {
      habitService.addHabit(createHabit());

      final result = habitService.getCalendarEntries(
        'habit_1',
        DateTime(2026, 11, 23),
      );

      expect(result, isEmpty);
    });

    test('Should reject a missing habit', () {
      expect(
        () => habitService.getCalendarEntries(
          'missing',
          DateTime(2026, 11, 23),
        ),
        throwsStateError,
      );
    });
  });

  // --------------------------------------------------
  // CALCULATE CURRENT STREAK
  // --------------------------------------------------

  group('Calculate Current Streak', () {
    test('Should return zero when there are no completions', () {
      final habit = createHabit();

      expect(
        habitService.calculateCurrentStreak(habit),
        equals(0),
      );
    });

    test('Should count completed planned days', () {
      final today = DateTime.now();

      final todayDate = DateTime(
        today.year,
        today.month,
        today.day,
      );

      final habit = createHabit(
        plannedDays: {todayDate.weekday},
      );

      habit.completions.add(
        createCompletion(todayDate),
      );

      expect(
        habitService.calculateCurrentStreak(habit),
        equals(1),
      );
    });

    test('Should return zero when today is planned but not completed '
        'and yesterday was not completed', () {
      final today = DateTime.now();

      final todayDate = DateTime(
        today.year,
        today.month,
        today.day,
      );

      final habit = createHabit(
        plannedDays: {todayDate.weekday},
      );

      expect(
        habitService.calculateCurrentStreak(habit),
        equals(0),
      );
    });

    test('Should skip unplanned days when calculating streak', () {
      final today = DateTime.now();

      final todayDate = DateTime(
        today.year,
        today.month,
        today.day,
      );

      final yesterday = todayDate.subtract(
        const Duration(days: 1),
      );

      final twoDaysAgo = todayDate.subtract(
        const Duration(days: 2),
      );

      final habit = createHabit(
        plannedDays: {
          yesterday.weekday,
          twoDaysAgo.weekday,
        },
      );

      habit.completions.add(
        createCompletion(yesterday),
      );

      habit.completions.add(
        createCompletion(twoDaysAgo),
      );

      expect(
        habitService.calculateCurrentStreak(habit),
        equals(2),
      );
    });

    test('Should break streak after a missed planned day', () {
      final today = DateTime.now();

      final todayDate = DateTime(
        today.year,
        today.month,
        today.day,
      );

      final yesterday = todayDate.subtract(
        const Duration(days: 1),
      );

      final twoDaysAgo = todayDate.subtract(
        const Duration(days: 2),
      );

      final habit = createHabit(
        plannedDays: {
          todayDate.weekday,
          yesterday.weekday,
          twoDaysAgo.weekday,
        },
      );

      habit.completions.add(
        createCompletion(twoDaysAgo),
      );

      expect(
        habitService.calculateCurrentStreak(habit),
        equals(0),
      );
    });
  });

  // --------------------------------------------------
  // CALCULATE COMPLETION RATE
  // --------------------------------------------------

  group('Calculate Completion Rate', () {
    test('Should return 100 percent when all planned days are completed', () {
      final habit = createHabit(
        plannedDays: {1, 2, 3},
      );

      habit.completions.add(
        createCompletion(DateTime(2026, 11, 23)),
      );

      habit.completions.add(
        createCompletion(DateTime(2026, 11, 24)),
      );

      habit.completions.add(
        createCompletion(DateTime(2026, 11, 25)),
      );

      final result = habitService.calculateCompletionRate(
        habit,
        DateTime(2026, 11, 23),
        DateTime(2026, 11, 25),
      );

      expect(result, equals(100));
    });

    test('Should return partial completion percentage', () {
      final habit = createHabit(
        plannedDays: {1, 2, 3},
      );

      habit.completions.add(
        createCompletion(DateTime(2026, 11, 23)),
      );

      final result = habitService.calculateCompletionRate(
        habit,
        DateTime(2026, 11, 23),
        DateTime(2026, 11, 25),
      );

      expect(result, closeTo(33.33, 0.01));
    });

    test('Should return zero when no planned days are completed', () {
      final habit = createHabit(
        plannedDays: {1, 2, 3},
      );

      final result = habitService.calculateCompletionRate(
        habit,
        DateTime(2026, 11, 23),
        DateTime(2026, 11, 25),
      );

      expect(result, equals(0));
    });

    test('Should return zero when date range has no planned days', () {
      final habit = createHabit(
        plannedDays: {1},
      );

      // November 24, 2026 is Tuesday.
      final result = habitService.calculateCompletionRate(
        habit,
        DateTime(2026, 11, 24),
        DateTime(2026, 11, 24),
      );

      expect(result, equals(0));
    });

    test('Should reject a start date after the end date', () {
      final habit = createHabit();

      expect(
        () => habitService.calculateCompletionRate(
          habit,
          DateTime(2026, 11, 25),
          DateTime(2026, 11, 23),
        ),
        throwsArgumentError,
      );
    });

    test('Should count the start and end dates inclusively', () {
      final habit = createHabit(
        plannedDays: {1, 2, 3},
      );

      habit.completions.add(
        createCompletion(DateTime(2026, 11, 23)),
      );

      final result = habitService.calculateCompletionRate(
        habit,
        DateTime(2026, 11, 23),
        DateTime(2026, 11, 23),
      );

      expect(result, equals(100));
    });
  });
}
