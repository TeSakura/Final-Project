import 'package:flutter/material.dart';
import 'package:neuroblitz/widgets/game_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🧠 NeuroBlitz',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFC8E6C9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Brain Recovery Trainer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 40),
              GameButton(
                title: 'WORD SEARCH',
                subtitle: 'Find hidden recovery words',
                icon: Icons.search,
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, '/word-search');
                },
              ),
              const SizedBox(height: 20),
              GameButton(
                title: 'MATCH CARDS',
                subtitle: 'Match pairs to train memory',
                icon: Icons.style,
                color: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, '/card-match');
                },
              ),
              const SizedBox(height: 20),
              GameButton(
                title: 'MEMORY SIGNALS',
                subtitle: 'Repeat musical sequences',
                icon: Icons.music_note,
                color: Colors.purple,
                onPressed: () {
                  Navigator.pushNamed(context, '/memory-signals');
                },
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // In HomeScreen, update the stats button:
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/stats',
                      ); // Changed from pushNamed
                    },
                    icon: const Icon(Icons.leaderboard, size: 32),
                    color: Colors.blue[800],
                    tooltip: 'View Stats',
                  ),
                  IconButton(
                    onPressed: () {
                      _showSettings(context);
                    },
                    icon: const Icon(Icons.settings, size: 32),
                    color: Colors.blue[800],
                    tooltip: 'Settings',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}
