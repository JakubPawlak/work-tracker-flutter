import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/work_day.dart';
import '../models/monthly_stats.dart';
import '../utils/polish_holidays.dart';
import 'package:intl/intl.dart';

class WorkDataManager extends ChangeNotifier {
  static final WorkDataManager _instance = WorkDataManager._internal();
  factory WorkDataManager() => _instance;
  WorkDataManager._internal();

  final Map<String, WorkDay> _workDays = {};
  final _workDaysKey = 'workDays';
  final _dateFormatter = DateFormat('yyyy-MM-dd');

  Future<void> initialize() async {
    await _loadData();
  }

  WorkType getWorkType(DateTime date) {
    final key = _dateKey(date);
    return _workDays[key]?.workType ?? WorkType.notSet;
  }

  Future<void> setWorkType(DateTime date, WorkType type) async {
    final key = _dateKey(date);
    _workDays[key] = WorkDay(date: date, workType: type);
    notifyListeners();
    await _saveData();
  }

  MonthlyStats getMonthlyStats(DateTime date) {
    final year = date.year;
    final month = date.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    var totalWorkDays = 0;
    var officeDays = 0;
    var remoteDays = 0;
    var daysOff = 0;
    final weeklyOfficeDays = <int, int>{};
    final weeklyWorkDays = <int, int>{};

    for (var day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(year, month, day);

      // Skip weekends
      if (_isWeekend(currentDate)) continue;

      // Skip holidays
      if (PolishHolidays.isHoliday(currentDate)) continue;

      final workType = getWorkType(currentDate);
      final weekOfYear = _getWeekOfYear(currentDate);

      switch (workType) {
        case WorkType.office:
          totalWorkDays++;
          officeDays++;
          weeklyOfficeDays[weekOfYear] = (weeklyOfficeDays[weekOfYear] ?? 0) + 1;
          weeklyWorkDays[weekOfYear] = (weeklyWorkDays[weekOfYear] ?? 0) + 1;
          break;
        case WorkType.remote:
          totalWorkDays++;
          remoteDays++;
          weeklyWorkDays[weekOfYear] = (weeklyWorkDays[weekOfYear] ?? 0) + 1;
          break;
        case WorkType.dayOff:
          daysOff++;
          break;
        case WorkType.notSet:
          break;
      }
    }

    // Calculate average weekly office percentage
    double averageOfficeDaysPerWeek = 0;
    if (weeklyWorkDays.isNotEmpty) {
      var totalPercentage = 0.0;
      var weekCount = 0;
      for (final entry in weeklyWorkDays.entries) {
        final week = entry.key;
        final workDays = entry.value;
        if (workDays > 0) {
          final officeDaysInWeek = weeklyOfficeDays[week] ?? 0;
          final weekPercentage = (officeDaysInWeek / workDays) * 100.0;
          totalPercentage += weekPercentage;
          weekCount++;
        }
      }
      averageOfficeDaysPerWeek = weekCount > 0 ? totalPercentage / weekCount : 0;
    }

    return MonthlyStats(
      totalWorkDays: totalWorkDays,
      officeDays: officeDays,
      remoteDays: remoteDays,
      daysOff: daysOff,
      averageOfficeDaysPerWeek: averageOfficeDaysPerWeek,
    );
  }

  MonthlyStats getThreeMonthStats(DateTime date) {
    var totalWorkDays = 0;
    var officeDays = 0;
    var remoteDays = 0;
    var daysOff = 0;
    final weeklyOfficeDays = <int, int>{};
    final weeklyWorkDays = <int, int>{};

    // Iterate through current month and 2 previous months
    for (var monthOffset = 0; monthOffset < 3; monthOffset++) {
      final targetMonth = DateTime(date.year, date.month - monthOffset, 1);
      final year = targetMonth.year;
      final month = targetMonth.month;
      final daysInMonth = DateTime(year, month + 1, 0).day;

      for (var day = 1; day <= daysInMonth; day++) {
        final currentDate = DateTime(year, month, day);

        // Skip weekends
        if (_isWeekend(currentDate)) continue;

        // Skip holidays
        if (PolishHolidays.isHoliday(currentDate)) continue;

        final workType = getWorkType(currentDate);
        // Use both year and weekOfYear to handle year boundaries
        final weekKey = currentDate.year * 100 + _getWeekOfYear(currentDate);

        switch (workType) {
          case WorkType.office:
            totalWorkDays++;
            officeDays++;
            weeklyOfficeDays[weekKey] = (weeklyOfficeDays[weekKey] ?? 0) + 1;
            weeklyWorkDays[weekKey] = (weeklyWorkDays[weekKey] ?? 0) + 1;
            break;
          case WorkType.remote:
            totalWorkDays++;
            remoteDays++;
            weeklyWorkDays[weekKey] = (weeklyWorkDays[weekKey] ?? 0) + 1;
            break;
          case WorkType.dayOff:
            daysOff++;
            break;
          case WorkType.notSet:
            break;
        }
      }
    }

    // Calculate average weekly office percentage
    double averageOfficeDaysPerWeek = 0;
    if (weeklyWorkDays.isNotEmpty) {
      var totalPercentage = 0.0;
      var weekCount = 0;
      for (final entry in weeklyWorkDays.entries) {
        final week = entry.key;
        final workDays = entry.value;
        if (workDays > 0) {
          final officeDaysInWeek = weeklyOfficeDays[week] ?? 0;
          final weekPercentage = (officeDaysInWeek / workDays) * 100.0;
          totalPercentage += weekPercentage;
          weekCount++;
        }
      }
      averageOfficeDaysPerWeek = weekCount > 0 ? totalPercentage / weekCount : 0;
    }

    return MonthlyStats(
      totalWorkDays: totalWorkDays,
      officeDays: officeDays,
      remoteDays: remoteDays,
      daysOff: daysOff,
      averageOfficeDaysPerWeek: averageOfficeDaysPerWeek,
    );
  }

  String _dateKey(DateTime date) {
    return _dateFormatter.format(date);
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _workDays.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_workDaysKey, jsonEncode(data));
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_workDaysKey);
    if (jsonString != null) {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      _workDays.clear();
      data.forEach((key, value) {
        _workDays[key] = WorkDay.fromJson(value as Map<String, dynamic>);
      });
      notifyListeners();
    }
  }
}

