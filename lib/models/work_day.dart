enum WorkType {
  office('Office', '🏢'),
  remote('Remote', '🏠'),
  dayOff('Day Off', '🌴'),
  notSet('Not Set', '❓');

  const WorkType(this.label, this.emoji);
  final String label;
  final String emoji;
}

class WorkDay {
  final String id;
  final DateTime date;
  final WorkType workType;

  WorkDay({
    String? id,
    required this.date,
    this.workType = WorkType.notSet,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'workType': workType.name,
      };

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    return WorkDay(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      workType: WorkType.values.firstWhere(
        (e) => e.name == json['workType'],
        orElse: () => WorkType.notSet,
      ),
    );
  }
}

