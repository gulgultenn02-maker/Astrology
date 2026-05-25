import 'dart:math';
import 'package:flutter/material.dart';
import '../models/star.dart';
import '../widgets/background_painters.dart';
import 'intro_page.dart';
import 'social_login_screen.dart';
import 'birth_details_swipe_screen.dart';
import 'dashboard_page.dart';

class MainStageManager extends StatefulWidget {
  const MainStageManager({super.key});
  @override
  State<MainStageManager> createState() => _MainStageManagerState();
}

class _MainStageManagerState extends State<MainStageManager> with TickerProviderStateMixin {
  final PageController _ctrl = PageController();
  late AnimationController _starCtrl;
  List<Star> stars = [];

  final Color cTop = const Color(0xFF1A1B4B); 
  final Color cMid = const Color(0xFFE29587); 
  final Color cBottom = const Color(0xFFFBDAD4); 

  @override
  void initState() {
    super.initState();
    _starCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        for (int i = 0; i < 55; i++) {
          stars.add(Star(x: Random().nextDouble() * size.width, y: Random().nextDouble() * size.height, size: 2, speed: 0.15, opacity: Random().nextDouble()));
        }
      });
    });
  }

  @override void dispose() { _starCtrl.dispose(); _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(painter: ThreeZoneBackgroundPainter(cTop, cMid, cBottom), size: Size.infinite),
          AnimatedBuilder(animation: _starCtrl, builder: (c, sh) {
            for (var s in stars) {
              s.update(MediaQuery.of(context).size.height);
            }
            return CustomPaint(painter: StarPainter(stars, Colors.white), size: Size.infinite);
          }),
          PageView(
            controller: _ctrl,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              IntroPage(
  onNext: () => _ctrl.nextPage(duration: const Duration(seconds: 1),  curve: Curves.easeInOutQuart),),
              SocialLoginScreen(bgColor: cMid, onNext: () => _ctrl.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOutQuart)),
              BirthDetailsSwipeScreen(onNext: () => _ctrl.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOutQuart)),
              DashboardPage(bgColor: cTop),
            ],
          ),
        ],
      ),
    );
  }
}