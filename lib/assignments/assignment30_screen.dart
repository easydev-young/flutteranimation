import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_ani_master/assignments/widgets/control_button.dart';
import 'package:flutter_ani_master/assignments/widgets/time_button.dart';

class Assignment30Screen extends StatefulWidget {
  const Assignment30Screen({super.key});

  @override
  State<Assignment30Screen> createState() => _Assignment30ScreenState();
}

class _Assignment30ScreenState extends State<Assignment30Screen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Animation<Color?> _colorAnimation;
  bool _isPlaying = false;
  Timer? _timer;
  int _timeElapsed = 0;
  int _totalTime = 15 * 60;
  int _selectedTime = 15;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalTime),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isPlaying = false;
        }
      });

    _colorAnimation = ColorTween(
      begin: Colors.red.shade200,
      end: Colors.red.shade500,
    ).animate(_controller);
  }

  void _startTimer() {
    if (!_isPlaying) {
      _isPlaying = true;
      _controller.forward(from: _timeElapsed / _totalTime);
      _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        setState(() {
          _timeElapsed = _timeElapsed + 1;
          _controller.value = _timeElapsed / _totalTime;
          if (_timeElapsed >= _totalTime) {
            timer.cancel();
            _isPlaying = false;
            _resetTimer();
          }
        });
      });
    }
  }

  void _pauseTimer() {
    if (_isPlaying) {
      _controller.stop();
      _timer?.cancel();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _stopTimer() {
    _controller.stop();
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _timeElapsed = 0;
    });
  }

  void _resetTimer() {
    _controller.reset();
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _timeElapsed = 0;
    });
  }

  void _setTime(int minutes) {
    if (_isPlaying) return;
    setState(() {
      _selectedTime = minutes;
      _totalTime = minutes * 60;
      _controller.duration = Duration(seconds: _totalTime);
      _resetTimer();
    });
  }

  late final Animation<double> _progress = Tween(
    begin: 0.000,
    end: 2.0,
  ).animate(_animation);

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Painter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _progress,
              builder: (context, child) {
                return CustomPaint(
                  painter: TimerPainter(
                    progress: _progress.value,
                    color: _colorAnimation.value!,
                  ),
                  size: const Size(200, 200),
                  child: Center(
                    child: Text(
                      format(_totalTime - _timeElapsed),
                      style: const TextStyle(fontSize: 40, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeButton(
                  minutes: 15,
                  selectedTime: _selectedTime,
                  onPressed: () => _setTime(15),
                ),
                TimeButton(
                  minutes: 20,
                  selectedTime: _selectedTime,
                  onPressed: () => _setTime(20),
                ),
                TimeButton(
                  minutes: 25,
                  selectedTime: _selectedTime,
                  onPressed: () => _setTime(25),
                ),
                TimeButton(
                  minutes: 30,
                  selectedTime: _selectedTime,
                  onPressed: () => _setTime(30),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ControlButton(
                  icon: Icons.refresh,
                  onPressed: _resetTimer,
                  color: Colors.grey,
                  size: 50,
                  heroTag: 'refreshButton',
                ),
                const SizedBox(width: 20),
                ControlButton(
                  icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: _isPlaying ? _pauseTimer : _startTimer,
                  color: Colors.red,
                  size: 100,
                  heroTag: 'playPauseButton',
                ),
                const SizedBox(width: 20),
                ControlButton(
                  icon: Icons.stop,
                  onPressed: _stopTimer,
                  color: Colors.grey,
                  size: 50,
                  heroTag: 'stopButton',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  TimerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const startingAngle = -0.5 * pi;

    final greyCirclePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final circleRadius = (size.width / 2) * 0.7;

    canvas.drawCircle(
      center,
      circleRadius,
      greyCirclePaint,
    );

    final redArcRect = Rect.fromCircle(
      center: center,
      radius: circleRadius,
    );

    final redArcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      progress * pi,
      false,
      redArcPaint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
