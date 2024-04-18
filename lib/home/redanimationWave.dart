import 'dart:math';

import 'package:customer_portal/config/themes.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveAnimation extends StatefulWidget {
  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // Synchronize animation with this widget
      duration: Duration(seconds: 2), // Animation duration
    )..repeat(reverse: true); // Repeat the animation back and forth
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context)
                  .size
                  .height), // Set the size of the custom paint
          painter: WavePainter(
              _controller.value), // Use the WavePainter to paint the wave
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }
}


class WavePainter extends CustomPainter {
  final double animationValue; // Animation value to control the wave height

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 1.0; // Stroke width
    final spreadAmount = 1.0; // Amount of spread

    // Draw the red stroke lines
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final y = size.height * 0.56 +
          animationValue *
              30 *
              math.sin((i / size.width) * 3 * math.pi); // Calculate wave shape

      // Draw the stroke line with spread
      canvas.drawShadow(
        Path()
          ..moveTo(x, size.height)
          ..lineTo(x, y),
        Colors.red.shade400,
        spreadAmount,
        false,
      );

      // Draw the stroke line without spread
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, y),
        Paint()
          ..color = Colors.red.shade400
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint the wave continuously
  }
}

