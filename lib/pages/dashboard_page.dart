import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

// SAYFA BAĞLANTILARI ✨
import 'birth_chart_page.dart'; 
import 'tarot_page.dart'; 
import 'destiny_matrix_page.dart'; 
import 'coffee_fortune_page.dart'; 
import 'flow_page.dart'; 
import 'oracle_chat_page.dart'; 
import 'profile_page.dart'; // Profil sayfası eklendi ✨

class DashboardPage extends StatefulWidget {
  final Color bgColor;
  const DashboardPage({super.key, required this.bgColor});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  final PageController _pageController = PageController();
  int _currentPage = 0; // Üstteki 3'lü kart için

  // --- ALT MENÜ INDEX SİSTEMİ ✨ ---
  int _selectedBottomIndex = 0; // 0: Home, 1: Akış, 2: Danış, 3: Profil

  final Color cosmicCardColor = const Color(0xFF0F0C29);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. KATMAN: EVRENSEL YILDIZLAR (Tüm sayfalarda arkada ✨)
          Positioned.fill(
            child: RepaintBoundary(
              child: StarFieldPainterWidget(
                controller: _controller, 
                starColor: const Color(0xFFFF5252).withOpacity(0.25),
              ),
            ),
          ),

          // 2. KATMAN: AKTİF SAYFA İÇERİĞİ (Seçime göre değişir ✨)
          _buildActivePageContent(),

