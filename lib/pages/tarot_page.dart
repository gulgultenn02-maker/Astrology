import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TarotPage extends StatefulWidget {
  const TarotPage({super.key});

  @override
  State<TarotPage> createState() => _TarotPageState();
}

class _TarotPageState extends State<TarotPage> with SingleTickerProviderStateMixin {
  final List<int> selectedCards = [];
  final int totalCards = 78;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _toggleCard(int index) {
    setState(() {
      if (selectedCards.contains(index)) {
        selectedCards.remove(index);
      } else if (selectedCards.length < 3) {
        selectedCards.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F8), // Çok hafif krem/nude zemin
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Tarot Rehberliği", 
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. KATMAN: ÜST PEMBE AURA
          Positioned(
            top: -100, left: 0, right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [const Color(0xFFFFB6C1).withOpacity(0.25), Colors.white.withOpacity(0)],
                ),
              ),
            ),
          ),

          // 2. KATMAN: YILDIZ TOZU
          Positioned.fill(
            child: StarFieldPainterWidget(
              controller: _shimmerController, 
              starColor: const Color(0xFFD48B93).withOpacity(0.3)
            ),
          ),

          // 3. KATMAN: İÇERİK
          Column(
            children: [
              const SizedBox(height: 15),
              _buildHeader(),
              const SizedBox(height: 25),
              
              // KART DESTE ALANI (ESTETİK GRADYANLI KARTLAR ✨)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Daha belirgin olması için 3'e geri döndük
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: totalCards,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCards.contains(index);
                    return GestureDetector(
                      onTap: () => _toggleCard(index),
                      child: _buildAestheticCard(index, isSelected),
                    );
                  },
                ),
              ),

              // SEÇİLEN KARTLAR PANELİ (CAM EFEKTİ ✨)
              _buildSelectedCardsPanel(),
            ],
          ),
          
          if (selectedCards.length == 3) _buildRevealButton(),
        ],
      ),
    );
  }

  // --- ŞIK KART TASARIMI ---
  Widget _buildAestheticCard(int index, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      transform: isSelected ? (Matrix4.identity()..translate(0, -10)) : Matrix4.identity(),
      decoration: BoxDecoration(
        // KOYU NUDE & PEMBE GRADYAN ✨
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected 
            ? [const Color(0xFF4A3B3B), const Color(0xFF8D6E63)] // Seçilince daha derinleşir
            : [const Color(0xFFD48B93), const Color(0xFFB07D7D)], // Nude Pembe tonları
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFFFD700).withOpacity(0.6) : Colors.white24, 
          width: 1.2
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected ? const Color(0xFFD48B93).withOpacity(0.4) : Colors.black.withOpacity(0.08),
            blurRadius: isSelected ? 20 : 10,
            offset: isSelected ? const Offset(0, 10) : const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Kart Üstündeki Narin Sembol
          Icon(
            CupertinoIcons.moon_stars, 
            color: isSelected ? const Color(0xFFFFD700).withOpacity(0.8) : Colors.white38, 
            size: 26
          ),
          // Seçim Numarası
          if (isSelected) 
            Positioned(
              top: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
                child: Text("${selectedCards.indexOf(index) + 1}", 
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text("Kozmik Açılım", 
          style: GoogleFonts.bodoniModa(fontSize: 32, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400, color: const Color(0xFF4A3B3B))),
        const SizedBox(height: 8),
        Container(
          height: 1, width: 40, color: const Color(0xFFD48B93).withOpacity(0.5),
        ),
        const SizedBox(height: 8),
        Text("Zihnini serbest bırak ve 3 kart seç.", 
          style: GoogleFonts.inter(fontSize: 11, color: Colors.black38, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildSelectedCardsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 30)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          bool hasCard = selectedCards.length > i;
          return Container(
            width: 65,
            height: 95,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: hasCard 
                ? const LinearGradient(colors: [Color(0xFF4A3B3B), Color(0xFF8D6E63)])
                : null,
              color: hasCard ? null : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.04)),
            ),
            child: hasCard 
              ? const Icon(CupertinoIcons.sparkles, color: Color(0xFFFFD700), size: 18)
              : null,
          );
        }),
      ),
    );
  }

  Widget _buildRevealButton() {
    return Positioned(
      bottom: 35, left: 50, right: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: const Color(0xFFD48B93).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: const Text("KADERİNİ GÖR ✨", 
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 2, fontSize: 12)),
        ),
      ),
    );
  }
}

// --- STAR PAINTER (Aynı) ---
class StarFieldPainterWidget extends StatelessWidget {
  final AnimationController controller;
  final Color starColor;
  const StarFieldPainterWidget({super.key, required this.controller, required this.starColor});
  @override Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: (context, child) => CustomPaint(painter: _StarPainter(controller.value, starColor)));
  }
}
class _StarPainter extends CustomPainter {
  final double val; final Color color; _StarPainter(this.val, this.color);
  @override void paint(Canvas canvas, Size size) {
    final rand = math.Random(42);
    for (int i = 0; i < 50; i++) {
      double x = rand.nextDouble() * size.width; double y = rand.nextDouble() * size.height;
      double blink = (math.sin(val * 4 * math.pi + i) + 1) / 2;
      canvas.drawCircle(Offset(x, y), 0.8 + rand.nextDouble() * 1.2, Paint()..color = color.withOpacity(blink * color.opacity));
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true; 
}