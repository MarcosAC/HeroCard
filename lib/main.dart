import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'viewmodels/hero_viewmodel.dart';
import 'screens/hero_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HeroViewModel _heroViewModel;

  @override
  void initState() {
    super.initState();
    _heroViewModel = HeroViewModel(databaseHelper: DatabaseHelper());
  }

  @override
  void dispose() {
    _heroViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journeys in Middle-earth Companion',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        appBarTheme: AppBarTheme(
          color: Colors.brown[900],
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.brown[700], // FAB color
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.brown[50],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.brown[700]!),
          ),
          labelStyle: TextStyle(color: Colors.brown[800]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      home: HeroListScreen(viewModel: _heroViewModel),
      debugShowCheckedModeBanner: false,
    );
  }
}