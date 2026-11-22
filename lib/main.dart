import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

// Root aplikasi & tema utama
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5038BC)),
        useMaterial3: true,
      ),
      home: const MoodHomePage(),
    );
  }
}

// Halaman utama Mood Tracker (sesuai desain Figma Home)
class MoodHomePage extends StatelessWidget {
  const MoodHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            // Konten utama (bisa di-scroll)
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TopStatusBar(),
                  const SizedBox(height: 20),

                  // Header sapaan & streak
                  const _HeaderSection(
                    nama: 'Zika',
                    sapaan: 'Halo, Zika 👋',
                    pertanyaan: 'Bagaimana perasaanmu hari ini?',
                    streakText: '🔥  5 hari berturut-turut mencatat mood',
                  ),
                  const SizedBox(height: 32),

                  // Daftar mood: Hari Ini
                  const _SectionTitle(judul: 'Hari Ini'),
                  const SizedBox(height: 8),
                  const _MoodCard(
                    judulMood: 'Bersemangat',
                    jam: '14:20',
                    catatan: '·  Dapat kabar baik dari klien, semangat banget!',
                    warnaBadge: Color(0xFFFF7EB6),
                    assetPath: 'Assets/Pinkmood.svg',
                  ),
                  const SizedBox(height: 12),
                  const _MoodCard(
                    judulMood: 'Tenang',
                    jam: '11:00',
                    catatan: '·  Meditasi pagi terasa menenangkan',
                    warnaBadge: Color(0xFF4ECDC4),
                    assetPath: 'Assets/CyanMood.svg',
                  ),
                  const SizedBox(height: 12),
                  const _MoodCard(
                    judulMood: 'Senang',
                    jam: '08:30',
                    catatan: '·  Pagi yang cerah dan menyenangkan',
                    warnaBadge: Color(0xFFFFC247),
                    assetPath: 'Assets/OrangeMood.svg',
                  ),
                  const SizedBox(height: 28),

                  // Daftar mood: Kemarin
                  const _SectionTitle(judul: 'Kemarin'),
                  const SizedBox(height: 8),
                  const _MoodCard(
                    judulMood: 'Sedih',
                    jam: '20:15',
                    catatan: '·  Kangen rumah tiba-tiba',
                    warnaBadge: Color(0xFF5B9BF0),
                    assetPath: 'Assets/BlueMood.svg',
                  ),
                  const SizedBox(height: 12),
                  const _MoodCard(
                    judulMood: 'Cemas',
                    jam: '09:00',
                    catatan: '·  Deadline bikin deg-degan',
                    warnaBadge: Color(0xFFB49AF2),
                    assetPath: 'Assets/PurpleMood.svg',
                  ),
                ],
              ),
            ),

            // Tombol tambah (+) di kanan bawah
            Positioned(
              right: 24,
              bottom: 24,
              child: _AddMoodButton(
                onTap: () {
                  // Aksi saat tombol '+' ditekan
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tombol tambah mood ditekan!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Status bar atas (9:41, sinyal, baterai)
class _TopStatusBar extends StatelessWidget {
  const _TopStatusBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final tinggi in [4.0, 6.0, 8.0, 10.0]) ...[
                  Container(
                    width: 2.6,
                    height: tinggi,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
                Container(
                  width: 24,
                  height: 12,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.3, color: const Color(0xFF111827)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 17,
                      height: 7,
                      margin: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 1.6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(1),
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

// Header sapaan, avatar, dan badge streak
class _HeaderSection extends StatelessWidget {
  final String nama;
  final String sapaan;
  final String pertanyaan;
  final String streakText;

  const _HeaderSection({
    required this.nama,
    required this.sapaan,
    required this.pertanyaan,
    required this.streakText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sapaan,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.44,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pertanyaan,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE4DEF7),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                nama.isNotEmpty ? nama[0].toUpperCase() : 'Z',
                style: const TextStyle(
                  color: Color(0xFF5038BC),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE4DEF7),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                streakText,
                style: const TextStyle(
                  color: Color(0xFF5038BC),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Judul section ("Hari Ini", "Kemarin")
class _SectionTitle extends StatelessWidget {
  final String judul;

  const _SectionTitle({required this.judul});

  @override
  Widget build(BuildContext context) {
    return Text(
      judul,
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// Komponen card mood yang dipakai berulang
class _MoodCard extends StatelessWidget {
  final String judulMood;
  final String jam;
  final String catatan;
  final Color warnaBadge;
  final String assetPath;

  const _MoodCard({
    required this.judulMood,
    required this.jam,
    required this.catatan,
    required this.warnaBadge,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x284F38BC),
            blurRadius: 16,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          _MoodAvatar(warna: warnaBadge, assetPath: assetPath),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judulMood,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.38,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      jam,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        catatan,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            height: 32,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (_) => Container(
                  width: 3.5,
                  height: 3.5,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B7280),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ikon mood dari folder Assets/ (sesuaikan SvgPicture.asset jika pakai flutter_svg)
class _MoodAvatar extends StatelessWidget {
  final Color warna;
  final String assetPath;

  const _MoodAvatar({required this.warna, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      // Jika kamu memakai package flutter_svg, ganti bagian ini menjadi:
      // SvgPicture.asset(assetPath, width: 36, height: 36)
      child: SvgPicture.asset(
        assetPath,
        width: 36,
        height: 36,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.sentiment_satisfied_alt, color: warna, size: 24);
        },
      ),
    );
  }
}

// Tombol (+) interaktif
class _AddMoodButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMoodButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF5038BC),
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: const Color(0x284F38BC),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}