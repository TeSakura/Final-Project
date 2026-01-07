import 'dart:math';

class GameLogic {
  // WORD SEARCH LOGIC
  static List<String> generateWordSearchGrid(List<String> words) {
    // Create 10x10 grid
    List<List<String>> grid = List.generate(10, (_) => List.filled(10, ''));

    // Place words (simplified - in real app, implement proper placement)
    for (String word in words) {
      _placeWordInGrid(grid, word.toUpperCase());
    }

    // Fill empty cells with random letters
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (grid[i][j].isEmpty) {
          grid[i][j] = String.fromCharCode(Random().nextInt(26) + 65);
        }
      }
    }

    // Convert to string format
    return grid.map((row) => row.join(',')).toList();
  }

  static void _placeWordInGrid(List<List<String>> grid, String word) {
    // Simplified placement - always horizontal for now
    int row = Random().nextInt(10);
    int col = Random().nextInt(10 - word.length);

    for (int i = 0; i < word.length; i++) {
      grid[row][col + i] = word[i];
    }
  }

  static bool isWordFound(List<List<String>> grid, String word) {
    // Check all 8 directions
    List<List<int>> directions = [
      [0, 1], // Right
      [0, -1], // Left
      [1, 0], // Down
      [-1, 0], // Up
      [1, 1], // Down-Right
      [1, -1], // Down-Left
      [-1, 1], // Up-Right
      [-1, -1], // Up-Left
    ];

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        for (var dir in directions) {
          if (_checkDirection(grid, i, j, dir[0], dir[1], word)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static bool _checkDirection(
    List<List<String>> grid,
    int row,
    int col,
    int dr,
    int dc,
    String word,
  ) {
    for (int i = 0; i < word.length; i++) {
      int r = row + i * dr;
      int c = col + i * dc;

      if (r < 0 || r >= 10 || c < 0 || c >= 10) return false;
      if (grid[r][c] != word[i]) return false;
    }
    return true;
  }

  // CARD MATCH LOGIC
  static List<String> generateCardIcons(int pairCount) {
    List<String> allIcons = [
      '🧠',
      '❤️',
      '💊',
      '🏥',
      '🎵',
      '🌟',
      '⚕️',
      '🌈',
      '✨',
      '🚑',
    ];
    List<String> selectedIcons = allIcons.sublist(0, pairCount);
    List<String> pairs = [...selectedIcons, ...selectedIcons];
    pairs.shuffle();
    return pairs;
  }

  static int calculateMatchScore(int moves, int totalPairs, int timeInSeconds) {
    int baseScore = totalPairs * 100;
    int moveBonus = (50 - moves).clamp(0, 50) * 10;
    int timeBonus = (300 - timeInSeconds).clamp(0, 300);

    return baseScore + moveBonus + timeBonus;
  }

  // MEMORY SIGNALS LOGIC
  static List<String> generateNoteSequence(int length) {
    List<String> notes = ['Do', 'Re', 'Mi', 'Fa', 'Sol'];
    List<String> sequence = [];

    for (int i = 0; i < length; i++) {
      sequence.add(notes[Random().nextInt(notes.length)]);
    }

    return sequence;
  }

  static int calculateSequenceScore(int level, bool perfect) {
    int baseScore = level * 50;
    int bonus = perfect ? 100 : 0;
    int speedBonus = (10 - (level ~/ 2)).clamp(0, 10) * 10;

    return baseScore + bonus + speedBonus;
  }

  static int calculateDifficulty(int currentLevel, int consecutiveWins) {
    double base = 1.0;

    if (currentLevel > 5) base += 0.3;
    if (currentLevel > 10) base += 0.5;
    if (consecutiveWins > 3) base += 0.2;

    return base.clamp(1.0, 3.0).toInt();
  }

  // PROGRESS CALCULATIONS
  static String calculateSkillLevel(int totalScore) {
    if (totalScore < 1000) return 'Beginner 🐣';
    if (totalScore < 5000) return 'Intermediate 🧠';
    if (totalScore < 10000) return 'Advanced 🚀';
    return 'Expert 🏆';
  }

  static double calculateImprovementRate(List<int> recentScores) {
    if (recentScores.length < 2) return 0.0;

    int sum = 0;
    for (int i = 1; i < recentScores.length; i++) {
      sum += recentScores[i] - recentScores[i - 1];
    }

    return sum / (recentScores.length - 1);
  }
}
