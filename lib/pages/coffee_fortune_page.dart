import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeFortunePage extends StatefulWidget {
  const CoffeeFortunePage({super.key});

  @override
  State<CoffeeFortunePage> createState() => _CoffeeFortunePageState();
}

class _CoffeeFortunePageState extends State<CoffeeFortunePage> with SingleTickerProviderStateMixin {
  String selectedCategory = "Genel";
  final List<String> categories = ["Genel", "Aşk", "Sağlık", "Para", "İş"];
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Fincan Seremonisi", 
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w300, letterSpacing: 3)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. KATMAN: PEMBE AURA (TEMAYLA %100 UYUMLU ✨)
          Positioned(
            top: -size.height * 0.1,
            left: 0, right: 0,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [
                    const Color(0xFFFFB6C1).withOpacity(0.25),
                    const Color(0xFFFFEAEA).withOpacity(0.08),
                    Colors.white.withOpacity(0)
                  ],
                ),
              ),
            ),
          ),

          // 2. KATMAN: PARLAYAN KOZMİK YILDIZLAR
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) => CustomPaint(
                painter: _StarPainter(_shimmerController.value)
              ),
            ),
          ),

          // 3. KATMAN: ANA İÇERİK
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                _buildEditorialHeader(),
                const SizedBox(height: 45),

                // FOTOĞRAF SLOTLARI (SADECE NUMARALI VE NARİN ✨)
                _buildMinimalPhotoSection(),

                const SizedBox(height: 50),

                // NİYET SEÇİMİ
                Text("ODAKLANMAK İSTEDİĞİNİZ ALAN", 
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 2, color: Colors.black26)),
                const SizedBox(height: 20),
                _buildCategorySelection(),

                const SizedBox(height: 60),

                // GÖNDER BUTONU (PREMIUM SİYAH)
                _buildPremiumButton(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Geleceğin\nİzleri", 
          style: GoogleFonts.bodoniModa(
            fontSize: 42, 
            height: 1, 
            fontStyle: FontStyle.italic, 
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1A1A1A)
          )),
        const SizedBox(height: 15),
        Container(height: 1, width: 60, color: const Color(0xFFFFB6C1)),
        const SizedBox(height: 15),
        Text("Fincanınızdaki sembolleri evrenin kadim bilgeliğiyle yorumlayalım.", 
          style: GoogleFonts.inter(fontSize: 13, color: Colors.black45, height: 1.6, fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildMinimalPhotoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _minimalPhotoCard("01"),
        _minimalPhotoCard("02"),
        _minimalPhotoCard("03"),
      ],
    );
  }

  Widget _minimalPhotoCard(String index) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 125,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: const Center(
            child: Icon(CupertinoIcons.camera, color: Color(0xFFD48B93), size: 22),
          ),
        ),
        const SizedBox(height: 12),
        Text(index, style: GoogleFonts.inter(fontSize: 10, color: Colors.black26, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        bool isSelected = selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: isSelected ? Colors.transparent : Colors.black.withOpacity(0.04)),
              boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)] : [],
            ),
            child: Text(cat, 
              style: GoogleFonts.inter(
                fontSize: 12, 
                color: isSelected ? Colors.white : Colors.black54, 
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400
              )),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumButton() {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 12))
        ],
      ),
      child: Center(
        child: Text("SEREMONİYİ BAŞLAT", 
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 3, fontSize: 11)),
      ),
    );
  }
}

// --- ARKA PLAN YILDIZLARI ---
class _StarPainter extends CustomPainter {
  final double val;
  _StarPainter(this.val);
  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(42);
    for (int i = 0; i < 45; i++) {
      double x = rand.nextDouble() * size.width;
      double y = rand.nextDouble() * size.height;
      double blink = (math.sin(val * 4 * math.pi + i) + 1) / 2;
      canvas.drawCircle(Offset(x, y), 0.7 + rand.nextDouble() * 1.2, 
        Paint()..color = const Color(0xFFFF5252).withOpacity(blink * 0.2));
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true;
}