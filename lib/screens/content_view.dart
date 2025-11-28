import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../managers/work_data_manager.dart';
import '../utils/polish_holidays.dart';
import '../widgets/calendar_view.dart';
import '../widgets/today_prompt_view.dart';
import '../widgets/day_control_view.dart';
import '../widgets/monthly_stats_view.dart';
import 'settings_view.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final _dataManager = WorkDataManager();
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Be selfish'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsView()),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: _goToToday,
            child: const Text(
              'Dzisiaj',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _dataManager,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Month navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 28),
                        onPressed: _previousMonth,
                        color: Colors.blue,
                      ),
                      Text(
                        _monthYearString,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 28),
                        onPressed: _nextMonth,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Calendar
                  CalendarView(
                    dataManager: _dataManager,
                    selectedDate: _selectedDate,
                    currentMonth: _currentMonth,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Today's prompt (if today is selected and is a workday)
                  if (_isToday(_selectedDate) &&
                      !_isWeekend(_selectedDate) &&
                      !PolishHolidays.isHoliday(_selectedDate))
                    TodayPromptView(
                      dataManager: _dataManager,
                      date: _selectedDate,
                    ),
                  // Day info and controls
                  if (!_isToday(_selectedDate) ||
                      _isWeekend(_selectedDate) ||
                      PolishHolidays.isHoliday(_selectedDate))
                    DayControlView(
                      dataManager: _dataManager,
                      date: _selectedDate,
                      isWeekend: _isWeekend(_selectedDate),
                      isHoliday: PolishHolidays.isHoliday(_selectedDate),
                      holidayName:
                          PolishHolidays.getHolidayName(_selectedDate),
                    ),
                  const SizedBox(height: 20),
                  // Monthly statistics
                  MonthlyStatsView(
                    stats: _dataManager.getMonthlyStats(_currentMonth),
                    threeMonthStats:
                        _dataManager.getThreeMonthStats(_currentMonth),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String get _monthYearString {
    final formatter = DateFormat('LLLL yyyy', 'pl_PL');
    final formatted = formatter.format(_currentMonth);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _currentMonth = DateTime.now();
    });
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

