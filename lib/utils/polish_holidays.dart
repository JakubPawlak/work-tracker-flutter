class PolishHolidays {
  static bool isHoliday(DateTime date) {
    final month = date.month;
    final day = date.day;

    // Fixed holidays
    const fixedHolidays = [
      (1, 1), // New Year's Day
      (1, 6), // Epiphany
      (5, 1), // Labour Day
      (5, 3), // Constitution Day
      (8, 15), // Assumption of Mary
      (11, 1), // All Saints' Day
      (11, 11), // Independence Day
      (12, 25), // Christmas
      (12, 26), // Second Day of Christmas
    ];

    for (final holiday in fixedHolidays) {
      if (month == holiday.$1 && day == holiday.$2) {
        return true;
      }
    }

    // Easter-based holidays (approximate for demo - you can add precise Easter calculation)
    // For now, we'll skip Easter calculations, but in production you'd want to add:
    // - Easter Sunday
    // - Easter Monday
    // - Corpus Christi (60 days after Easter)

    return false;
  }

  static String? getHolidayName(DateTime date) {
    final month = date.month;
    final day = date.day;

    const holidays = {
      (1, 1): 'Nowy Rok',
      (1, 6): 'Święto Trzech Króli',
      (5, 1): 'Święto Pracy',
      (5, 3): 'Święto Konstytucji 3 Maja',
      (8, 15): 'Wniebowzięcie NMP',
      (11, 1): 'Wszystkich Świętych',
      (11, 11): 'Święto Niepodległości',
      (12, 25): 'Boże Narodzenie',
      (12, 26): 'Drugi Dzień Bożego Narodzenia',
    };

    return holidays[(month, day)];
  }
}

