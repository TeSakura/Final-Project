import 'package:flutter/material.dart';
import 'package:neuroblitz/screens/home_screen.dart';
import 'package:neuroblitz/screens/word_search_screen.dart';
import 'package:neuroblitz/screens/card_match_screen.dart';
import 'package:neuroblitz/screens/memory_signals_screen.dart';
import 'package:neuroblitz/screens/stats_screen.dart'; // Add this import
import 'package:neuroblitz/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  runApp(const NeuroBlitzApp());
}

class NeuroBlitzApp extends StatelessWidget {
  const NeuroBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroBlitz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ComicNeue',
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/word-search': (context) => const WordSearchScreen(),
        '/card-match': (context) => const CardMatchScreen(),
        '/memory-signals': (context) => const MemorySignalsScreen(),
        '/stats': (context) => const StatsScreen(), // Add this route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
