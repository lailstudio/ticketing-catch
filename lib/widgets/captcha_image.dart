import 'dart:math';

import 'package:flutter/material.dart';

class CaptchaImage extends StatelessWidget {
  final String text;

  const CaptchaImage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AspectRatio(
        aspectRatio: 2.2,
        child: CustomPaint(
          painter: _CaptchaPainter(text: text),
        ),
      ),
    );
  }
}

class _CaptchaPainter extends CustomPainter {
  final String text;
  late final Random _random;

  _CaptchaPainter({required this.text}) {
    _random = Random(text.hashCode);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF8B1A1A),
    );

    for (int i = 0; i < 300; i++) {
      canvas.drawCircle(
        Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        _random.nextDouble() * 2.5 + 0.5,
        Paint()
          ..color = Color.fromRGBO(
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
            0.4 + _random.nextDouble() * 0.4,
          ),
      );
    }

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        Paint()
          ..color = Color.fromRGBO(
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
            0.3,
          )
          ..strokeWidth = 1.5,
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size.height * 0.45,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A2E),
          letterSpacing: size.width * 0.04,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_CaptchaPainter oldDelegate) => text != oldDelegate.text;
}
