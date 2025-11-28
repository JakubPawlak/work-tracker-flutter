import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/work_day.dart';
import '../managers/work_data_manager.dart';

class DayControlView extends StatelessWidget {
  final WorkDataManager dataManager;
  final DateTime date;
  final bool isWeekend;
  final bool isHoliday;
  final String? holidayName;

  const DayControlView({
    super.key,
    required this.dataManager,
    required this.date,
    required this.isWeekend,
    required this.isHoliday,
    this.holidayName,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('d MMMM yyyy', 'pl_PL');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (isWeekend)
            const Text(
              'Weekend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          else if (isHoliday && holidayName != null)
            Text(
              holidayName!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          else ...[
            Text(
              dateFormatter.format(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _WorkTypeButton(
                    emoji: '🏢',
                    label: 'Biuro',
                    workType: WorkType.office,
                    currentWorkType: dataManager.getWorkType(date),
                    color: Colors.blue,
                    onTap: () => dataManager.setWorkType(date, WorkType.office),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _WorkTypeButton(
                    emoji: '🏠',
                    label: 'Zdalnie',
                    workType: WorkType.remote,
                    currentWorkType: dataManager.getWorkType(date),
                    color: Colors.green,
                    onTap: () =>
                        dataManager.setWorkType(date, WorkType.remote),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _WorkTypeButton(
                    emoji: '🌴',
                    label: 'Urlop',
                    workType: WorkType.dayOff,
                    currentWorkType: dataManager.getWorkType(date),
                    color: Colors.orange,
                    onTap: () =>
                        dataManager.setWorkType(date, WorkType.dayOff),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WorkTypeButton extends StatelessWidget {
  final String emoji;
  final String label;
  final WorkType workType;
  final WorkType currentWorkType;
  final Color color;
  final VoidCallback onTap;

  const _WorkTypeButton({
    required this.emoji,
    required this.label,
    required this.workType,
    required this.currentWorkType,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = workType == currentWorkType;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

