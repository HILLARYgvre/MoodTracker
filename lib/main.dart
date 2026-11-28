import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart'; 

void main() {
  runApp(const MyApp());
}


// MODEL DATA & ENUM MOOD
enum MoodType {
  happy,
  sad,
  angry,
  calm,
  anxious,
  excited,
}

class MoodItem {
  final String id;
  final MoodType type;
  final String jam;
  final String catatan;
  final bool isToday;
  final DateTime tanggal;

  const MoodItem({
    required this.id,
    required this.type,
    required this.jam,
    required this.catatan,
    required this.isToday,
    required this.tanggal,
  });

  MoodItem copyWith({
    String? id,
    MoodType? type,
    String? jam,
    String? catatan,
    bool? isToday,
    DateTime? tanggal,
  }) {
    return MoodItem(
      id: id ?? this.id,
      type: type ?? this.type,
      jam: jam ?? this.jam,
      catatan: catatan ?? this.catatan,
      isToday: isToday ?? this.isToday,
      tanggal: tanggal ?? this.tanggal,
    );
  }
}

class MoodMeta {
  final MoodType type;
  final String label;
  final String assetPath;
  final Color primaryColor;
  final Color softColor;

  const MoodMeta({
    required this.type,
    required this.label,
    required this.assetPath,
    required this.primaryColor,
    required this.softColor,
  });
}

// ASET ICON MOOD
class UserProfileData {
  final String name;
  final Uint8List? photoBytes;
  final String? presetAvatarAsset;

  const UserProfileData({
    required this.name,
    this.photoBytes,
    this.presetAvatarAsset,
  });

  UserProfileData copyWith({
    String? name,
    Uint8List? photoBytes,
    bool clearPhotoBytes = false,
    String? presetAvatarAsset,
    bool clearPresetAvatar = false,
  }) {
    return UserProfileData(
      name: name ?? this.name,
      photoBytes: clearPhotoBytes ? null : (photoBytes ?? this.photoBytes),
      presetAvatarAsset: clearPresetAvatar
          ? null
          : (presetAvatarAsset ?? this.presetAvatarAsset),
    );
  }
}

const Map<MoodType, MoodMeta> kMoodCatalog = {
  MoodType.happy: MoodMeta(
    type: MoodType.happy,
    label: 'Senang',
    assetPath: 'Assets/OrangMood.svg',
    primaryColor: Color(0xFFFFC247),
    softColor: Color(0xFFFFF3D6),
  ),
  MoodType.sad: MoodMeta(
    type: MoodType.sad,
    label: 'Sedih',
    assetPath: 'Assets/BlueMood.svg',
    primaryColor: Color(0xFF5B9BF0),
    softColor: Color(0xFFE6F0FD),
  ),
  MoodType.angry: MoodMeta(
    type: MoodType.angry,
    label: 'Marah',
    assetPath: 'Assets/MerahMood.svg',
    primaryColor: Color(0xFFFF6B57),
    softColor: Color(0xFFFFEAE7),
  ),
  MoodType.calm: MoodMeta(
    type: MoodType.calm,
    label: 'Tenang',
    assetPath: 'Assets/CyanMood.svg',
    primaryColor: Color(0xFF4ECDC4),
    softColor: Color(0xFFE3F8F6),
  ),
  MoodType.anxious: MoodMeta(
    type: MoodType.anxious,
    label: 'Cemas',
    assetPath: 'Assets/PurpleMood.svg',
    primaryColor: Color(0xFFB49AF2),
    softColor: Color(0xFFF1ECFD),
  ),
  MoodType.excited: MoodMeta(
    type: MoodType.excited,
    label: 'Bersemangat',
    assetPath: 'Assets/Pinkmood.svg',
    primaryColor: Color(0xFFFF7EB6),
    softColor: Color(0xFFFFE8F2),
  ),
};


// ROOT APLIKASI & TEMA
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5038BC)),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}


