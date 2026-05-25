import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DestinyMatrixPage extends StatefulWidget {
  const DestinyMatrixPage({super.key});

  @override
  State<DestinyMatrixPage> createState() => _DestinyMatrixPageState();
}

class _DestinyMatrixPageState extends State<DestinyMatrixPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Kader Matrisi", 
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Arka Plan Aura
          Positioned(
            top: 50, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                gradient: RadialGradient(colors: [const Color(0xFFFFB6C1).withOpacity(0.15), Colors.white.withOpacity(0)])
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              
              // GEOMETRİK MATRİS ALANI ✨
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _controller.value,
                        child: CustomPaint(
                          size: const Size(320, 320),
                          painter: MatrixGeometryPainter(progress: _controller.value),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // MATRİS DETAY KARTLARI (Yatay Kaydırılabilir)
              _buildMatrixDetails(),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text("Ruhunun Geometrisi", 
          style: GoogleFonts.bodoniModa(fontSize: 28, fontStyle: FontStyle.italic, color: const Color(0xFF4A3B3B))),
        const SizedBox(height: 8),
        Text("Sayıların rehberliğinde kader yolunu keşfet.", 
          style: GoogleFonts.inter(fontSize: 11, color: Colors.black38, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildMatrixDetails() {
    final List<Map<String, String>> items = [
      {"title": "Karakter", "desc": "Liderlik ve güç potansiyeli", "num": "8"},
      {"title": "Para", "desc": "Bolluk ve bereket kanalı", "num": "15"},
      {"title": "Aşk", "desc": "Ruh eşi ve ilişkiler", "num": "6"},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
              border: Border.all(color: const Color(0xFFD48B93).withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12, backgroundColor: const Color(0xFF4A3B3B),
                  child: Text(items[index]["num"]!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Text(items[index]["title"]!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(items[index]["desc"]!, style: GoogleFonts.inter(fontSize: 10, color: Colors.black45)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- KADER MATRİSİ ÇİZİCİSİ ✨ ---
class MatrixGeometryPainter extends CustomPainter {
  final double progress;
  MatrixGeometryPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;
    
    final linePaint = Paint()
      ..color = const Color(0xFFD48B93).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final parlayanPaint = Paint()
      ..color = const Color(0xFFD48B93)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // 1. İki Kareyi Çiz (Sekizgen Yıldız Formu)
    _drawRotatingSquare(canvas, center, radius, 0, linePaint);
    _drawRotatingSquare(canvas, center, radius, math.pi / 4, linePaint);

    // 2. İç Bağlantı Çizgileri (Mistik Görünüm)
    canvas.drawCircle(center, radius * 0.4, linePaint);
    
    // 3. Köşelerdeki Arkana Numaraları (Orblar) ✨
    for (int i = 0; i < 8; i++) {
      double angle = i * math.pi / 4;
      Offset point = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
      
      // Nokta Parlaması
      canvas.drawCircle(point, 3, Paint()..color = const Color(0xFF4A3B3B));
      
      // Numara Baloncukları
      if (progress > 0.8) {
        _drawSmallCircle(canvas, point, "${(i * 3 + 1) % 22}");
      }
    }
  }

  void _drawRotatingSquare(Canvas canvas, Offset center, double radius, double angleOffset, Paint paint) {
    Path path = Path();
    for (int i = 0; i < 4; i++) {
      double angle = angleOffset + (i * math.pi / 2);
      Offset point = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
      if (i == 0) path.moveTo(point.dx, point.dy);
      else path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSmallCircle(Canvas canvas, Offset pos, String text) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos + const Offset(8, -12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}