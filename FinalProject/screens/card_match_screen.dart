import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neuroblitz/models/card_game.dart';
import 'package:neuroblitz/widgets/card_widget.dart';

class CardMatchScreen extends StatefulWidget {
  const CardMatchScreen({super.key});

  @override
  State<CardMatchScreen> createState() => _CardMatchScreenState();
}

class _CardMatchScreenState extends State<CardMatchScreen> {
  late CardGame game;
  List<CardModel> selectedCards = [];
  int moves = 0;
  bool isProcessing = false;
  Timer? _successTimer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _successTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    List<String> icons = ['🧠', '❤️', '💊', '🏥', '🎵', '🌟', '⚕️', '🌈'];
    icons = [...icons, ...icons]; // Create pairs
    icons.shuffle();

    List<CardModel> cards = [];
    for (int i = 0; i < icons.length; i++) {
      cards.add(CardModel(id: i.toString(), icon: icons[i]));
    }

    game = CardGame(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cards: cards,
      startedAt: DateTime.now(),
    );
  }

  void _onCardTap(CardModel card) {
    if (isProcessing || card.isMatched || card.isFlipped) return;

    setState(() {
      card.isFlipped = true;
      selectedCards.add(card);

      if (selectedCards.length == 2) {
        moves++;
        isProcessing = true;
        _checkForMatch();
      }
    });
  }

  void _checkForMatch() {
    CardModel card1 = selectedCards[0];
    CardModel card2 = selectedCards[1];

    if (card1.icon == card2.icon) {
      // Match found
      setState(() {
        card1.isMatched = true;
        card2.isMatched = true;
      });

      // Check if game is complete
      bool allMatched = game.cards.every((card) => card.isMatched);
      if (allMatched) {
        game.completedAt = DateTime.now();
        game.moves = moves;
        _showCompletionDialog();
      }

      selectedCards.clear();
      isProcessing = false;
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          card1.isFlipped = false;
          card2.isFlipped = false;
          selectedCards.clear();
          isProcessing = false;
        });
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎊 Perfect Memory!'),
        content: Text(
          'You matched all pairs in $moves moves!',
          style: const TextStyle(fontSize: 18),
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
              _resetGame();
            },
            child: const Text('PLAY AGAIN'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      moves = 0;
      selectedCards.clear();
      isProcessing = false;
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Cards'),
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'MOVES',
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                      Text(
                        '$moves',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'PAIRS FOUND',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        '${game.cards.where((c) => c.isMatched).length ~/ 2}/8',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.9,
                ),
                itemCount: game.cards.length,
                itemBuilder: (context, index) {
                  final card = game.cards[index];
                  return CardWidget(card: card, onTap: () => _onCardTap(card));
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Show all cards briefly
                      setState(() {
                        for (var card in game.cards) {
                          if (!card.isMatched) {
                            card.isFlipped = true;
                          }
                        }
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          for (var card in game.cards) {
                            if (!card.isMatched) {
                              card.isFlipped = false;
                            }
                          }
                        });
                      });
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('PEEK'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _resetGame,
                    icon: const Icon(Icons.replay),
                    label: const Text('NEW GAME'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
