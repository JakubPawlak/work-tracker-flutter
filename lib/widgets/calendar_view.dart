import 'package:flutter/material.dart';
import '../models/work_day.dart';
import '../managers/work_data_manager.dart';
import '../utils/polish_holidays.dart';

class CalendarDay {
  final DateTime? date;

  CalendarDay({this.date});
}

class CalendarView extends StatelessWidget {
  final WorkDataManager dataManager;
  final DateTime selectedDate;
  final DateTime currentMonth;
  final Function(DateTime) onDateSelected;

  const CalendarView({
    super.key,
    required this.dataManager,
    required this.selectedDate,
    required this.currentMonth,
    required this.onDateSelected,
  });

  static const daysOfWeek = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb', 'Nd'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Days of week header
        Row(
          children: daysOfWeek.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          itemCount: _getDaysInMonth().length,
          itemBuilder: (context, index) {
            final calendarDay = _getDaysInMonth()[index];
            if (calendarDay.date != null) {
              return DayCell(
                date: calendarDay.date!,
                workType: dataManager.getWorkType(calendarDay.date!),
                isSelected: _isSameDay(calendarDay.date!, selectedDate),
                isToday: _isSameDay(calendarDay.date!, DateTime.now()),
                isWeekend: _isWeekend(calendarDay.date!),
                isHoliday: PolishHolidays.isHoliday(calendarDay.date!),
                onTap: () => onDateSelected(calendarDay.date!),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  List<CalendarDay> _getDaysInMonth() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);

    final days = <CalendarDay>[];

    // Adjust for Monday start (weekday 1 = Monday, 7 = Sunday)
    final weekday = firstDayOfMonth.weekday;
    final offset = weekday - 1;

    // Add empty cells for days before month starts
    for (var i = 0; i < offset; i++) {
      days.add(CalendarDay());
    }

    // Add all days in month
    for (var day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(CalendarDay(
        date: DateTime(currentMonth.year, currentMonth.month, day),
      ));
    }

    return days;
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class DayCell extends StatelessWidget {
  final DateTime date;
  final WorkType workType;
  final bool isSelected;
  final bool isToday;
  final bool isWeekend;
  final bool isHoliday;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.date,
    required this.workType,
    required this.isSelected,
    required this.isToday,
    required this.isWeekend,
    required this.isHoliday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : isToday
                    ? Colors.orange
                    : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              workType.emoji,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (isWeekend || isHoliday) {
      return Colors.grey.withValues(alpha: 0.2);
    }

    switch (workType) {
      case WorkType.office:
        return Colors.blue.withValues(alpha: 0.2);
      case WorkType.remote:
        return Colors.green.withValues(alpha: 0.2);
      case WorkType.dayOff:
        return Colors.orange.withValues(alpha: 0.2);
      case WorkType.notSet:
        return Colors.transparent;
    }
  }
}

