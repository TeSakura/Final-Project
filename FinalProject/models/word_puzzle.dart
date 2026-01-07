class WordPuzzle {
  final String id;
  final List<String> grid;
  final List<String> wordsToFind;
  final List<String> foundWords;
  final DateTime? completedAt;
  final int timeTaken; // in seconds

  WordPuzzle({
    required this.id,
    required this.grid,
    required this.wordsToFind,
    this.foundWords = const [],
    this.completedAt,
    this.timeTaken = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'grid': grid.join(','),
      'wordsToFind': wordsToFind.join(','),
      'foundWords': foundWords.join(','),
      'completedAt': completedAt?.toIso8601String(),
      'timeTaken': timeTaken,
    };
  }

  factory WordPuzzle.fromMap(Map<String, dynamic> map) {
    return WordPuzzle(
      id: map['id'],
      grid: (map['grid'] as String).split(','),
      wordsToFind: (map['wordsToFind'] as String).split(','),
      foundWords: (map['foundWords'] as String).split(','),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      timeTaken: map['timeTaken'],
    );
  }
}
