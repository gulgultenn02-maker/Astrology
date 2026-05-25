import 'dart:ui';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  final VoidCallback onNext;
  const RegistrationPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    const Color goldAccent = Color(0xFFE5A93C);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "HESAP OLUŞTUR", 
                style: TextStyle(fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.w300, color: Colors.white, fontFamily: 'serif')
              ),
              const SizedBox(height: 12),
              Text(
                "Astrolojik yolculuğunuza başlamak için bilgilerinizi girin.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontStyle: FontStyle.italic, fontSize: 13),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(child: _input("Ad", Icons.person_outline)),
                  const SizedBox(width: 16),
                  Expanded(child: _input("Soyad", Icons.person_outline)),
                ],
              ),
              const SizedBox(height: 16),
              _rowField("Telefon", "E-posta", Icons.phone_android_outlined, Icons.email_outlined),
              const SizedBox(height: 16),
              _rowField("Şifre", "Şifre Tekrar", Icons.lock_outline, Icons.lock_clock_outlined, isPass: true),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: onNext,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: goldAccent,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: goldAccent.withValues(alpha: 0.25), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "DEVAM ET", 
                      style: TextStyle(color: Color(0xFF200D30), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 13)
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowField(String h1, String h2, IconData i1, IconData i2, {bool isPass = false}) => Row(
        children: [
          Expanded(child: _input(h1, i1, isPass: isPass)),
          const SizedBox(width: 16),
          Expanded(child: _input(h2, i2, isPass: isPass)),
        ],
      );

  Widget _input(String h, IconData icon, {bool isPass = false}) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2),
            ),
            child: TextField(
              obscureText: isPass,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: h,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13, fontStyle: FontStyle.italic),
                prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              ),
            ),
          ),
        ),
      );
}