import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../managers/notification_manager.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _notificationManager = NotificationManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Gotowe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _notificationManager,
        builder: (context, child) {
          return ListView(
            children: [
              _buildSection(
                'Powiadomienia',
                [
                  if (kIsWeb) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '⚠️ Powiadomienia nie są dostępne w wersji webowej. Użyj aplikacji mobilnej aby otrzymywać przypomnienia.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    SwitchListTile(
                      title: const Text('Włącz codzienne przypomnienia'),
                      value: _notificationManager.notificationsEnabled,
                      onChanged: (value) {
                        _notificationManager.setNotificationsEnabled(value);
                      },
                    ),
                    if (_notificationManager.notificationsEnabled) ...[
                      ListTile(
                        title: const Text('Godzina przypomnienia'),
                        trailing: Text(
                          _formatTime(_notificationManager.notificationTime),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => _selectTime(context),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Otrzymasz codzienne powiadomienie o wybranej godzinie z pytaniem o pracę.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
              _buildSection(
                'Informacje',
                [
                  const ListTile(
                    title: Text('Wersja'),
                    trailing: Text(
                      '1.0.0',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const ListTile(
                    title: Text('Data aktualizacji'),
                    trailing: Text(
                      'Listopad 2025',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context) async {
    final currentTime = _notificationManager.notificationTime;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: 250,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Anuluj'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Gotowe'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    2000,
                    1,
                    1,
                    currentTime.hour,
                    currentTime.minute,
                  ),
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDateTime) {
                    _notificationManager.setNotificationTime(
                      TimeOfDay(
                        hour: newDateTime.hour,
                        minute: newDateTime.minute,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: currentTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (picked != null) {
        _notificationManager.setNotificationTime(picked);
      }
    }
  }
}

