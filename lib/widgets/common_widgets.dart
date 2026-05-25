import 'dart:ui';
import 'package:flutter/material.dart';

// Glassmorphism Kartı
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}

// Işık Yansımalı Buton
class ReflectiveBtn extends StatefulWidget {
  final String text;
  final Color bg, txt;
  final VoidCallback onTap;
  const ReflectiveBtn({super.key, required this.text, required this.bg, required this.txt, required this.onTap});
  @override
  State<ReflectiveBtn> createState() => _ReflectiveBtnState();
}
class _ReflectiveBtnState extends State<ReflectiveBtn> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(children: [
            Container(height: 54, decoration: BoxDecoration(color: widget.bg), child: Center(child: Text(widget.text, style: TextStyle(color: widget.txt, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)))),
            AnimatedBuilder(animation: _c, builder: (c, sh) => Transform.translate(offset: Offset(-100 + (300 * _c.value), 0), child: Container(width: 40, height: 54, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0), Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0)]))))),
          ]),
      ),
    );
  }
}