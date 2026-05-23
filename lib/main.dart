import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const AstroseApp());
}

class AstroseApp extends StatelessWidget {
  const AstroseApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Astrose',
      theme: ThemeData(useMaterial3: true, fontFamily: 'sans-serif'),
      home: const MainScrollWrapper(),
    );
  }
}

// ---------------------------------------------------------
// ANA SARMALAYICI: TÜM SAYFALARIN AKIŞI
// ---------------------------------------------------------
class MainScrollWrapper extends StatefulWidget {
  const MainScrollWrapper({super.key});
  @override
  State<MainScrollWrapper> createState() => _MainScrollWrapperState();
}

class _MainScrollWrapperState extends State<MainScrollWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _starController;
  List<Star> stars = [];
  final PageController _mainController = PageController();

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        for (int i = 0; i < 40; i++) {
          stars.add(Star(
            x: Random().nextDouble() * size.width,
            y: Random().nextDouble() * size.height,
            size: Random().nextDouble() * 4.0 + 2.0, 
            speed: Random().nextDouble() * 0.2 + 0.1,
            opacity: Random().nextDouble(),
          ));
        }
      });
    });
  }

  @override
  void dispose() { _starController.dispose(); _mainController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F2),
      body: Stack(
        children: [
          // Arka Plan Yıldızları
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              for (var star in stars) { star.update(MediaQuery.of(context).size.height); }
              return CustomPaint(painter: StarPainter(stars, const Color(0xFF8B7765).withOpacity(0.3)), size: Size.infinite);
            },
          ),
          // Sayfalar
          PageView(
            controller: _mainController,
            physics: const NeverScrollableScrollPhysics(), // Butonlarla kontrol edeceğiz
            children: [
              IntroPage(onNext: () => _mainController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic)),
              LoginPage(onNext: () => _mainController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic)),
              RegistrationPage(onNext: () => _mainController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic)),
              BirthDetailsPage(onNext: () => _mainController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic)),
              const ServicesPage(),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// YENİ SAYFA: YANA KAYDIRMALI DOĞUM BİLGİLERİ
// ---------------------------------------------------------
class BirthDetailsPage extends StatefulWidget {
  final VoidCallback onNext;
  const BirthDetailsPage({super.key, required this.onNext});

  @override
  State<BirthDetailsPage> createState() => _BirthDetailsPageState();
}

class _BirthDetailsPageState extends State<BirthDetailsPage> {
  final PageController _formController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> steps = [
    {"q": "Doğum Tarihin nedir?", "h": "GG / AA / YYYY"},
    {"q": "Doğum Saatin kaç?", "h": "00 : 00"},
    {"q": "Hangi Şehirde doğdun?", "h": "Şehir ismi giriniz"},
    {"q": "Medeni Haliniz nedir?", "h": "Bekar / Evli / İlişkisi var"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // ÜSTTEKİ GÖRSEL: astrology.png
          Center(
            child: Image.asset(
              'assets/images/astrology.png', 
              height: 220, 
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(Icons.auto_awesome, size: 80, color: Color(0xFF8B7765)),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // YANA KAYAN SORULAR
          Expanded(
            child: PageView.builder(
              controller: _formController,
              onPageChanged: (v) => setState(() => _currentIndex = v),
              itemCount: steps.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        steps[i]['q']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Color(0xFF8B7765)),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        decoration: InputDecoration(
                          hintText: steps[i]['h'],
                          filled: true, fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ALT GEZİNTİ VE DEVAM ET
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                // Sayfa Noktaları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(steps.length, (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: _currentIndex == index ? const Color(0xFF8B7765) : Colors.black12, shape: BoxShape.circle),
                  )),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    if (_currentIndex < steps.length - 1) {
                      _formController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    } else {
                      widget.onNext();
                    }
                  },
                  child: Container(
                    height: 60, width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFF8B7765), borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text("DEVAM ET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// DİĞER SAYFALAR (INTRO, LOGIN, REG, SERVICES)
// ---------------------------------------------------------

class IntroPage extends StatelessWidget {
  final VoidCallback onNext;
  const IntroPage({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(painter: OrganicCurvePainter(const Color(0xFFF5E9DA)), size: Size.infinite),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("ASTR", style: TextStyle(fontSize: 40, letterSpacing: 10, fontWeight: FontWeight.w300, color: Color(0xFF8B7765), fontFamily: 'Serif', fontStyle: FontStyle.italic)),
                  Icon(Icons.nightlight_round, color: Color(0xFF8B7765), size: 30),
                  Text("SE", style: TextStyle(fontSize: 40, letterSpacing: 10, fontWeight: FontWeight.w300, color: Color(0xFF8B7765), fontFamily: 'Serif', fontStyle: FontStyle.italic)),
                ],
              ),
              const Spacer(),
              Center(child: Image.asset('assets/images/gunes.png', height: 280, fit: BoxFit.contain, color: const Color(0xFF8B7765).withOpacity(0.8), colorBlendMode: BlendMode.srcIn)),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text("Yıldızların rehberliğinde kendi yolunuzu keşfedin.", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, color: Color(0xFF8B7765), height: 1.4)),
              ),
              const SizedBox(height: 60),
              GestureDetector(onTap: onNext, child: Container(padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 20), decoration: BoxDecoration(color: const Color(0xFF8B7765), borderRadius: BorderRadius.circular(40)), child: const Text("BAŞLA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 3, fontStyle: FontStyle.italic)))),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onNext;
  const LoginPage({super.key, required this.onNext});
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  int? sel;
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: Column(children: [const SizedBox(height: 60), const Text("Giriş Yap", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)), const SizedBox(height: 50), _btn(0, "Email", Icons.email), _btn(1, "Google", Icons.g_mobiledata), _btn(2, "Apple", Icons.apple), _btn(3, "Facebook", Icons.facebook), const Spacer(), TextButton(onPressed: widget.onNext, child: const Text("Hesabın yok mu? Kayıt Ol", style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))), const SizedBox(height: 30)]))));
  }
  Widget _btn(int i, String t, IconData ic) => Padding(padding: const EdgeInsets.only(bottom: 15), child: GestureDetector(onTap: () => setState(() => sel = i), child: AnimatedContainer(duration: const Duration(milliseconds: 300), height: 60, decoration: BoxDecoration(color: sel == i ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)), child: Row(children: [const SizedBox(width: 20), Icon(ic, color: sel == i ? Colors.white : Colors.black), const SizedBox(width: 20), Text(t, style: TextStyle(color: sel == i ? Colors.white : Colors.black, fontStyle: FontStyle.italic))]))));
}

