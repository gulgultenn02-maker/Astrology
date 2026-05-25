import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthDetailsSwipeScreen extends StatefulWidget {
  final VoidCallback onNext;
  const BirthDetailsSwipeScreen({super.key, required this.onNext});

  @override
  State<BirthDetailsSwipeScreen> createState() => _BirthDetailsSwipeScreenState();
}

class _BirthDetailsSwipeScreenState extends State<BirthDetailsSwipeScreen> {
  // Seçim verileri
  String? selectedDate;
  String? selectedTime;
  String? selectedPlace;
  String? selectedStatus;

  // İlerleme yüzdesini hesapla (4 alan üzerinden)
  double get progress {
    int count = 0;
    if (selectedDate != null) count++;
    if (selectedTime != null) count++;
    if (selectedPlace != null) count++;
    if (selectedStatus != null) count++;
    return count / 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. ARKA PLAN PEMBE LEKE (Görseldeki gibi soft ve yayılmış)
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    const Color(0xFFFF5252).withOpacity(0.35), // Canlı ama şeffaf pembe/kırmızı
                    const Color(0xFFFFEAEA).withOpacity(0.1), 
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // 2. İÇERİK
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildBackButton(),
                  
                  const SizedBox(height: 80),

                  // BAŞLIK: YAN YANA, DÜZ VE İNCE
                  Text(
                    "Kozmik Kimliğin",
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.w200, // Ultra ince
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    "Yıldız haritanı eksiksiz hesaplamak için bu adımları tamamlaman gerekiyor.",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5),
                      height: 1.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // GÖRSELDEKİ PROGRESS KARTI
                  _buildProgressCard(),

                  const SizedBox(height: 40),
                  
                  Text(
                    "ADIMLAR",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // MİNİMALİST LİSTE ELEMANLARI (Belirle Formatında)
                  _buildTaskItem("Doğum Tarihi Belirle", selectedDate ?? "Henüz seçilmedi", CupertinoIcons.calendar, () => _showDatePicker(context)),
                  _buildTaskItem("Doğum Saati Belirle", selectedTime ?? "Henüz seçilmedi", CupertinoIcons.time, () => _showTimePicker(context)),
                  _buildTaskItem("Doğum Yeri Belirle", selectedPlace ?? "Henüz seçilmedi", CupertinoIcons.location, () => _showLocationPicker()),
                  _buildTaskItem("İlişki Durumu Belirle", selectedStatus ?? "Henüz seçilmedi", CupertinoIcons.heart, () => _showStatusPicker(context)),

                  const SizedBox(height: 50),
                  
                  // SONRAKİ ADIM BUTONU
                  _buildNextButton(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI BİLEŞENLERİ ---

  Widget _buildBackButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Profil Tamamlanma", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 4),
              Text("${(progress * 4).toInt()} / 4 görev tamamlandı", style: const TextStyle(color: Colors.black45)),
              const SizedBox(height: 16),
              // İlerleme Çubuğu
              Container(
                width: 140,
                height: 4,
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ],
          ),
          Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    bool isFilled = !subtitle.contains("Henüz");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: isFilled ? const Color(0xFFE91E63) : Colors.black45),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(subtitle, style: TextStyle(color: isFilled ? Colors.black87 : Colors.black38, fontSize: 13)),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, size: 14, color: Colors.black.withOpacity(0.1)),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: progress == 1.0 ? widget.onNext : null, // Hepsi dolmadan aktif olmasın dersen
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text("YILDIZ HARİTAMI GÖSTER", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  // --- SEÇİM MODALLARI (Aynı Kaldı) ---

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SizedBox(height: 300, child: CupertinoDatePicker(mode: CupertinoDatePickerMode.date, onDateTimeChanged: (date) => setState(() => selectedDate = "${date.day}.${date.month}.${date.year}"))),
    );
  }

  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SizedBox(height: 300, child: CupertinoDatePicker(mode: CupertinoDatePickerMode.time, onDateTimeChanged: (time) => setState(() => selectedTime = "${time.hour}:${time.minute}"))),
    );
  }

  void _showStatusPicker(BuildContext context) {
    final options = ["Yalnız", "İlişkisi Var", "Evli", "Flört"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Column(mainAxisSize: MainAxisSize.min, children: options.map((e) => ListTile(title: Text(e, textAlign: TextAlign.center), onTap: () { setState(() => selectedStatus = e); Navigator.pop(context); })).toList())),
    );
  }

  void _showLocationPicker() { setState(() => selectedPlace = "İstanbul, Türkiye"); }
}