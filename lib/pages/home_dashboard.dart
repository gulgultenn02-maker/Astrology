import 'package:flutter/material.dart';

// MainStageManager'ın arayıp bulamadığı sınıf tam olarak bu kanka!
class DashboardFinalScreen extends StatelessWidget {
  const DashboardFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent, // Arka plandaki morluk parlasın diye şeffaf yaptık
      body: Center(
        child: Text(
          "MİSTİK ANA SAYFA / DASHBOARD",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            fontFamily: 'serif'
          ),
        ),
      ),
    );
  }
}