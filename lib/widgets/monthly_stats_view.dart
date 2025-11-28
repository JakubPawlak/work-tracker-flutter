import 'package:flutter/material.dart';
import '../models/monthly_stats.dart';

class MonthlyStatsView extends StatelessWidget {
  final MonthlyStats stats;
  final MonthlyStats threeMonthStats;

  const MonthlyStatsView({
    super.key,
    required this.stats,
    required this.threeMonthStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Statystyki miesięczne',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          // First row: Office and Remote (single month)
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Biuro',
                  value: '${stats.officeDays}',
                  subtitle: '${stats.officePercentage.toStringAsFixed(1)}%',
                  color: Colors.blue,
                  isDanger: stats.officePercentage < 60.0,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatCard(
                  title: 'Zdalnie',
                  value: '${stats.remoteDays}',
                  subtitle: '${stats.remotePercentage.toStringAsFixed(1)}%',
                  color: Colors.green,
                  isDanger: stats.remotePercentage > 40.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Second row: Work days and Vacations
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Dni robocze',
                  value: '${stats.totalWorkDays}',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatCard(
                  title: 'Urlopy',
                  value: '${stats.daysOff}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Third row: Average office days per week
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Śr. % biuro/tydzień',
                  value: '${stats.averageOfficeDaysPerWeek.toStringAsFixed(1)}%',
                  subtitle: 'dni robocze',
                  color: Colors.purple,
                  isDanger: stats.averageOfficeDaysPerWeek < 60.0,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatCard(
                  title: 'Śr. % biuro/tydzień (3m)',
                  value: '${threeMonthStats.averageOfficeDaysPerWeek.toStringAsFixed(1)}%',
                  subtitle: 'dni robocze',
                  color: Colors.purple,
                  isDanger: threeMonthStats.averageOfficeDaysPerWeek < 60.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Fourth row: Office and Remote (3-month stats)
          Column(
            children: [
              const Text(
                'Statystyki 3-miesięczne',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Biuro (3m)',
                      value: '${threeMonthStats.officeDays}',
                      subtitle:
                          '${threeMonthStats.officePercentage.toStringAsFixed(1)}%',
                      color: Colors.blue,
                      isDanger: threeMonthStats.officePercentage < 60.0,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: StatCard(
                      title: 'Zdalnie (3m)',
                      value: '${threeMonthStats.remoteDays}',
                      subtitle:
                          '${threeMonthStats.remotePercentage.toStringAsFixed(1)}%',
                      color: Colors.green,
                      isDanger: threeMonthStats.remotePercentage > 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color color;
  final bool isDanger;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.color,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDanger ? Colors.red.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDanger ? Colors.red : color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

