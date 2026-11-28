import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/widgets/calendar_widget.dart';

void main() {
  testWidgets('calendar changes month and selects a date', (tester) async {
    var month = DateTime(2026, 1);
    var selectedDate = DateTime(2026, 1, 1);
    DateTime? tappedDate;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: CalendarWidget(
              month: month,
              selectedDate: selectedDate,
              completionDates: const {},
              onMonthChanged: (value) => setState(() {
                month = value;
              }),
              onDateSelected: (value) => setState(() {
                selectedDate = value;
                tappedDate = value;
              }),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();

    expect(find.text('February 2026'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-2-10')));
    await tester.pumpAndSettle();

    expect(tappedDate, DateTime(2026, 2, 10));
  });
}
