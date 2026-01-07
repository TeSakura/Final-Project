import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neuroblitz/models/word_puzzle.dart';
import 'package:neuroblitz/widgets/score_display.dart';

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  late WordPuzzle puzzle;
  late Timer _timer;
  int _seconds = 0;
  int _foundCount = 0;
  List<String> _selectedLetters = [];

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initializePuzzle() {
    // Example puzzle grid (10x10)
    List<String> grid = [
      'T,B,I,H,A,E,M,I,D,Y',
      'B,R,A,I,N,X,Z,W,V,G',
      'S,T,R,O,K,E,U,R,P,Q',
      'R,E,C,O,V,E,R,Y,A,L',
      'M,A,F,O,T,I,M,E,Z,H',
      'S,E,A,R,C,H,E,S,O,I',
      'O,I,A,K,L,N,S,X,P,E',
      'S,T,R,O,K,E,B,N,U,R',
      'I,P,T,E,J,U,H,R,G,A',
      'L,D,A,K,S,P,I,C,I,P',
    ];

    List<String> wordsToFind = [
      'TBI',
      'STROKE',
      'BRAIN',
      'RECOVERY',
      'THERAPY',
      'EXERCISE',
      'HEAL',
      'MIND',
    ];

    puzzle = WordPuzzle(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      grid: grid,
      wordsToFind: wordsToFind,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _onLetterSelected(int row, int col) {
    setState(() {
      String letter = puzzle.grid[row].split(',')[col];
      _selectedLetters.add('$row,$col:$letter');

      // Check if selected letters form a word
      _checkForWord();
    });
  }

  void _checkForWord() {
    // Simple word checking logic
    String selectedWord = _selectedLetters
        .map((e) => e.split(':')[1])
        .join('')
        .toUpperCase();

    if (puzzle.wordsToFind.contains(selectedWord) &&
        !puzzle.foundWords.contains(selectedWord)) {
      setState(() {
        _foundCount++;
        puzzle.foundWords.add(selectedWord);
        _selectedLetters.clear();
      });

      if (_foundCount == puzzle.wordsToFind.length) {
        _timer.cancel();
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Puzzle Complete!'),
        content: Text(
          'You found all ${puzzle.wordsToFind.length} words in $_seconds seconds!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('BACK TO MENU'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _seconds = 0;
                _foundCount = 0;
                _initializePuzzle();
                _startTimer();
              });
            },
            child: const Text('PLAY AGAIN'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Search'),
        actions: [
          IconButton(
            onPressed: () {
              // Hint functionality
            },
            icon: const Icon(Icons.lightbulb),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ScoreDisplay(
              time: _formatTime(_seconds),
              score: '$_foundCount/${puzzle.wordsToFind.length}',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 100, // 10x10 grid
                  itemBuilder: (context, index) {
                    int row = index ~/ 10;
                    int col = index % 10;
                    List<String> rowLetters = puzzle.grid[row].split(',');
                    String letter = rowLetters[col];

                    bool isSelected = _selectedLetters.any(
                      (e) => e.startsWith('$row,$col'),
                    );
                    bool isFound = puzzle.foundWords.any(
                      (word) => word.contains(letter),
                    );

                    return GestureDetector(
                      onTap: () => _onLetterSelected(row, col),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.yellow[200]
                              : isFound
                              ? Colors.green[200]
                              : Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.blue[100]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.blue[900]
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: puzzle.wordsToFind.map((word) {
                  bool isFound = puzzle.foundWords.contains(word);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isFound ? Colors.green[100] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isFound ? Colors.green : Colors.blue[200]!,
                      ),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isFound ? Colors.green[900] : Colors.blue[900],
                        decoration: isFound
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _selectedLetters.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('CLEAR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[100],
                    foregroundColor: Colors.orange[900],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCompletionDialog(),
                  icon: const Icon(Icons.flag),
                  label: const Text('GIVE UP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[900],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
