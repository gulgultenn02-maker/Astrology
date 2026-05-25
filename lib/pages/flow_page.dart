import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowPage extends StatefulWidget {
  const FlowPage({super.key});

  @override
  State<FlowPage> createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 15)
    )..repeat();
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
          // Arka Plan Efektleri
          _buildBackgroundEffects(),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. BAŞLIK
                _buildHeader(),

                // 2. GÜNÜN KOZMİK MANŞETİ
                SliverToBoxAdapter(child: _buildMainInsight()),

                // 3. AY DURUMU
                SliverToBoxAdapter(child: _buildMoonStatus()),

                // 4. DETAYLI YAŞAM ANALİZLERİ ✨
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildLongReadingSection(
                        "Aşk & İlişkiler", 
                        "❤️", 
                        "Bugün Venüs'ün narin dokunuşları, kalbindeki fırtınaları dindirmeye geliyor. Eğer bir süredir partnerinle aranda sessiz bir duvar örüldüyse, o duvarı yıkmak için doğru kelimeler bugün dudaklarından dökülecek. Gökyüzü sana 'savunmanı indir' diyor. Bekar olan dostlarımız için ise akşam saatlerinde beklenmedik bir bildirim veya mesaj, haftanın geri kalanını gülümseyerek geçirmene sebep olabilir. Aşkın dili bugün dürüstlüktür.",
                      ),
                      _buildLongReadingSection(
                        "Kariyer & Bereket", 
                        "💼", 
                        "Merkür'ün Satürn ile kurduğu ciddi hiza, iş yerinde otorite figürleriyle olan iletişimine dikkat çekiyor. Bugün büyük riskler almak yerine, elindeki yarım kalmış işleri tamamlamak ve bir düzen kurmak seni daha ileriye taşıyacaktır. Finansal olarak ani bir dürtüyle pahalı bir şey almak isteyebilirsin; ancak yıldızlar bu parayı gelecekteki daha büyük bir yatırım için saklamanı fısıldıyor. Şansın bugün sabrında saklı.",
                      ),
                      _buildLongReadingSection(
                        "Ruh & Enerji", 
                        "🧘", 
                        "Üzerinde biriken o yorgunluk hissi aslında ruhunun bir mola verme çağrısı. Bugün zihnindeki karmaşayı susturmak için doğayla veya suyla temas etmen çok kritik. Ay'ın büyüme evresi, senin de içsel olarak büyümeni destekliyor. Rüyalarına dikkat et; sabaha karşı gördüğün o garip detaylar aslında bilinçaltının sana verdiği çok önemli bir ipucunu barındırıyor olabilir. Kendi ışığına güven, o seni asla yarı yolda bırakmaz.",
                      ),
                    ],
                  ),
                ),

                // 5. DO's & DON'Ts (Yap/Yapma) ✨
                SliverToBoxAdapter(child: _buildDosAndDonts()),

                // 6. ŞANSLI SEMBOLLER
                SliverToBoxAdapter(child: _buildLuckyFooter()),

                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI METOTLARI (YARDIMCILAR) ---

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kozmik Akış", 
              style: GoogleFonts.bodoniModa(fontSize: 36, fontStyle: FontStyle.italic, color: const Color(0xFF1A1A1A))),
            const SizedBox(height: 5),
            Text("BUGÜNÜN KOZMİK REHBERİ", 
              style: GoogleFonts.inter(fontSize: 9, color: Colors.black26, fontWeight: FontWeight.w800, letterSpacing: 2.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInsight() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFFFFB6C1).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.sparkles, color: Color(0xFFD48B93), size: 16),
              const SizedBox(width: 8),
              Text("GÜNÜN MESAJI", style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFFD48B93), letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Göklerin ritmi bugün kalbinle aynı hızda atıyor. Sadece dinle, evren sana en büyük sırrını fısıldamaya hazır.",
            style: GoogleFonts.inter(fontSize: 18, color: Colors.black, height: 1.4, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  Widget _buildMoonStatus() {
    return Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(color: const Color(0xFF0F0C29), borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          const Icon(CupertinoIcons.moon_fill, color: Color(0xFFFFB6C1), size: 28),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Büyüyen Ay", style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300)),
              Text("Enerjin Artıyor", style: GoogleFonts.inter(color: Colors.white24, fontSize: 10)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 14),
        ],
      ),
    );
  }

  Widget _buildLongReadingSection(String title, String icon, String content) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 15),
          Text(content, 
            style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.7, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }

  Widget _buildDosAndDonts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          _doDontCard("YAKINLAŞ", "Dürüstlük, sanatsal üretim, su teması.", Colors.green.shade50),
          const SizedBox(width: 15),
          _doDontCard("UZAK DUR", "Ani öfke, gereksiz harcama, şüphe.", Colors.red.shade50),
        ],
      ),
    );
  }

  Widget _doDontCard(String title, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.black26)),
            const SizedBox(height: 8),
            Text(text, style: GoogleFonts.inter(fontSize: 11, color: Colors.black87, height: 1.4, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget _buildLuckyFooter() {
    return Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFB6C1).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _luckyCol("11", "Uğurlu Sayı"),
          _luckyCol("Pembe", "Uğurlu Renk"),
          _luckyCol("Kuvars", "Taş"),
        ],
      ),
    );
  }

  Widget _luckyCol(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF4A3B3B))),
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: Colors.black26, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        Positioned(
          top: -50, right: -50,
          child: Container(
            width: 350, height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              gradient: RadialGradient(colors: [const Color(0xFFFFB6C1).withOpacity(0.2), Colors.white.withOpacity(0)])
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) => CustomPaint(
              painter: _StarPainter(_shimmerController.value)
            ),
          ),
        ),
      ],
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
    for (int i = 0; i < 35; i++) {
      double x = rand.nextDouble() * size.width;
      double y = rand.nextDouble() * size.height;
      double blink = (math.sin(val * 4 * math.pi + i) + 1) / 2;
      canvas.drawCircle(Offset(x, y), 0.8 + rand.nextDouble(), 
        Paint()..color = const Color(0xFFFF5252).withOpacity(blink * 0.15));
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true;
}