class MusicGame {
  final String id;
  final List<String> sequence;
  final int currentLevel;
  final int score;
  final bool isCompleted;

  MusicGame({
    required this.id,
    required this.sequence,
    this.currentLevel = 1,
    this.score = 0,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sequence': sequence.join(','),
      'currentLevel': currentLevel,
      'score': score,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory MusicGame.fromMap(Map<String, dynamic> map) {
    return MusicGame(
      id: map['id'],
      sequence: (map['sequence'] as String).split(','),
      currentLevel: map['currentLevel'],
      score: map['score'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
