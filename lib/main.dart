import 'package:flutter/material.dart';
import 'package:hive_example/model/history_model.dart';
import 'package:hive_example/screen/history_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HistoryAdapter());

  await Hive.openBox<History>('history');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HistoryScreen(),
    );
  }
}