class RegistrationPage extends StatelessWidget {
  final VoidCallback onNext;
  const RegistrationPage({super.key, required this.onNext});
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: Column(children: [const SizedBox(height: 60), const Text("Kayıt Ol", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)), const SizedBox(height: 50), _item("Email", Icons.email), _item("Google", Icons.g_mobiledata), _item("Apple", Icons.apple), _item("Facebook", Icons.facebook), const Spacer(), GestureDetector(onTap: onNext, child: Container(height: 60, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFF8B7765), borderRadius: BorderRadius.circular(15)), child: const Center(child: Text("DEVAM ET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))))), const SizedBox(height: 30)]))));
  }
  Widget _item(String t, IconData ic) => Padding(padding: const EdgeInsets.only(bottom: 15), child: Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)), child: Row(children: [const SizedBox(width: 20), Icon(ic), const SizedBox(width: 20), Text(t, style: const TextStyle(fontStyle: FontStyle.italic))])));
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});
  @override Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {"t": "Günlük Burç", "i": Icons.auto_awesome, "c": Color(0xFFD2691E)},
      {"t": "Doğum Haritası", "i": Icons.explore, "c": Color(0xFFCD853F)},
      {"t": "Kader Matrisi", "i": Icons.grid_4x4, "c": Color(0xFFB48A4D)},
      {"t": "Tarot Falı", "i": Icons.style, "c": Color(0xFFE2725B)},
      {"t": "Kahve Falı", "i": Icons.coffee, "c": Color(0xFFBC8F8F)},
      {"t": "Aşk Uyumu", "i": Icons.favorite, "c": Color(0xFF8B4513)},
    ];
    return Scaffold(backgroundColor: const Color(0xFFFDF8F2), body: SafeArea(child: Padding(padding: const EdgeInsets.all(25), child: Column(children: [const SizedBox(height: 20), const Text("ASTROSE SERVİSLER", style: TextStyle(fontSize: 20, letterSpacing: 4, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Color(0xFF8B7765))), const SizedBox(height: 40), Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20), itemCount: 6, itemBuilder: (context, index) => Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(25), border: Border.all(color: items[index]['c'].withOpacity(0.5), width: 1.5)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(items[index]['i'], size: 35, color: items[index]['c']), const SizedBox(height: 12), Text(items[index]['t'], textAlign: TextAlign.center, style: TextStyle(color: items[index]['c'], fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 13))]))))]))));
  }
}

// --- Tasarım Yardımcıları ---
class Star {
  double x, y, size, speed, opacity; double angle = Random().nextDouble() * pi;
  Star({required this.x, required this.y, required this.size, required this.speed, required this.opacity});
  void update(double h) { y += speed; angle += 0.05; opacity = (sin(angle) + 1) / 2; if (y > h) y = -10; }
}
class StarPainter extends CustomPainter {
  final List<Star> stars; final Color starColor; StarPainter(this.stars, this.starColor);
  @override void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final paint = Paint()..color = starColor.withOpacity(star.opacity * 0.6);
      canvas.drawLine(Offset(star.x, star.y - star.size), Offset(star.x, star.y + star.size), paint..strokeWidth = 1.0);
      canvas.drawLine(Offset(star.x - star.size, star.y), Offset(star.x + star.size, star.y), paint);
      canvas.drawCircle(Offset(star.x, star.y), star.size * 0.3, paint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}
class OrganicCurvePainter extends CustomPainter {
  final Color color; OrganicCurvePainter(this.color);
  @override void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color; var path = Path();
    path.lineTo(0, size.height * 0.55); path.cubicTo(size.width * 0.35, size.height * 0.62, size.width * 0.65, size.height * 0.42, size.width, size.height * 0.48);
    path.lineTo(size.width, 0); path.close(); canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}