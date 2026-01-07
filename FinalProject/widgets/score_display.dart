import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final String time;
  final String score;
  final Color? backgroundColor;
  final bool showIcons;
  final String? moves;
  final String? level;

  const ScoreDisplay({
    super.key,
    required this.time,
    required this.score,
    this.backgroundColor,
    this.showIcons = true,
    this.moves,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: showIcons ? Icons.timer : null,
            label: 'TIME',
            value: time,
            color: Colors.blue,
          ),

          _buildStatItem(
            icon: showIcons ? Icons.score : null,
            label: 'SCORE',
            value: score,
            color: Colors.green,
          ),

          if (moves != null)
            _buildStatItem(
              icon: showIcons ? Icons.directions_run : null,
              label: 'MOVES',
              value: moves!,
              color: Colors.orange,
            ),

          if (level != null)
            _buildStatItem(
              icon: showIcons ? Icons.flag : null,
              label: 'LEVEL',
              value: level!,
              color: Colors.purple,
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    IconData? icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
