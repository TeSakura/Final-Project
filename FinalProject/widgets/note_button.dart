import 'package:flutter/material.dart';

class NoteButton extends StatefulWidget {
  final String note;
  final bool isHighlighted;
  final VoidCallback onPressed;
  final bool enabled;

  const NoteButton({
    super.key,
    required this.note,
    required this.isHighlighted,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animatePress() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color textColor;
    String noteSymbol = '';

    switch (widget.note) {
      case 'Do':
        buttonColor = Colors.red[100]!;
        textColor = Colors.red[900]!;
        noteSymbol = '♪';
        break;
      case 'Re':
        buttonColor = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        noteSymbol = '♫';
        break;
      case 'Mi':
        buttonColor = Colors.yellow[100]!;
        textColor = Colors.yellow[900]!;
        noteSymbol = '♬';
        break;
      case 'Fa':
        buttonColor = Colors.green[100]!;
        textColor = Colors.green[900]!;
        noteSymbol = '🎵';
        break;
      case 'Sol':
        buttonColor = Colors.blue[100]!;
        textColor = Colors.blue[900]!;
        noteSymbol = '🎶';
        break;
      default:
        buttonColor = Colors.grey[100]!;
        textColor = Colors.grey[900]!;
        noteSymbol = '♪';
    }

    if (widget.isHighlighted) {
      buttonColor = buttonColor.withOpacity(0.7);
    }

    return GestureDetector(
      onTap: widget.enabled
          ? () {
              _animatePress();
              widget.onPressed();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: widget.isHighlighted
                      ? textColor.withOpacity(0.8)
                      : textColor.withOpacity(0.3),
                  width: widget.isHighlighted ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                  if (widget.isHighlighted)
                    BoxShadow(
                      color: textColor.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(noteSymbol, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    widget.note,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
