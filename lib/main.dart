import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'managers/work_data_manager.dart';
import 'managers/notification_manager.dart';
import 'screens/content_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Polish locale
  await initializeDateFormatting('pl_PL', null);

  // Initialize managers
  await WorkDataManager().initialize();
  await NotificationManager().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be selfish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContentView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
