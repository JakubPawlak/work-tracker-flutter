class MonthlyStats {
  final int totalWorkDays;
  final int officeDays;
  final int remoteDays;
  final int daysOff;
  final double averageOfficeDaysPerWeek;

  MonthlyStats({
    required this.totalWorkDays,
    required this.officeDays,
    required this.remoteDays,
    required this.daysOff,
    required this.averageOfficeDaysPerWeek,
  });

  double get remotePercentage {
    if (totalWorkDays == 0) return 0;
    return (remoteDays / totalWorkDays) * 100;
  }

  double get officePercentage {
    if (totalWorkDays == 0) return 0;
    return (officeDays / totalWorkDays) * 100;
  }
}

