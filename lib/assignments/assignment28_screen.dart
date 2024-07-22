import 'dart:async';

import 'package:flutter/material.dart';

class Assignment28Screen extends StatefulWidget {
  const Assignment28Screen({super.key});

  @override
  State<Assignment28Screen> createState() => _Assignment28ScreenState();
}

class _Assignment28ScreenState extends State<Assignment28Screen> {
  bool selected = true;
  late Timer _timer;
  final Duration _duration = const Duration(seconds: 1);

  void _trigger() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(_duration, (timer) {
      _trigger();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selected ? Colors.white : Colors.black,
      appBar: AppBar(
        title: const Text('Implicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                shape: selected ? BoxShape.circle : BoxShape.rectangle,
                color: Colors.red,
              ),
              child: AnimatedAlign(
                alignment:
                    selected ? Alignment.centerLeft : Alignment.centerRight,
                duration: _duration,
                child: Container(
                  width: 15,
                  color: selected ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
