import 'package:flutter/material.dart';
import 'package:neuroblitz/services/database_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, dynamic> _stats = {
    'wordSearch': {
      'gamesPlayed': 0,
      'bestTime': 0,
      'averageTime': 0,
      'totalWordsFound': 0,
    },
    'cardMatch': {
      'gamesPlayed': 0,
      'bestMoves': 0,
      'averageMoves': 0,
      'winRate': 0,
    },
    'memorySignals': {
      'gamesPlayed': 0,
      'highestLevel': 0,
      'averageScore': 0,
      'totalNotes': 0,
    },
    'overall': {
      'totalGames': 0,
      'totalPlayTime': 0,
      'streakDays': 0,
      'lastPlayed': '',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    // In real app, fetch from database
    // For demo, use mock data
    setState(() {
      _stats = {
        'wordSearch': {
          'gamesPlayed': 12,
          'bestTime': 85, // seconds
          'averageTime': 120,
          'totalWordsFound': 96,
        },
        'cardMatch': {
          'gamesPlayed': 18,
          'bestMoves': 16,
          'averageMoves': 24,
          'winRate': 85, // percentage
        },
        'memorySignals': {
          'gamesPlayed': 25,
          'highestLevel': 8,
          'averageScore': 320,
          'totalNotes': 125,
        },
        'overall': {
          'totalGames': 55,
          'totalPlayTime': 142, // minutes
          'streakDays': 7,
          'lastPlayed': 'Today, 10:30 AM',
        },
      };
    });
  }

  void _resetStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Stats?'),
        content: const Text(
          'This will delete all your game statistics. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              // In real app, clear database
              setState(() {
                _stats = {
                  'wordSearch': {
                    'gamesPlayed': 0,
                    'bestTime': 0,
                    'averageTime': 0,
                    'totalWordsFound': 0,
                  },
                  'cardMatch': {
                    'gamesPlayed': 0,
                    'bestMoves': 0,
                    'averageMoves': 0,
                    'winRate': 0,
                  },
                  'memorySignals': {
                    'gamesPlayed': 0,
                    'highestLevel': 0,
                    'averageScore': 0,
                    'totalNotes': 0,
                  },
                  'overall': {
                    'totalGames': 0,
                    'totalPlayTime': 0,
                    'streakDays': 0,
                    'lastPlayed': 'Never',
                  },
                };
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStats(String game, Map<String, dynamic> stats) {
    String gameName = '';
    Color color = Colors.blue;
    IconData icon = Icons.games;

    switch (game) {
      case 'wordSearch':
        gameName = 'Word Search';
        color = Colors.blue;
        icon = Icons.search;
        break;
      case 'cardMatch':
        gameName = 'Match Cards';
        color = Colors.green;
        icon = Icons.style;
        break;
      case 'memorySignals':
        gameName = 'Memory Signals';
        color = Colors.purple;
        icon = Icons.music_note;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 10),
                Text(
                  gameName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: stats.entries.map((entry) {
                String title = '';
                String value = '';
                IconData statIcon = Icons.info;

                switch (entry.key) {
                  case 'gamesPlayed':
                    title = 'Games Played';
                    value = '${entry.value}';
                    statIcon = Icons.play_arrow;
                    break;
                  case 'bestTime':
                    title = 'Best Time';
                    value = '${entry.value}s';
                    statIcon = Icons.timer;
                    break;
                  case 'bestMoves':
                    title = 'Best Moves';
                    value = '${entry.value}';
                    statIcon = Icons.directions_run;
                    break;
                  case 'averageMoves':
                    title = 'Avg Moves';
                    value = '${entry.value}';
                    statIcon = Icons.trending_up;
                    break;
                  case 'highestLevel':
                    title = 'Highest Level';
                    value = '${entry.value}';
                    statIcon = Icons.flag;
                    break;
                  case 'averageScore':
                    title = 'Avg Score';
                    value = '${entry.value}';
                    statIcon = Icons.score;
                    break;
                  case 'winRate':
                    title = 'Win Rate';
                    value = '${entry.value}%';
                    statIcon = Icons.percent;
                    break;
                  case 'totalWordsFound':
                    title = 'Words Found';
                    value = '${entry.value}';
                    statIcon = Icons.check_circle;
                    break;
                  case 'totalNotes':
                    title = 'Notes Played';
                    value = '${entry.value}';
                    statIcon = Icons.music_note;
                    break;
                  case 'averageTime':
                    title = 'Avg Time';
                    value = '${entry.value}s';
                    statIcon = Icons.access_time;
                    break;
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(statIcon, size: 20, color: color),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Statistics'),
        actions: [
          IconButton(
            onPressed: () {
              // Export/share stats
              _shareStats();
            },
            icon: const Icon(Icons.share),
            tooltip: 'Share Stats',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Header
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.leaderboard, size: 30, color: Colors.amber),
                        SizedBox(width: 10),
                        Text(
                          'Overall Performance',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _buildStatCard(
                          'Total Games',
                          '${_stats['overall']['totalGames']}',
                          Icons.games,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Play Time',
                          '${_stats['overall']['totalPlayTime']} min',
                          Icons.access_time,
                          Colors.green,
                        ),
                        _buildStatCard(
                          'Current Streak',
                          '${_stats['overall']['streakDays']} days',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Last Played',
                          _stats['overall']['lastPlayed'],
                          Icons.calendar_today,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Game-Specific Stats
            const Text(
              'Game Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'See how you\'re performing in each training game',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Word Search Stats
            _buildGameStats('wordSearch', _stats['wordSearch']),

            // Card Match Stats
            _buildGameStats('cardMatch', _stats['cardMatch']),

            // Memory Signals Stats
            _buildGameStats('memorySignals', _stats['memorySignals']),

            const SizedBox(height: 30),

            // Progress Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: (_stats['overall']['totalGames'] / 100).clamp(
                        0.0,
                        1.0,
                      ),
                      backgroundColor: Colors.grey[200],
                      color: Colors.green,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_stats['overall']['totalGames']} games played',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          'Goal: 100 games',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consistency',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Good',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Improvement',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '+15%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _resetStats,
                          icon: const Icon(Icons.restart_alt, size: 18),
                          label: const Text('Reset All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _shareStats() {
    // In real app, generate image or text summary
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Your Progress'),
        content: const Text(
          'Your statistics summary has been saved to your device. You can now share it from your gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