// 1. LAYAR ONBOARDING (3 SLIDE: WELCOME, TRACK, INSIGHTS)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MoodHomePage()),
    );
  }

  void _nextPage() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol "Lewati" di kanan atas (kecuali halaman terakhir)
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isLastPage)
                      TextButton(
                        onPressed: _goToHome,
                        child: const Text(
                          'Lewati',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Konten 3 halaman onboarding
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: const [
                  _OnboardingSlideWelcome(),
                  _OnboardingSlideTrack(),
                  _OnboardingSlideInsights(),
                ],
              ),
            ),

            // Indikator titik (3 dot)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final active = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: active ? 22 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF5038BC) : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Tombol utama bawah ("Lanjut" / "Mulai Sekarang")
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5038BC),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    isLastPage ? 'Mulai Sekarang' : 'Lanjut',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideWelcome extends StatelessWidget {
  const _OnboardingSlideWelcome();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 290,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // [ASET BOLA] PinkBola.svg di kiri
              Positioned(
                left: -55,
                top: 10,
                child: SvgPicture.asset(
                  'Assets/PinkBola.svg',
                  width: 210,
                  height: 210,
                ),
              ),
              // [ASET BOLA] CyanBola.svg di kanan bawah
              Positioned(
                right: -45,
                bottom: 10,
                child: SvgPicture.asset(
                  'Assets/CyanBola.svg',
                  width: 190,
                  height: 190,
                ),
              ),
              // [ASET MOOD] OrangMood.svg di tengah
              Center(
                child: SvgPicture.asset(
                  'Assets/OrangMood.svg',
                  width: 124,
                  height: 124,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Kenali Setiap\nPerasaanmu',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            'Setiap mood yang kamu rasakan itu berharga. Catat, pahami, dan rayakan perjalanan emosimu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingSlideTrack extends StatelessWidget {
  const _OnboardingSlideTrack();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 290,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // [ASET BOLA] BlueBola.svg & OrangeBola.svg
              Positioned(
                left: -40,
                bottom: 12,
                child: SvgPicture.asset(
                  'Assets/BlueBola.svg',
                  width: 150,
                  height: 150,
                ),
              ),
              Positioned(
                right: -45,
                top: 16,
                child: SvgPicture.asset(
                  'Assets/OrangeBola.svg',
                  width: 160,
                  height: 160,
                ),
              ),
              Center(
                child: Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  alignment: WrapAlignment.center,
                  children: [
                    SvgPicture.asset('Assets/Pinkmood.svg', width: 76, height: 76),
                    SvgPicture.asset('Assets/CyanMood.svg', width: 76, height: 76),
                    SvgPicture.asset('Assets/PurpleMood.svg', width: 76, height: 76),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Catat Mood dalam\nHitungan Detik',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            'Pilih mood, tambahkan catatan singkat, dan selesai. Secepat itu untuk mengenal dirimu lebih baik.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingSlideInsights extends StatelessWidget {
  const _OnboardingSlideInsights();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 290,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // [ASET BOLA] unguBola.svg & merahBola.svg
              Positioned(
                left: -50,
                top: 24,
                child: SvgPicture.asset(
                  'Assets/unguBola.svg',
                  width: 185,
                  height: 185,
                ),
              ),
              Positioned(
                right: -55,
                bottom: 8,
                child: SvgPicture.asset(
                  'Assets/merahBola.svg',
                  width: 185,
                  height: 185,
                ),
              ),
              Center(
                child: SizedBox(
                  width: 240,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      SvgPicture.asset('Assets/OrangMood.svg', width: 64, height: 64),
                      SvgPicture.asset('Assets/BlueMood.svg', width: 64, height: 64),
                      SvgPicture.asset('Assets/MerahMood.svg', width: 64, height: 64),
                      SvgPicture.asset('Assets/CyanMood.svg', width: 64, height: 64),
                      SvgPicture.asset('Assets/PurpleMood.svg', width: 64, height: 64),
                      SvgPicture.asset('Assets/Pinkmood.svg', width: 64, height: 64),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Temukan Pola\n& Pemicunya',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            'Lihat tren emosimu dari waktu ke waktu dan pahami apa yang memengaruhi harimu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
// 2. LAYAR HOME (DAFTAR MOOD HARI INI & KEMARIN)
class MoodHomePage extends StatefulWidget {
  const MoodHomePage({super.key});

  @override
  State<MoodHomePage> createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage> {
  final String _userName = 'i will survive';
  int _streakDays = 5;

  final List<MoodItem> _moods = [
    MoodItem(
      id: '1',
      type: MoodType.excited,
      jam: '14:20',
      catatan: 'Saya akan lawan !',
      isToday: true,
      tanggal: DateTime(2026, 11, 5),
    ),
    MoodItem(
      id: '2',
      type: MoodType.calm,
      jam: '11:00',
      catatan: 'kalkulus hari ini masuk di otak',
      isToday: true,
      tanggal: DateTime(2026, 11, 5),
    ),
    MoodItem(
      id: '3',
      type: MoodType.happy,
      jam: '08:30',
      catatan: 'Tugas Manbis kelar slurp',
      isToday: true,
      tanggal: DateTime(2026, 11, 5),
    ),
    MoodItem(
      id: '4',
      type: MoodType.sad,
      jam: '20:15',
      catatan: 'homesick',
      isToday: false,
      tanggal: DateTime(2026, 11, 4),
    ),
    MoodItem(
      id: '5',
      type: MoodType.anxious,
      jam: '09:00',
      catatan: 'takut uas kak',
      isToday: false,
      tanggal: DateTime(2026, 11, 4),
    ),
  ];

  Future<void> _openAddOrEditMood({MoodItem? existing}) async {
    final result = await Navigator.of(context).push<MoodItem>(
      MaterialPageRoute(
        builder: (_) => AddEditMoodPage(existingMood: existing),
      ),
    );

    if (result == null) return;

    setState(() {
      final index = _moods.indexWhere((m) => m.id == result.id);
      if (index >= 0) {
        _moods[index] = result;
      } else {
        _moods.insert(0, result);
        if (result.isToday) {
          _streakDays += 1;
        }
      }
    });
  }

  void _deleteMood(MoodItem item) {
    setState(() {
      _moods.removeWhere((m) => m.id == item.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood "${kMoodCatalog[item.type]!.label}" dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayMoods = _moods.where((m) => m.isToday).toList();
    final yesterdayMoods = _moods.where((m) => !m.isToday).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 104),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeHeader(
                    userName: _userName,
                    streakDays: _streakDays,
                  ),
                  const SizedBox(height: 28),

                  const _SectionHeader(title: 'Hari Ini'),
                  const SizedBox(height: 10),
                  if (todayMoods.isEmpty)
                    const _EmptyMoodPlaceholder(text: 'Belum ada catatan mood hari ini.')
                  else
                    for (final item in todayMoods) ...[
                      _MoodCard(
                        item: item,
                        onEdit: () => _openAddOrEditMood(existing: item),
                        onDelete: () => _deleteMood(item),
                      ),
                      const SizedBox(height: 12),
                    ],

                  const SizedBox(height: 16),
                  const _SectionHeader(title: 'Kemarin'),
                  const SizedBox(height: 10),
                  if (yesterdayMoods.isEmpty)
                    const _EmptyMoodPlaceholder(text: 'Belum ada catatan mood kemarin.')
                  else
                    for (final item in yesterdayMoods) ...[
                      _MoodCard(
                        item: item,
                        onEdit: () => _openAddOrEditMood(existing: item),
                        onDelete: () => _deleteMood(item),
                      ),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),

            // Tombol (+) pojok kanan bawah untuk tambah mood baru
            Positioned(
              right: 24,
              bottom: 24,
              child: SizedBox(
                width: 58,
                height: 58,
                child: FloatingActionButton(
                  onPressed: () => _openAddOrEditMood(),
                  backgroundColor: const Color(0xFF5038BC),
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String userName;
  final int streakDays;

  const _HomeHeader({
    required this.userName,
    required this.streakDays,
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
                  'Halo, $userName 👋',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bagaimana perasaanmu hari ini?',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
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
                userName.isNotEmpty ? userName[0].toUpperCase() : 'Z',
                style: const TextStyle(
                  color: Color(0xFF5038BC),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE4DEF7),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                '$streakDays hari berturut-turut mencatat mood',
                style: const TextStyle(
                  color: Color(0xFF5038BC),
                  fontSize: 12,
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _EmptyMoodPlaceholder extends StatelessWidget {
  final String text;

  const _EmptyMoodPlaceholder({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final MoodItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MoodCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final meta = kMoodCatalog[item.type]!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x184F38BC),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // [ASET ICON MOOD] Ditampilkan pada setiap card mood
          _MoodSvgBadge(
            assetPath: meta.assetPath,
            size: 46,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.label,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.jam,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (item.catatan.trim().isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '·  ${item.catatan}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF6B7280), size: 20),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Mood')),
              PopupMenuItem(value: 'delete', child: Text('Hapus')),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. LAYAR TAMBAH / EDIT MOOD (SESUAI DESAIN ADD-EDIT MOOD)
// ============================================================================

class AddEditMoodPage extends StatefulWidget {
  final MoodItem? existingMood;

  const AddEditMoodPage({super.key, this.existingMood});

  @override
  State<AddEditMoodPage> createState() => _AddEditMoodPageState();
}

class _AddEditMoodPageState extends State<AddEditMoodPage> {
  late MoodType _selectedMood;
  late bool _isToday;
  late DateTime _selectedDate;
  late TextEditingController _noteController;

  static const List<String> _bulanIndo = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existingMood;
    _selectedMood = existing?.type ?? MoodType.happy;
    _isToday = existing?.isToday ?? true;
    _selectedDate = existing?.tanggal ??
        (_isToday ? DateTime(2026, 11, 5) : DateTime(2026, 11, 4));
    _noteController = TextEditingController(
      text: existing?.catatan ??
          'Hari ini benar-benar menyenangkan! Ketemu teman lama dan ngobrol banyak hal seru.',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _formatDateLabel() {
    final prefix = _isToday ? 'Hari ini, ' : 'Kemarin, ';
    return '$prefix${_selectedDate.day} ${_bulanIndo[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  String _currentJam() {
    if (widget.existingMood != null) return widget.existingMood!.jam;
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  void _saveMood() {
    final savedItem = MoodItem(
      id: widget.existingMood?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedMood,
      jam: _currentJam(),
      catatan: _noteController.text.trim(),
      isToday: _isToday,
      tanggal: _selectedDate,
    );
    Navigator.of(context).pop(savedItem);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingMood != null;
    final moodsOrder = [
      MoodType.happy,
      MoodType.sad,
      MoodType.angry,
      MoodType.calm,
      MoodType.anxious,
      MoodType.excited,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar "<  Tambah Mood"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left, size: 28, color: Color(0xFF111827)),
                  ),
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Mood' : 'Tambah Mood',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Isi form yang bisa di-scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PopupMenuButton<bool>(
                      onSelected: (todayValue) {
                        setState(() {
                          _isToday = todayValue;
                          _selectedDate = todayValue
                              ? DateTime(2026, 11, 5)
                              : DateTime(2026, 11, 4);
                        });
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: true, child: Text('Hari ini, 5 November 2026')),
                        PopupMenuItem(value: false, child: Text('Kemarin, 4 November 2026')),
                      ],
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF4B5563)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _formatDateLabel(),
                                style: const TextStyle(
                                  color: Color(0xFF1F2937),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Bagaimana perasaanmu?',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Grid 3x2 pilihan mood
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: moodsOrder.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.92,
                      ),
                      itemBuilder: (_, idx) {
                        final type = moodsOrder[idx];
                        final meta = kMoodCatalog[type]!;
                        final isSelected = _selectedMood == type;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedMood = type),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? meta.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? meta.primaryColor : const Color(0xFFE5E7EB),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: meta.primaryColor.withValues(alpha: 0.35),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // [ASET ICON MOOD] Pilihan mood pada grid
                                _MoodSvgBadge(
                                  assetPath: meta.assetPath,
                                  size: 44,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  meta.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF111827)
                                        : const Color(0xFF4B5563),
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Catatan (opsional)',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tulis cerita singkat tentang perasaanmu...',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF5038BC), width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol "Simpan Mood" di bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveMood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5038BC),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Simpan Mood',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// KOMPONEN RENDER SVG DENGAN FALLBACK AMAN
// ============================================================================

class _MoodSvgBadge extends StatelessWidget {
  final String assetPath;
  final double size;

  const _MoodSvgBadge({
    required this.assetPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    // [TEMPAT ASET SVG] Memuat file dari folder Assets/
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.sentiment_satisfied_alt, color: Color(0xFF5038BC)),
      ),
    );
  }
}