import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginScreen extends StatefulWidget {
  final Color bgColor; 
  final VoidCallback onNext; 

  const SocialLoginScreen({
    super.key, 
    required this.bgColor, 
    required this.onNext
  });

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> with TickerProviderStateMixin {
  bool isLogin = true; 
  late AnimationController _cosmicController;

  @override
  void initState() {
    super.initState();
    // Arka plan animasyonu: 60 saniyede bir tur (Huzurlu ve akıcı)
    _cosmicController = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    _cosmicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auraColor = const Color(0xFFFFB6C1).withOpacity(0.6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. KATMAN: PEMBE AURA (OPTIMIZE EDİLDİ) ---
          Positioned(
            top: -size.height * 0.1,
            right: -size.width * 0.4,
            child: RepaintBoundary(
              child: Container(
                width: size.width * 1.5,
                height: size.width * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [auraColor, Colors.white.withOpacity(0)],
                  ),
                ),
              ),
            ),
          ),

          // --- 2. KATMAN: KUYRUKLU YILDIZLAR VE TAKIMYILDIZLAR (PERFORMANS İÇİN ✨) ---
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _cosmicController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: AstrologyCometPainter(
                      animationValue: _cosmicController.value,
                      color: const Color(0xFFFF5252).withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
          ),

          // --- 3. KATMAN: ANA İÇERİK ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // ÜST NAVİGASYON BUTONU
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => setState(() => isLogin = !isLogin),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
                        ),
                        child: Text(isLogin ? "KAYIT OL" : "GİRİŞ YAP", 
                          style: GoogleFonts.inter(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // SADE VE ESTETİK BAŞLIK ✨
                  Text(
                    isLogin ? "Giriş Yap" : "Hesap Oluştur",
                    style: GoogleFonts.bodoniModa(
                      fontSize: 44,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FORM ALANLARI
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        if (!isLogin) ...[
                          _buildInput(CupertinoIcons.person, "ad soyad"),
                          const SizedBox(height: 15),
                        ],
                        _buildInput(CupertinoIcons.mail, "e-posta adresi"),
                        const SizedBox(height: 15),
                        _buildInput(CupertinoIcons.lock, "şifre", isPassword: true),
                      ],
                    ),
                  ),
                  
                  if (isLogin) 
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Şifremi Unuttum?", style: GoogleFonts.inter(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w400)),
                      ),
                    ),

                  const SizedBox(height: 35),

                  // SOSYAL GİRİŞ BUTONLARI (GERÇEK İKONLAR ✨)
                  _buildSocialButton(Icons.g_mobiledata_rounded, "Google ile Giriş Yap", Colors.white, isGoogle: true),
                  const SizedBox(height: 12),
                  _buildSocialButton(Icons.apple, "Apple ile Giriş Yap", Colors.black, isApple: true),

                  const SizedBox(height: 50),

                  // ALT DEVAM BUTONU
                  _buildBottomRow(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI METOTLARI ---

  Widget _buildSocialButton(IconData icon, String label, Color color, {bool isGoogle = false, bool isApple = false}) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isGoogle ? 32 : 22, color: color == Colors.black ? Colors.white : Colors.black87),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: color == Colors.black ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInput(IconData icon, String hint, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        obscureText: isPassword,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          icon: Icon(icon, size: 18, color: Colors.black26),
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.black26),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Yıldızların rehberliğiyle ruhunu keşfetmeye hazır mısın?",
            style: GoogleFonts.inter(fontSize: 11, color: Colors.black38, height: 1.4),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: widget.onNext,
          child: Container(
            width: 70, height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A), 
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))]
            ),
            child: const Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }
}

// --- KUYRUKLU YILDIZLAR VE KOZMİK ÇİZİCİ (GERİ GELDİ ✨) ---
class AstrologyCometPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  AstrologyCometPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.55, size.height * 0.3);
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    // 1. Dönen Mistik Halkalar
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animationValue * 2 * math.pi);
    canvas.drawCircle(Offset.zero, size.width * 0.6, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width * 1.3, height: size.width * 0.45), paint);
    canvas.restore();

    // 2. Kuyruklu Yıldız Noktaları ve Bağlantılar
    final rand = math.Random(42); 
    final List<Offset> points = [];
    for (int i = 0; i < 15; i++) {
      points.add(Offset(
        size.width * 0.3 + rand.nextDouble() * size.width * 0.6,
        size.height * 0.1 + rand.nextDouble() * size.height * 0.5,
      ));
    }

    // Çizgiler (Kuyruklar)
    for (int i = 0; i < points.length - 1; i++) {
      double blink = (math.sin(animationValue * 12 * math.pi + i) + 1) / 2;
      canvas.drawLine(points[i], points[i + 1], Paint()..color = color.withOpacity(blink * 0.1)..strokeWidth = 0.4);
    }

    // Parlayan Yıldızlar
    for (int i = 0; i < points.length; i++) {
      double blink = (math.sin(animationValue * 18 * math.pi + i) + 1) / 2;
      canvas.drawCircle(points[i], 1.5, Paint()..color = color.withOpacity(blink * 0.7));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}