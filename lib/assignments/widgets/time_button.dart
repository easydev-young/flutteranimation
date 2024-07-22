import 'package:flutter/material.dart';

class TimeButton extends StatelessWidget {
  final int minutes;
  final int selectedTime;
  final VoidCallback onPressed;

  const TimeButton({
    super.key,
    required this.minutes,
    required this.selectedTime,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedTime == minutes ? Colors.red : Colors.grey.shade300,
        ),
        child: Text(
          '$minutes',
          style: TextStyle(
            color: selectedTime == minutes ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
