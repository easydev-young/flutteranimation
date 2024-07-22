import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final String heroTag;

  const ControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.size,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: color,
        shape: const CircleBorder(),
        heroTag: heroTag,
        child: Icon(icon, size: size * 0.5),
      ),
    );
  }
}
