import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F8),
      body: Stack(
        children: [
          // 1. KATMAN: PEMBE AURA VE YILDIZLAR ✨
          _buildBackgroundEffects(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTopNav(),
                  const SizedBox(height: 30),

                  // PROFİL FOTOĞRAFI VE İSİM ✨
                  _buildUserHeader(),

                  const SizedBox(height: 40),

                  // KOZMİK KİMLİK (Güneş, Ay, Yükselen) ✨
                  _buildZodiacRow(),

                  const SizedBox(height: 40),

                  // KREDİ KARTI (Premium Görünüm) ✨
                  _buildCreditCard(),

                  const SizedBox(height: 30),

                  // MENÜ LİSTESİ
                  _buildProfileMenu(),
                  
                  const SizedBox(height: 140), // Nav bar boşluğu
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Hesabım", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2, color: Colors.black26)),
          const Icon(CupertinoIcons.settings, size: 20, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Column(
      children: [
        // Zarif Avatar
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFB6C1).withOpacity(0.5), width: 1),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF1A1A1A),
            child: Icon(CupertinoIcons.person_fill, color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: 20),
        Text("Selin Yılmaz", 
          style: GoogleFonts.bodoniModa(fontSize: 32, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400)),
        Text("12 Mart 1995 • Balık Burcu", 
          style: GoogleFonts.inter(fontSize: 12, color: Colors.black38, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildZodiacRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _zodiacBadge("☉", "Güneş", "Balık"),
          _zodiacBadge("☽", "Ay", "Aslan"),
          _zodiacBadge("ASC", "Yükselen", "Terazi"),
        ],
      ),
    );
  }

  Widget _zodiacBadge(String symbol, String title, String sign) {
    return Column(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.04)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Center(child: Text(symbol, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.inter(fontSize: 9, color: Colors.black26, fontWeight: FontWeight.w800)),
        Text(sign, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildCreditCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: const Color(0xFFFFB6C1).withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.ticket_fill, color: Color(0xFFFFB6C1), size: 30),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kozmik Kredilerin", style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300)),
              Text("1 Adet Soru Hakkın Var", style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(15)),
            child: const Text("Yükle", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildProfileMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _menuItem(CupertinoIcons.archivebox, "Kayıtlı Fallarım"),
          _menuItem(CupertinoIcons.chart_pie, "Natal Harita Detayları"),
          _menuItem(CupertinoIcons.bell, "Gökyüzü Bildirimleri"),
          _menuItem(CupertinoIcons.lock_shield, "Gizlilik ve Güvenlik"),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: Text("Oturumu Kapat", style: GoogleFonts.inter(color: const Color(0xFFD48B93), fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black45),
          const SizedBox(width: 15),
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black12),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        Positioned(
          top: -50, left: -50,
          child: Container(
            width: 400, height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              gradient: RadialGradient(colors: [const Color(0xFFFFB6C1).withOpacity(0.15), Colors.white.withOpacity(0)])
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) => CustomPaint(painter: _InternalStarPainter(_shimmerController.value)),
          ),
        ),
      ],
    );
  }
}

class _InternalStarPainter extends CustomPainter {
  final double val; _InternalStarPainter(this.val);
  @override void paint(Canvas canvas, Size size) {
    final rand = math.Random(42);
    for (int i = 0; i < 35; i++) {
      double x = rand.nextDouble() * size.width; double y = rand.nextDouble() * size.height;
      double blink = (math.sin(val * 4 * math.pi + i) + 1) / 2;
      canvas.drawCircle(Offset(x, y), 0.7 + rand.nextDouble(), Paint()..color = const Color(0xFFFF5252).withOpacity(blink * 0.15));
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true;
}