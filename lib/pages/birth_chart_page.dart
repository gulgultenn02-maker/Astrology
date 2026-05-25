import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthChartPage extends StatefulWidget {
  const BirthChartPage({super.key});

  @override
  State<BirthChartPage> createState() => _BirthChartPageState();
}

class _BirthChartPageState extends State<BirthChartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Tüm Gezegen Verileri (İleride burası API'den gelecek)
  final List<Map<String, dynamic>> planetData = [
    {"symbol": "☉", "name": "Güneş", "sign": "Balık", "deg": 130},
    {"symbol": "☽", "name": "Ay", "sign": "Aslan", "deg": 40},
    {"symbol": "☿", "name": "Merkür", "sign": "Koç", "deg": 160},
    {"symbol": "♀", "name": "Venüs", "sign": "Kova", "deg": 310},
    {"symbol": "♂", "name": "Mars", "sign": "Akrep", "deg": 220},
    {"symbol": "♃", "name": "Jüpiter", "sign": "Yay", "deg": 10},
    {"symbol": "♄", "name": "Satürn", "sign": "Oğlak", "deg": 280},
    {"symbol": "♅", "name": "Uranüs", "sign": "Boğa", "deg": 85},
    {"symbol": "♆", "name": "Neptün", "sign": "Balık", "deg": 145},
    {"symbol": "♇", "name": "Plüton", "sign": "Oğlak", "deg": 265},
    {"symbol": "☊", "name": "Kuzey Düğüm", "sign": "İkizler", "deg": 110},
    {"symbol": "☋", "name": "Güney Düğüm", "sign": "Yay", "deg": 290},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Kozmik Taslak", 
          style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Pembe Aura Arka Plan
          Positioned(
            top: 0, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                gradient: RadialGradient(colors: [const Color(0xFFFF5252).withOpacity(0.06), Colors.white.withOpacity(0)])
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 10),
              Text("Selin Yılmaz", 
                style: GoogleFonts.bodoniModa(fontSize: 32, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400)),
              Text("12 MART 1995 • 14:30 • İSTANBUL", 
                style: GoogleFonts.inter(fontSize: 9, color: Colors.black38, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 25),

              // PROFESYONEL DOĞUM HARİTASI ÇARKI ✨
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: (1 - _controller.value) * 0.3,
                        child: Opacity(
                          opacity: _controller.value,
                          child: CustomPaint(
                            size: const Size(360, 360),
                            painter: ProfessionalBirthChartPainter(planets: planetData),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // YATAY KAYDIRILABİLİR GEZEGEN LİSTESİ ✨
              _buildHorizontalInfoList(),
              
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalInfoList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: planetData.length,
        itemBuilder: (context, index) {
          final p = planetData[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black.withOpacity(0.03)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(p["symbol"], style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 8),
                Text(p["name"], 
                  style: GoogleFonts.inter(fontSize: 9, color: Colors.black38, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                Text(p["sign"], 
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- FULL DETAYLI HARİTA ÇİZİCİSİ ✨ ---
class ProfessionalBirthChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> planets;
  ProfessionalBirthChartPainter({required this.planets});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = Colors.black.withOpacity(0.12);

    // 1. DAİRESEL KATMANLAR
    canvas.drawCircle(center, radius, mainPaint); 
    canvas.drawCircle(center, radius * 0.82, mainPaint); 
    canvas.drawCircle(center, radius * 0.45, mainPaint); 

    // 2. 12 BURÇ VE 12 EV
    final zodiacSigns = ["♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓"];
    
    for (int i = 0; i < 12; i++) {
      double angle = i * 30 * math.pi / 180;
      
      // Ev Çizgileri
      canvas.drawLine(
        Offset(center.dx + math.cos(angle) * radius * 0.45, center.dy + math.sin(angle) * radius * 0.45),
        Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius),
        mainPaint,
      );

      // Burç Sembolleri (En Dışa)
      double textAngle = (i * 30 + 15) * math.pi / 180;
      _drawText(canvas, zodiacSigns[i], 
        Offset(center.dx + math.cos(textAngle) * radius * 0.91, center.dy + math.sin(textAngle) * radius * 0.91),
        15, Colors.black54);

      // Ev Numaraları (İç Halkaya)
      _drawText(canvas, "${i + 1}", 
        Offset(center.dx + math.cos(textAngle) * radius * 0.49, center.dy + math.sin(textAngle) * radius * 0.49),
        9, Colors.black26);
    }

    // 3. GEZEGENLERİN YERLEŞİMİ ✨
    List<Offset> planetPositions = [];

    for (var p in planets) {
      double angle = p["deg"] * math.pi / 180;
      // Gezegenleri orta halkaya diziyoruz
      Offset pos = Offset(center.dx + math.cos(angle) * radius * 0.72, center.dy + math.sin(angle) * radius * 0.72);
      planetPositions.add(pos);

      // Gezegen Noktası (Minimalist kırmızı parıltı)
      canvas.drawCircle(pos, 3.5, Paint()..color = const Color(0xFFFF5252).withOpacity(0.8));
      
      // Gezegen Sembolü
      _drawText(canvas, p["symbol"], pos + const Offset(8, -18), 16, Colors.black);
    }

    // 4. AÇI AĞI (Aspects - Mistik Geometri ✨)
    final aspectPaint = Paint()..strokeWidth = 0.4;

    for (int i = 0; i < planetPositions.length; i++) {
      for (int j = i + 1; j < planetPositions.length; j++) {
        // Profesyonel görünüm için mesafeye göre renk verelim
        double dist = (planets[i]["deg"] - planets[j]["deg"]).abs();
        if (dist > 180) dist = 360 - dist;

        if (dist < 10 || dist > 85 && dist < 95 || dist > 170) {
          aspectPaint.color = Colors.red.withOpacity(0.12); // Sert açılar
          canvas.drawLine(planetPositions[i], planetPositions[j], aspectPaint);
        } else if (dist > 55 && dist < 65 || dist > 115 && dist < 125) {
          aspectPaint.color = Colors.blue.withOpacity(0.1); // Yumuşak açılar
          canvas.drawLine(planetPositions[i], planetPositions[j], aspectPaint);
        }
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, double size, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}