import 'dart:math';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({Key? key}) : super(key: key);

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentRotation = 0;
  int totalSpins = 6;
  int tokensWon = 8;
  int spinsLeft = 1;

  final List<WheelSegment> segments = [
    WheelSegment('1000 Token', Colors.white),
    WheelSegment('1000 Token', ColorConstants.primaryPurple),
    WheelSegment('0 Token', Colors.white),
    WheelSegment('1 Token', ColorConstants.primaryPurple),
    WheelSegment('10 Token', Colors.white),
    WheelSegment('100 Token', ColorConstants.primaryPurple),
    WheelSegment('500 Token', Colors.white),
    WheelSegment('1000 Token', ColorConstants.primaryPurple),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addListener(() {
      setState(() {
        _currentRotation = _controller.value * 2 * pi;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_controller.isAnimating) return;
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Spin wheel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorConstants.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatRow('Total No. of Spins', '06'),
                    _buildStatRow('Tokens wonfrom Spin', '08',
                        color: ColorConstants.primaryPurple),
                    _buildStatRow('No. of Spins Left', '01',
                        color: Color(0xFF6750A4)),
                  ],
                ),
              ),
            ),

            // Spin Wheel
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.secondaryBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: _currentRotation,
                              child: CustomPaint(
                                size: const Size(280, 280),
                                painter: WheelPainter(segments: segments),
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _spinWheel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primaryPurple,
                          minimumSize: const Size(200, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Click here to Spin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Free Tokens will be instantly credited to your wallet account when you win. You can only spin 5 times a day. So you can come back and try your luck !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class WheelSegment {
  final String text;
  final Color color;

  WheelSegment(this.text, this.color);
}

class WheelPainter extends CustomPainter {
  final List<WheelSegment> segments;

  WheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double segmentAngle = 2 * pi / segments.length;

    // Paint for segments
    final Paint segmentPaint = Paint()..style = PaintingStyle.fill;

    // Paint for borders
    final Paint borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Paint for outer circle
    final Paint circlePaint = Paint()
      ..color = ColorConstants.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // Draw segments
    for (int i = 0; i < segments.length; i++) {
      final double startAngle = i * segmentAngle;
      segmentPaint.color = segments[i].color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        segmentPaint,
      );

      // Draw segment borders
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        borderPaint,
      );

      // Draw text
      _drawRotatedText(
        canvas,
        segments[i].text,
        center,
        radius * 0.7,
        startAngle + segmentAngle / 2,
        segments[i].color == Colors.white
            ? ColorConstants.darkBackground
            : Colors.white,
      );
    }

    // Draw outer circle
    canvas.drawCircle(center, radius, circlePaint);

    // Draw dots on the outer circle
    final int numberOfDots = 12;
    final double dotRadius = 4;
    for (int i = 0; i < numberOfDots; i++) {
      final double angle = i * (2 * pi / numberOfDots);
      final double x = center.dx + (radius + 10) * cos(angle);
      final double y = center.dy + (radius + 10) * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        dotRadius,
        Paint()..color = Colors.white,
      );
    }
  }

  void _drawRotatedText(Canvas canvas, String text, Offset center,
      double radius, double angle, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + pi / 2);
    canvas.translate(0, -radius);
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
