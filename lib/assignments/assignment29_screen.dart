import 'package:flutter/material.dart';

class Assignment29Screen extends StatefulWidget {
  const Assignment29Screen({super.key});

  @override
  State<Assignment29Screen> createState() => _Assignment29ScreenState();
}

class _Assignment29ScreenState extends State<Assignment29Screen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _animationControllers;
  late final List<Animation<double>> _animations;
  late final List<int> _order;

  bool _isAnimating = false;
  //int _completedAnimations = 0;

  @override
  void initState() {
    super.initState();
    _order = _generateZigzagOrder(5, 5);
    _animationControllers = List<AnimationController>.generate(25, (index) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        reverseDuration: const Duration(milliseconds: 300),
      );
      controller.addStatusListener((status) {
        _eachItemsStatusListener(status, index);
      });
      return controller;
    });

    _animations = List<Animation<double>>.generate(25, (index) {
      return Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(_animationControllers[index]);
    });

    _startAnimationSequence();
  }

  List<int> _generateZigzagOrder(int rows, int cols) {
    List<int> order = [];
    for (int i = 0; i < rows; i++) {
      if (i % 2 == 0) {
        for (int j = 0; j < cols; j++) {
          order.add(i * cols + j);
        }
      } else {
        for (int j = cols - 1; j >= 0; j--) {
          order.add(i * cols + j);
        }
      }
    }
    return order;
  }

  void _startAnimationSequence() async {
    if (_isAnimating) return;
    _isAnimating = true;

    for (var index in _order) {
      _animationControllers[index].forward();
      await Future.delayed(const Duration(milliseconds: 30)); // 애니메이션 속도 조정
    }
  }

  void _eachItemsStatusListener(AnimationStatus status, int index) async {
    if (status == AnimationStatus.completed) {
      int milliseconds = 200;
      if (index % 2 == 0) milliseconds = 100;
      await Future.delayed(Duration(milliseconds: milliseconds));
      if (mounted) {
        _animationControllers[index].reverse();
      }
    } else if (status == AnimationStatus.dismissed) {
      int milliseconds = 100;
      if (index % 2 == 0) milliseconds = 200;
      await Future.delayed(Duration(milliseconds: milliseconds));
      if (mounted) {
        _animationControllers[index].forward();
      }
    }
  }

  // void _resetAnimations() async {
  //   for (var controller in _animationControllers) {
  //     controller.reset();
  //   }
  //   //_completedAnimations = 0;
  //   _isAnimating = false;
  //   _startAnimationSequence();
  // }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Explicit Animations",
        ),
      ),
      body: Center(
        child: Transform.flip(
          flipX: true,
          flipY: true,
          origin: const Offset(0, -100),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 45,
                mainAxisSpacing: 45,
              ),
              children: List.generate(
                25,
                (index) {
                  return FadeTransition(
                    opacity: _animations[index],
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFff1750),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// XXXXX
// XXXXX
// XXXXX
// XXXXX
// XXXOX

// XXXXX
// XXXXX
// XXXXX
// XXXXX
// XXOXO

// XXXXX
// XXXXX
// XXXXX
// XXXXX
// XXOOO

// XXXXX
// XXXXX
// XXXXX
// XXXXX
// OXOOO


// XXXXX
// XXXXX
// XXXXX
// OXXXX
// XOOOO

// XXXXX
// XXXXX
// XXXXX
// XOXXX
// OOOOO

// XXXXX
// XXXXX
// XXXXX
// OOXOX
// OOOOO


// XXXXX
// XXXXX
// XXXXX
// OOOXO
// OOOOO


// XXXXX
// XXXXX
// XXXXO
// OOOOX
// OOOOO


// XXXXX
// XXXXX
// XXOXO
// OOOOO
// OOOOO