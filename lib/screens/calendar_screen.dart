import 'package:flutter/material.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/empty_state.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: habitProvider,
      builder: (context, _) {
        final activeHabits =
            habitProvider.habits.where((habit) => habit.isActive).toList();
        final completionDates = <DateTime>{
          for (final habit in activeHabits)
            for (final completion in habit.completions)
              DateUtils.dateOnly(completion.completedAt),
        };
        final plannedHabits = activeHabits
            .where((habit) => habit.plannedDays.contains(_selectedDate.weekday))
            .toList();
        final completedCount = plannedHabits
            .where((habit) => habitProvider.isCompletedOn(habit, _selectedDate))
            .length;

        return Scaffold(
          appBar: AppBar(title: const Text('Calendar')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  Text(
                    'Your consistency, at a glance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 18),
                  CalendarWidget(
                    month: _month,
                    selectedDate: _selectedDate,
                    completionDates: completionDates,
                    onMonthChanged: (month) {
                      setState(() {
                        _month = DateTime(month.year, month.month);
                        _selectedDate = DateTime(month.year, month.month);
                      });
                    },
                    onDateSelected: (date) {
                      setState(() => _selectedDate = DateUtils.dateOnly(date));
                    },
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dateHeading(_selectedDate),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      if (plannedHabits.isNotEmpty)
                        Text(
                          '$completedCount / ${plannedHabits.length}',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (activeHabits.isEmpty)
                    const EmptyState(
                      icon: Icons.calendar_month_outlined,
                      title: 'Nothing on the calendar yet',
                      message:
                          'Once you have habits and completions, your activity will appear here.',
                    )
                  else if (plannedHabits.isEmpty)
                    const EmptyState(
                      icon: Icons.weekend_outlined,
                      title: 'A day off',
                      message: 'No active habits are planned for this day.',
                    )
                  else
                    ...plannedHabits.map(
                      (habit) => _CalendarHabitTile(
                        habit: habit,
                        completed:
                            habitProvider.isCompletedOn(habit, _selectedDate),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _dateHeading(DateTime date) {
    final today = DateUtils.dateOnly(DateTime.now());
    if (DateUtils.isSameDay(date, today)) return 'Today';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CalendarHabitTile extends StatelessWidget {
  final HabitModel habit;
  final bool completed;

  const _CalendarHabitTile({
    required this.habit,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: completed
              ? colors.tertiaryContainer
              : colors.surfaceContainerHighest,
          child: Icon(
            completed ? Icons.check : Icons.circle_outlined,
            color: completed ? colors.tertiary : colors.onSurfaceVariant,
          ),
        ),
        title: Text(
          habit.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(completed ? 'Completed' : 'Not completed'),
        trailing: completed
            ? Icon(Icons.check_circle, color: colors.tertiary)
            : null,
      ),
    );
  }
}
