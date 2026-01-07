import 'package:flutter/material.dart';
import 'package:neuroblitz/models/card_game.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.green[100]
              : card.isFlipped
              ? Colors.white
              : Colors.blue[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: card.isMatched
                ? Colors.green
                : card.isFlipped
                ? Colors.blue[200]!
                : Colors.blue[400]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: card.isFlipped || card.isMatched
                ? Text(card.icon, style: const TextStyle(fontSize: 32))
                : const Icon(
                    Icons.question_mark,
                    size: 32,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
