import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final Set<DateTime> completionDates;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarWidget({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.completionDates,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final firstOfMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingDays = firstOfMonth.weekday - DateTime.monday;
    final cellCount = ((leadingDays + daysInMonth + 6) ~/ 7) * 7;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Previous month',
                  onPressed: () =>
                      onMonthChanged(DateTime(month.year, month.month - 1)),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    _monthLabel(month),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Next month',
                  onPressed: () =>
                      onMonthChanged(DateTime(month.year, month.month + 1)),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                _WeekdayLabel('Monday'),
                _WeekdayLabel('Tuesday'),
                _WeekdayLabel('Wednesday'),
                _WeekdayLabel('Thursday'),
                _WeekdayLabel('Friday'),
                _WeekdayLabel('Saturday'),
                _WeekdayLabel('Sunday'),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cellCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                mainAxisExtent: 44,
              ),
              itemBuilder: (context, index) {
                final day = index - leadingDays + 1;
                if (day < 1 || day > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final date = DateTime(month.year, month.month, day);
                final isSelected = _sameDay(date, selectedDate);
                final isToday = _sameDay(date, DateTime.now());
                final hasCompletion = completionDates.any(
                  (completionDate) => _sameDay(completionDate, date),
                );
                final foreground = isSelected
                    ? colors.onPrimary
                    : isToday
                    ? colors.primary
                    : colors.onSurface;

                return Semantics(
                  key: ValueKey(
                    'calendar-day-${date.year}-${date.month}-${date.day}',
                  ),
                  button: true,
                  label:
                      '${_monthLabel(month)} $day'
                      '${hasCompletion ? ', completed habits' : ''}',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onDateSelected(date),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : null,
                        borderRadius: BorderRadius.circular(14),
                        border: isToday && !isSelected
                            ? Border.all(color: colors.primary)
                            : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: foreground,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (hasCompletion)
                            Positioned(
                              bottom: 5,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? colors.onPrimary
                                      : colors.tertiary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colors.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'Completed habits',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _sameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

class _WeekdayLabel extends StatelessWidget {
  final String label;

  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
