import 'package:flutter/material.dart';
import 'pages/main_stage_manager.dart'; // YOLUN DOĞRU OLDUĞUNDAN EMİN OL

void main() => runApp(const AstroseApp());

class AstroseApp extends StatelessWidget {
  const AstroseApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainStageManager(), // Stage Manager'ı çağırır
    );
  }
  
}