class CardGame {
  final String id;
  final List<CardModel> cards;
  final int moves;
  final bool isCompleted;
  final DateTime? startedAt;
  final DateTime? completedAt;

  CardGame({
    required this.id,
    required this.cards,
    this.moves = 0,
    this.isCompleted = false,
    this.startedAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cards': cards.map((card) => card.toJson()).toList(),
      'moves': moves,
      'isCompleted': isCompleted ? 1 : 0,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class CardModel {
  final String id;
  final String icon;
  bool isMatched;
  bool isFlipped;

  CardModel({
    required this.id,
    required this.icon,
    this.isMatched = false,
    this.isFlipped = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'isMatched': isMatched,
      'isFlipped': isFlipped,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      icon: json['icon'],
      isMatched: json['isMatched'],
      isFlipped: json['isFlipped'],
    );
  }
}
