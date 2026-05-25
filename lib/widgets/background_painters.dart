import 'package:flutter/material.dart';
import '../models/star.dart';

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final Color starColor;
  StarPainter(this.stars, this.starColor);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    for (var s in stars) {
      p.color = starColor.withValues(alpha: s.opacity * 0.35); 
      canvas.save();
      canvas.translate(s.x, s.y);
      canvas.rotate(s.rotation);
      canvas.drawLine(const Offset(0, -5), const Offset(0, 5), p..strokeWidth = 1.0);
      canvas.drawLine(const Offset(-5, 0), const Offset(5, 0), p);
      canvas.drawCircle(Offset.zero, s.size * 0.4, p);
      canvas.restore();
    }
  }
  @override bool shouldRepaint(CustomPainter old) => true;
}

class ThreeZoneBackgroundPainter extends CustomPainter {
  final Color top, mid, bottom;
  ThreeZoneBackgroundPainter(this.top, this.mid, this.bottom);
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var paint = Paint()..shader = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [top, mid, bottom], stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, paint);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}