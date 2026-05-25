import 'dart:math';

class Star {
  double x, y, size, speed, opacity;
  double rotation = Random().nextDouble() * 2 * pi; // Eksik olan buydu
  double angle = Random().nextDouble() * pi;
  
  Star({required this.x, required this.y, required this.size, required this.speed, required this.opacity});

  void update(double h) {
    y += speed;
    angle += 0.05;
    rotation += 0.02; // Kendi etrafında dönme hızı
    opacity = (sin(angle) + 1) / 2;
    if (y > h) y = -20;
  }
}