          // 3. KATMAN: ALT NAVİGASYON (Her zaman en üstte ✨)
          _buildBottomNav(),
        ],
      ),
    );
  }

  // --- SAYFA SEÇİCİ MANTIK (PROFIL EKLENDI ✨) ---
  Widget _buildActivePageContent() {
    switch (_selectedBottomIndex) {
      case 0:
        return _buildHomeContent(); 
      case 1:
        return const FlowPage(); 
      case 2:
        return const OracleChatPage(); 
      case 3:
        return const ProfilePage(); // İŞTE BURADA ✨
      default:
        return _buildHomeContent();
    }
  }

  // --- ANA SAYFA (HOME) İÇERİĞİ ---
  Widget _buildHomeContent() {
    return Stack(
      children: [
        Positioned(
          top: -150, left: 0, right: 0,
          child: RepaintBoundary(
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 1.1,
                  colors: [
                    const Color(0xFFFF5252).withOpacity(0.22), 
                    const Color(0xFFFFEAEA).withOpacity(0.08), 
                    Colors.white.withOpacity(0)
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildTopHeader(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 280,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) => setState(() => _currentPage = index),
                        children: [
                          _buildPlanetCard(),    
                          _buildEnergyCard(),    
                          _buildCosmicTipCard(), 
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPageIndicator(),
                  ],
                ),
              ),
              _buildKesfetTitle(),
              _buildServiceGrid(), 
              const SliverToBoxAdapter(child: SizedBox(height: 150)),
            ],
          ),
        ),
      ],
    );
  }

  // --- ALT NAVİGASYON ---
  Widget _buildBottomNav() {
    return Positioned(
      bottom: 30, left: 30, right: 30,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 40, offset: const Offset(0, 15))],
          border: Border.all(color: Colors.black.withOpacity(0.02)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(CupertinoIcons.house_fill, "Ana Sayfa", 0),
            _navItem(CupertinoIcons.calendar_today, "Akış", 1),
            _navItem(CupertinoIcons.chat_bubble_2_fill, "Danış", 2, isPremium: true),
            _navItem(CupertinoIcons.person_fill, "Profil", 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, {bool isPremium = false}) {
    bool isActive = _selectedBottomIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedBottomIndex = index),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPremium ? const Color(0xFFE91E63) : (isActive ? Colors.black : Colors.black26), size: isPremium ? 26 : 22),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: isActive ? FontWeight.w700 : FontWeight.w400, color: isActive ? Colors.black : Colors.black26)),
          ],
        ),
      ),
    );
  }

  // --- HOME KARTLARI VE SERVISLER (EKSILTILMEDI ✨) ---
  Widget _buildPlanetCard() => _cardWrapper(color: cosmicCardColor, child: Stack(children: [Positioned.fill(child: RepaintBoundary(child: StarFieldPainterWidget(controller: _controller, starColor: Colors.white24))), Positioned(right: -70, bottom: -60, child: RepaintBoundary(child: CustomPaint(size: const Size(320, 320), painter: StaticPlanetPainter()))), Padding(padding: const EdgeInsets.all(32.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("KADERİNİN KODU", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w900)), const SizedBox(height: 24), Text("Jüpiter Evinde.\nBolluk Seninle.", style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w200, height: 1.3)), const Spacer(), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const BirthChartPage())), child: _cardButton("HARİTANI KEŞFET ✨"))]))]));
  Widget _buildEnergyCard() => _cardWrapper(color: cosmicCardColor, child: Stack(children: [Positioned.fill(child: RepaintBoundary(child: StarFieldPainterWidget(controller: _controller, starColor: Colors.white24))), Padding(padding: const EdgeInsets.all(32.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("GÜNLÜK ENERJİN", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w900)), const SizedBox(height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_energyOrb("Aşk", 0.85, Colors.pinkAccent), _energyOrb("Para", 0.40, Colors.amber), _energyOrb("Şans", 0.95, Colors.purpleAccent), _energyOrb("Mod", 0.70, Colors.cyanAccent)]), const Spacer(), Text("Bugün sezgilerin her zamankinden daha keskin.", style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w300, height: 1.5))]))]));
  Widget _buildCosmicTipCard() => _cardWrapper(color: cosmicCardColor, child: Stack(children: [Positioned.fill(child: RepaintBoundary(child: StarFieldPainterWidget(controller: _controller, starColor: Colors.white24))), Padding(padding: const EdgeInsets.all(32.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("GÜNÜN REHBERİ", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w900)), const SizedBox(height: 35), const Icon(CupertinoIcons.quote_bubble_fill, color: Color(0xFFE91E63), size: 35), const SizedBox(height: 20), Text("\"Evren, senin sessiz adımlarının bile sesini duyar.\"", style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w200, fontStyle: FontStyle.italic, height: 1.6))]))]));
  Widget _buildServiceGrid() => SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 24), sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.9), delegate: SliverChildListDelegate([GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TarotPage())), child: _buildServiceCard("Tarot", "Günün Kartı", CupertinoIcons.moon_stars, const Color(0xFFFDF2F2))), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinyMatrixPage())), child: _buildServiceCard("Matris", "Kader Yolu", CupertinoIcons.circle_grid_hex, const Color(0xFFF2F5FD))), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CoffeeFortunePage())), child: _buildServiceCard("Kahve", "Fincan Sırrı", Icons.coffee_outlined, const Color(0xFFFDFDF2))), _buildServiceCard("Uyum", "Aşk Analizi", CupertinoIcons.heart, const Color(0xFFF2FDF5))])));
  
  // UI YARDIMCILARI
  Widget _buildTopHeader() => SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(24.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("İyi akşamlar,", style: GoogleFonts.inter(fontSize: 13, color: Colors.black38)), Text("Kozmik Akış", style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w200))]), const CircleAvatar(backgroundColor: Color(0xFFF5F5F5), child: Icon(Icons.person_outline, color: Colors.black, size: 20))])));
  Widget _buildKesfetTitle() => const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(left: 24, top: 40, bottom: 20), child: Text("KOZMİK ARAÇLAR", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2.5, color: Colors.black26))));
  Widget _buildServiceCard(String t, String s, IconData i, Color c) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(28)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(i, color: Colors.black54, size: 22), const Spacer(), Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)), Text(s, style: const TextStyle(fontSize: 11, color: Colors.black38))]));
  Widget _cardWrapper({required Widget child, required Color color}) => Container(margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: const Color(0xFFFF5252).withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 15))]), child: ClipRRect(borderRadius: BorderRadius.circular(32), child: child));
  Widget _energyOrb(String l, double p, Color c) => Column(children: [Stack(alignment: Alignment.center, children: [SizedBox(width: 52, height: 52, child: CircularProgressIndicator(value: p, strokeWidth: 3.5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation<Color>(c))), Text("%${(p * 100).toInt()}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Text(l, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600))]);
  Widget _cardButton(String t) => Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)), child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)));
  Widget _buildPageIndicator() => Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (index) => AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4), width: _currentPage == index ? 22 : 7, height: 7, decoration: BoxDecoration(color: _currentPage == index ? const Color(0xFFE91E63) : Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(4)))));
}

// --- PAINTERS (SABİT) ---
class StaticPlanetPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 75, Paint()..color = const Color(0xFFFF5252).withOpacity(0.15)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35));
    canvas.drawCircle(center, 70, Paint()..shader = const RadialGradient(colors: [Color(0xFFFFB4B4), Color(0xFFE91E63)]).createShader(Rect.fromCircle(center: center, radius: 70)));
    final ring = Paint()..color = Colors.white.withOpacity(0.12)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    canvas.drawOval(Rect.fromCenter(center: center, width: 230, height: 60), ring);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}

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
    final paint = Paint();
    for (int i = 0; i < 40; i++) {
      double x = rand.nextDouble() * size.width;
      double y = rand.nextDouble() * size.height;
      double blink = (math.sin(val * 4 * math.pi + i) + 1) / 2;
      canvas.drawCircle(Offset(x, y), 0.8 + rand.nextDouble(), paint..color = color.withOpacity(blink * color.opacity));
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true; 
}