import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7),
            borderRadius: BorderRadius.circular(size * 15 / 64),
          ),
          child: const CustomPaint(painter: _LogoPainter()),
        ),
        const SizedBox(height: 12),
        Text(
          'Task Manager',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: -0.24,
              ),
        ),
      ],
    );
  }
}

/// Compact logo mark + title for use inside an [AppBar] title slot.
class AppBarLogo extends StatelessWidget {
  final String title;
  const AppBarLogo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const CustomPaint(painter: _LogoPainter()),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191C1E),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  // All coordinates normalised against the SVG's 240×240 inner icon rect
  // (original elements are on a 400×400 canvas with the rect starting at (80,80)).
  static const double _d = 240;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = s * (16 / _d)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(s * 48 / _d, s * 88 / _d),
      Offset(s * 116 / _d, s * 88 / _d),
      linePaint,
    );
    canvas.drawLine(
      Offset(s * 48 / _d, s * 130 / _d),
      Offset(s * 128 / _d, s * 130 / _d),
      linePaint,
    );
    canvas.drawLine(
      Offset(s * 48 / _d, s * 172 / _d),
      Offset(s * 92 / _d, s * 172 / _d),
      linePaint,
    );

    final checkPath = Path()
      ..moveTo(s * 128 / _d, s * 98 / _d)
      ..lineTo(s * 152 / _d, s * 138 / _d)
      ..lineTo(s * 210 / _d, s * 62 / _d);

    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.white
        ..strokeWidth = s * (20 / _d)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
