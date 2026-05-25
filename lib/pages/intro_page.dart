import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  final VoidCallback onNext;
  const IntroPage({super.key, required this.onNext});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  double _dragValue = 0.0;
  late AnimationController _shimmerController;
  late AnimationController _cosmicController; 

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _cosmicController = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _cosmicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const auraColor = Color(0xFFFFB6C1); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. KATMAN: MERKEZDEKİ BÜYÜK PEMBE AURA ---
          Center(
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: auraColor.withOpacity(0.6),
                    blurRadius: 200,
                    spreadRadius: 40,
                  )
                ],
              ),
            ),
          ),

          // --- 2. KATMAN: KUYRUKLU YILDIZLAR VE ÇİZGİLER (EKSİLTİLMEDİ ✨) ---
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _cosmicController,
              builder: (context, child) {
                return CustomPaint(
                  painter: AstrologyPainter(
                    animationValue: _cosmicController.value,
                    color: const Color(0xFFFF5252).withOpacity(0.4),
                  ),
                );
              },
            ),
          ),

          // --- 3. KATMAN: SOL DİKEY BUZLU CAM PANEL ---
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: size.width * 0.45, 
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    border: Border(right: BorderSide(color: Colors.black.withOpacity(0.05))),
                  ),
                ),
              ),
            ),
          ),

          // --- 4. KATMAN: LOGO VE İÇERİK (KÜÇÜLTÜLDÜ VE DAHA DA SOLA ALINDI ✨) ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 25), // Sol boşluk 12'ye çekildi
              child: SizedBox(
                width: size.width * 0.42, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 85),
                    
                    // --- ASTROSE LOGO (Karakteristik & Küçük ✨) ---
                    _buildJupiterLogo(),
                    
                    const Spacer(flex: 2),

                    // --- ÖZLÜ SÖZ ---
                    Text(
                      "evrenin sessiz müziğini kalbinde hisset.",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 10, // Bir tık küçültüldü
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                        height: 1.5,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),

          // --- 5. KATMAN: SAĞ ALT KAYDIRMALI BUTON ---
          Positioned(
            bottom: 60,
            right: 30,
            child: _buildNarinSlider(),
          ),
        ],
      ),
    );
  }

  // JÜPİTER LOGO BİLEŞENİ (Boyutlar 36'ya çekildi ✨)
  Widget _buildJupiterLogo() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        double jupiterShimmerPos = 0.5; 
        double diff = (_shimmerController.value - jupiterShimmerPos).abs();
        double glowIntensity = (1.0 - (diff * 5)).clamp(0.0, 1.0);

        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [Colors.black, Colors.grey, Colors.black],
            stops: [
              _shimmerController.value - 0.2, 
              _shimmerController.value, 
              _shimmerController.value + 0.2
            ],
          ).createShader(bounds),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ASTR",
                style: GoogleFonts.bodoniModa(
                  fontSize: 36, // 42'den 36'ya indirildi
                  fontWeight: FontWeight.w400, 
                  fontStyle: FontStyle.italic, 
                  letterSpacing: -1, 
                  color: Colors.white
                ),
              ),
              // JÜPİTER: KÜÇÜLTÜLDÜ (32x32) ✨
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomPaint(
                  size: const Size(32, 32), 
                  painter: MiniJupiterPainter(glowIntensity: glowIntensity),
                ),
              ),
              Text(
                "SE",
                style: GoogleFonts.bodoniModa(
                  fontSize: 36, // 42'den 36'ya indirildi
                  fontWeight: FontWeight.w400, 
                  fontStyle: FontStyle.italic, 
                  letterSpacing: -1, 
                  color: Colors.white
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNarinSlider() {
    double maxWidth = 180.0;
    double buttonSize = 52.0;
    double maxDrag = maxWidth - buttonSize - 8;
    return Container(
      width: maxWidth, height: 60, padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), 
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]
      ),
      child: Stack(
        children: [
          const Center(child: Text("Keşfet", style: TextStyle(color: Colors.white24, fontSize: 13, letterSpacing: 3))),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100), left: _dragValue,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) => setState(() { _dragValue += details.delta.dx; if (_dragValue < 0) _dragValue = 0; if (_dragValue > maxDrag) _dragValue = maxDrag; }),
              onHorizontalDragEnd: (details) { if (_dragValue >= maxDrag * 0.8) { setState(() => _dragValue = maxDrag); widget.onNext(); } else { setState(() => _dragValue = 0); } },
              child: Container(
                width: buttonSize, height: buttonSize, 
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), 
                child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 16)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- JÜPİTER ÇİZİCİSİ ---
class MiniJupiterPainter extends CustomPainter {
  final double glowIntensity;
  MiniJupiterPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(15 * math.pi / 180); // 15 derece eğik
    canvas.translate(-center.dx, -center.dy);

    Color planetColor = Color.lerp(Colors.black, const Color(0xFFFFB6C1), glowIntensity)!;
    Color lightPoint = Color.lerp(Colors.grey, Colors.white, glowIntensity)!;

    paint.shader = RadialGradient(
      colors: [lightPoint, planetColor],
      center: const Alignment(-0.3, -0.3),
    ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.35));
    
    canvas.drawCircle(center, size.width * 0.35, paint);

    final ringPaint = Paint()
      ..color = planetColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawOval(Rect.fromCenter(center: center, width: size.width * 1.0, height: size.width * 0.25), ringPaint);
    
    canvas.restore();
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- ARKA PLAN ÇİZİCİ ---
class AstrologyPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  AstrologyPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.55, size.height * 0.5);
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animationValue * 2 * math.pi);
    canvas.drawCircle(Offset.zero, size.width * 0.5, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width * 1.3, height: size.width * 0.45), paint);
    canvas.restore();

    final rand = math.Random(123); 
    final List<Offset> points = [];
    for (int i = 0; i < 15; i++) {
      points.add(Offset(
        size.width * 0.35 + rand.nextDouble() * size.width * 0.5,
        size.height * 0.2 + rand.nextDouble() * size.height * 0.6,
      ));
    }

    for (int i = 0; i < points.length - 1; i++) {
      double blink = (math.sin(animationValue * 10 * math.pi + i) + 1) / 2;
      canvas.drawLine(points[i], points[i + 1], Paint()..color = color.withOpacity(blink * 0.2)..strokeWidth = 0.5);
    }

    for (int i = 0; i < points.length; i++) {
      double blink = (math.sin(animationValue * 15 * math.pi + i) + 1) / 2;
      canvas.drawCircle(points[i], 2, Paint()..color = color.withOpacity(blink * 0.8)..style = PaintingStyle.fill);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}