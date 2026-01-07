import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neuroblitz/models/music_game.dart';
import 'package:neuroblitz/widgets/note_button.dart';

class MemorySignalsScreen extends StatefulWidget {
  const MemorySignalsScreen({super.key});

  @override
  State<MemorySignalsScreen> createState() => _MemorySignalsScreenState();
}

class _MemorySignalsScreenState extends State<MemorySignalsScreen> {
  late MusicGame game;
  List<String> notes = ['Do', 'Re', 'Mi', 'Fa', 'Sol'];
  List<String> currentSequence = [];
  List<String> playerSequence = [];
  bool isPlayingSequence = false;
  bool isPlayerTurn = false;
  int score = 0;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      game = MusicGame(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sequence: [],
        currentLevel: 1,
      );
      score = 0;
      currentStep = 0;
      _generateNewSequence();
    });
  }

  void _generateNewSequence() {
    currentSequence.add(notes[(currentSequence.length) % notes.length]);
    playerSequence.clear();
    isPlayerTurn = false;
    _playSequence();
  }

  void _playSequence() async {
    setState(() {
      isPlayingSequence = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < currentSequence.length; i++) {
      // Highlight the note
      setState(() {
        currentStep = i;
      });

      // Play sound (in real app, use audio service)
      // AudioService.playNote(currentSequence[i]);

      await Future.delayed(const Duration(milliseconds: 800));

      // Reset highlight
      if (i < currentSequence.length - 1) {
        setState(() {
          currentStep = -1;
        });
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    setState(() {
      isPlayingSequence = false;
      isPlayerTurn = true;
      currentStep = -1;
    });
  }

  void _onNotePressed(String note) {
    if (!isPlayerTurn || isPlayingSequence) return;

    setState(() {
      playerSequence.add(note);
      currentStep = playerSequence.length - 1;
    });

    // Check if note is correct
    int index = playerSequence.length - 1;
    if (playerSequence[index] != currentSequence[index]) {
      // Wrong note - game over
      _showGameOverDialog();
      return;
    }

    // Play note sound
    // AudioService.playNote(note);

    // Check if sequence complete
    if (playerSequence.length == currentSequence.length) {
      // Level complete
      setState(() {
        score += currentSequence.length * 10;
        game.currentLevel++;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        _generateNewSequence();
      });
    }

    // Remove highlight after delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          currentStep = -1;
        });
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎵 Sequence Broken'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You remembered'),
            Text(
              '${currentSequence.length - 1} notes',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            Text('Score: $score'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('MENU'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text('TRY AGAIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Signals'),
        actions: [
          IconButton(
            onPressed: () {
              // Repeat sequence
              if (!isPlayingSequence && !isPlayerTurn) {
                _playSequence();
              }
            },
            icon: const Icon(Icons.replay),
            tooltip: 'Repeat Sequence',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'LEVEL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple[800],
                        ),
                      ),
                      Text(
                        '${game.currentLevel}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple[800],
                        ),
                      ),
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'NOTES',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple[800],
                        ),
                      ),
                      Text(
                        '${currentSequence.length}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isPlayingSequence
                          ? 'Watch and Listen...'
                          : isPlayerTurn
                          ? 'Your Turn!'
                          : 'Get Ready...',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isPlayingSequence || !isPlayerTurn)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          currentStep >= 0 &&
                                  currentStep < currentSequence.length
                              ? currentSequence[currentStep]
                              : '🎵',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (!isPlayingSequence && isPlayerTurn)
                      Column(
                        children: [
                          const Text(
                            'Repeat the sequence:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            playerSequence.join(' • '),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Press the notes in sequence:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: notes.map((note) {
                      bool isHighlighted =
                          currentStep >= 0 &&
                          playerSequence.length > currentStep &&
                          playerSequence[currentStep] == note;

                      return NoteButton(
                        note: note,
                        isHighlighted: isHighlighted,
                        onPressed: () => _onNotePressed(note),
                        enabled: isPlayerTurn && !isPlayingSequence,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: isPlayingSequence ? null : _playSequence,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('REPLAY'),
                ),
                ElevatedButton.icon(
                  onPressed: _startNewGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('NEW GAME'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
