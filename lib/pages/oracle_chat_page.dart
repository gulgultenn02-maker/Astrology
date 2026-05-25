import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class OracleChatPage extends StatefulWidget {
  const OracleChatPage({super.key});

  @override
  State<OracleChatPage> createState() => _OracleChatPageState();
}

class _OracleChatPageState extends State<OracleChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _bgController;
  
  int credits = 1; // Ücretsiz soru hakkı
  bool isTyping = false;

  List<Map<String, String>> messages = [
    {"role": "oracle", "text": "Hoş geldin ruh kardeşim. Bugün yıldızların senin için fısıldadığı hangi sırrı çözmemi istersin?"}
  ];

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 40))..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_messageController.text.isEmpty) return;

    if (credits > 0) {
      String userMsg = _messageController.text;
      setState(() {
        messages.add({"role": "user", "text": userMsg});
        _messageController.clear();
        credits--;
        isTyping = true;
      });

      // Kozmik Cevap (Simülasyon)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isTyping = false;
          messages.add({
            "role": "oracle", 
            "text": "Evrenin enerjisi şu an $userMsg üzerine yoğunlaşıyor... Aldığım mesaj şu: Kalbindeki niyetin saflığı, yollarını aydınlatacak. Çok yakında beklediğin haberi alacaksın."
          });
        });
      });
    } else {
      _showPaymentSheet();
    }
  }

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 25),
            Text("Soru Hakkın Doldu ✨", style: GoogleFonts.bodoniModa(fontSize: 24, fontStyle: FontStyle.italic)),
            const SizedBox(height: 10),
            const Text("Daha derin analizler için kozmik kredi yükleyebilirsin.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black45, fontSize: 13)),
            const SizedBox(height: 30),
            _paymentOption("1 Soru Hakkı", "49.99 TL", CupertinoIcons.ticket),
            const SizedBox(height: 12),
            _paymentOption("5 Soru Hakkı", "149.99 TL", CupertinoIcons.tickets_fill),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F3), // Tozpembe zemin
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(),
        title: Column(
          children: [
            Text("Kozmik Danışman", style: GoogleFonts.bodoniModa(color: Colors.black87, fontSize: 18, fontStyle: FontStyle.italic)),
            Text(isTyping ? "Yazıyor..." : "Çevrimiçi", 
              style: TextStyle(color: isTyping ? const Color(0xFFD48B93) : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.ticket, color: Color(0xFFD48B93), size: 14),
                    const SizedBox(width: 4),
                    Text("$credits Hak", style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // ARKA PLAN: MİSTİK DÖNEN ÇARK
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) => CustomPaint(
                painter: _MysticChatPainter(_bgController.value),
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isUser = messages[index]["role"] == "user";
                    return _buildChatBubble(messages[index]["text"]!, isUser);
                  },
                ),
              ),
              _buildInputArea(),
              // ALT NAVİGASYONUN ÜSTÜNE BİNMEYİ ENGELLEYEN BOŞLUK ✨
              const SizedBox(height: 110), 
            ],
          ),
        ],
      ),
    );
  }

  // --- KULLANICI MESAJLARI BEYAZ OLDU ✨ ---
  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.white, // HEM USER HEM BOT BEYAZ (User saf beyaz, Bot bir tık şeffaf)
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isUser ? Colors.black.withOpacity(0.05) : Colors.black.withOpacity(0.02), 
              blurRadius: 10
            )
          ],
        ),
        child: Text(
          text, 
          style: GoogleFonts.inter(
            color: Colors.black87, 
            fontSize: 14, 
            fontWeight: isUser ? FontWeight.w400 : FontWeight.w300, 
            height: 1.5
          )
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // İSTEDİĞİN KUTUCUKLAR ✨
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _quickChip("Doğum Haritası"),
                _quickChip("Tarot"),
                _quickChip("Kahve Falı"),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Ne hakkında bakım yaptırmak istersin?", 
                    border: InputBorder.none, 
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black26)
                  ),
                ),
              ),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  height: 45, width: 45,
                  decoration: const BoxDecoration(color: Color(0xFF1A1A1A), shape: BoxShape.circle),
                  child: const Icon(CupertinoIcons.paperplane_fill, color: Colors.white, size: 16),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickChip(String label) {
    return GestureDetector(
      onTap: () => setState(() => _messageController.text = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F3), 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: const Color(0xFFFFB6C1).withOpacity(0.4))
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFD48B93))),
      ),
    );
  }

  Widget _paymentOption(String title, String price, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFBFBFB), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withOpacity(0.05))),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A1A1A), size: 20),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD48B93))),
        ],
      ),
    );
  }
}

class _MysticChatPainter extends CustomPainter {
  final double val;
  _MysticChatPainter(this.val);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.4);
    final paint = Paint()
      ..color = const Color(0xFFFFB6C1).withOpacity(0.4) 
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(val * 2 * math.pi);
    canvas.drawCircle(Offset.zero, size.width * 0.45, paint);
    for (int i = 0; i < 12; i++) {
      double angle = i * 30 * math.pi / 180;
      canvas.drawLine(Offset.zero, Offset(math.cos(angle) * 350, math.sin(angle) * 350), paint);
    }
    canvas.restore();
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}