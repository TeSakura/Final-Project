class PlayerProgress {
  final String playerId;
  int wordSearchBestTime;
  int cardGameBestMoves;
  int musicGameMaxLevel;
  final Map<String, int> gamesPlayed;

  PlayerProgress({
    required this.playerId,
    this.wordSearchBestTime = 0,
    this.cardGameBestMoves = 999,
    this.musicGameMaxLevel = 0,
    this.gamesPlayed = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'wordSearchBestTime': wordSearchBestTime,
      'cardGameBestMoves': cardGameBestMoves,
      'musicGameMaxLevel': musicGameMaxLevel,
      'gamesPlayed': gamesPlayed.toString(),
    };
  }

  factory PlayerProgress.fromMap(Map<String, dynamic> map) {
    return PlayerProgress(
      playerId: map['playerId'],
      wordSearchBestTime: map['wordSearchBestTime'],
      cardGameBestMoves: map['cardGameBestMoves'],
      musicGameMaxLevel: map['musicGameMaxLevel'],
      gamesPlayed: _parseGamesPlayed(map['gamesPlayed']),
    );
  }

  static Map<String, int> _parseGamesPlayed(String gamesPlayedStr) {
    // Simple parsing - in real app, use JSON
    return {};
  }
}
