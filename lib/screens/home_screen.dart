import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hizib_screen.dart';
import 'barzanji_screen.dart';
import 'absensi_screen.dart';
import 'modul_screen.dart';
import 'jadwal_sholat_screen.dart';
import 'kitab_Tuhfatul_Athfal.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import '../services/prayerTime.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;

  const HomeScreen({super.key, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  late Timer timer;
  DateTime now = DateTime.now();
  PrayerTime? _jadwalShalat;

  String _waktuSekarang = "00:00:00";
  String _statusShalat = "Memuat jadwal...";
  String _hitungMundur = "00:00:00";

  // Nama user yang login
  String userName = "Santri";

  // Untuk simulasi jadwal sholat berikutnya
  String nextPrayer = "Dzuhur";
  String nextPrayerTime = "12:15";

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchJadwalShalat();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateClockAndCountdown();
      setState(() {
        now = DateTime.now();
      });
    });
  }

  // 1. AMBIL DATA DARI API LARAVEL
  Future<void> _fetchJadwalShalat() async {
    try {
      // Sesuaikan URL dengan route API Laravel Anda
      final response = await http.get(
        Uri.parse('http://157.10.252.115/api/jadwal-shalat'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _jadwalShalat = PrayerTime.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print("Error Fetching: $e");
    }
  }

  // 2. LOGIKA JAM LIVE & COUNTDOWN
  void _updateClockAndCountdown() {
    final now = DateTime.now();

    // Format Jam Realtime WITA / Lokal HP
    final String formattedTime = DateFormat('HH:mm:ss').format(now);

    setState(() {
      _waktuSekarang = "Waktu saat ini: $formattedTime WITA";
    });

    // Jika data API belum siap, hentikan logika countdown
    if (_jadwalShalat == null) return;

    // Daftar target waktu shalat hari ini
    List<Map<String, dynamic>> targetShalat = [
      {'nama': 'Subuh', 'waktu': _jadwalShalat!.fajr},
      {'nama': 'Dzuhur', 'waktu': _jadwalShalat!.dhuhr},
      {'nama': 'Ashar', 'waktu': _jadwalShalat!.asr},
      {'nama': 'Maghrib', 'waktu': _jadwalShalat!.maghrib},
      {'nama': 'Isya', 'waktu': _jadwalShalat!.isha},
    ];

    Map<String, dynamic>? targetBerikutnya;

    // Cari waktu shalat terdekat yang belum terlewat hari ini
    for (var shalat in targetShalat) {
      List<String> splitWaktu = shalat['waktu'].split(':');
      int jam = int.parse(splitWaktu[0]);
      int menit = int.parse(splitWaktu[1]);

      DateTime waktuTarget = DateTime(now.year, now.month, now.day, jam, menit);

      if (waktuTarget.isAfter(now)) {
        targetBerikutnya = {
          'nama': shalat['nama'],
          'objekWaktu': waktuTarget,
          'teksWaktu': shalat['waktu'],
        };
        break;
      }
    }

    // Jika semua shalat hari ini sudah lewat (lewat Isya), target ke Subuh besok
    if (targetBerikutnya == null) {
      List<String> splitWaktu = targetShalat[0]['waktu'].split(':');
      int jam = int.parse(splitWaktu[0]);
      int menit = int.parse(splitWaktu[1]);

      DateTime subuhBesok = DateTime(
        now.year,
        now.month,
        now.day + 1,
        jam,
        menit,
      );
      targetBerikutnya = {
        'nama': 'Subuh (Besok)',
        'objekWaktu': subuhBesok,
        'teksWaktu': targetShalat[0]['waktu'],
      };
    }

    // Hitung Durasi Selisih
    DateTime targetTime = targetBerikutnya['objekWaktu'];
    Duration selisih = targetTime.difference(now);

    // Format string 2 digit (00:00:00)
    String jamSisa = selisih.inHours.toString().padLeft(2, '0');
    String menitSisa = (selisih.inMinutes % 60).toString().padLeft(2, '0');
    String detikSisa = (selisih.inSeconds % 60).toString().padLeft(2, '0');

    setState(() {
      _statusShalat =
          "Menuju ${targetBerikutnya!['nama']} ${targetBerikutnya['teksWaktu']}";
      _hitungMundur = "$jamSisa:$menitSisa:$detikSisa";
    });
  }

  Future<void> _loadUserName() async {
    String name = "";

    if (widget.userName != null && widget.userName!.isNotEmpty) {
      name = widget.userName!;
    } else {
      try {
        final prefs = await SharedPreferences.getInstance();
        name = prefs.getString("nama") ?? "Santri";
      } catch (e) {
        name = "Santri";
      }
    }

    setState(() {
      userName = name;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String getJam() {
    return "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";
  }

  String getTanggal() {
    List<String> hari = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];

    List<String> bulan = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];

    return "${hari[now.weekday - 1]}, ${now.day} ${bulan[now.month]} ${now.year}";
  }

  Widget buildSidebar() {
    return Container(
      width: 230,
      color: const Color(0xff0B5D35),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 65,
                  height: 65,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 55,
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Mamba'ul Ulum",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white24,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.access_time_outlined,
                  title: "Jadwal Sholat",
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const JadwalSholatScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.fact_check_outlined,
                  title: "Absensi",
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AbsensiScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.menu_book_outlined,
                  title: "Modul",
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ModulScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.book,
                  title: "Hizib",
                  isSelected: selectedIndex == 4,
                  onTap: () {
                    setState(() {
                      selectedIndex = 4;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HizibScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.book_outlined,
                  title: "Barzanj",
                  isSelected: selectedIndex == 5,
                  onTap: () {
                    setState(() {
                      selectedIndex = 5;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BarzanjiScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.book,
                  title: "Kitab",
                  isSelected: selectedIndex == 6,
                  onTap: () {
                    setState(() {
                      selectedIndex = 6;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KitabScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Divider(
                  color: Colors.white24,
                  thickness: 0.5,
                  indent: 16,
                  endIndent: 16,
                ),
                const SizedBox(height: 8),
                _buildSidebarItem(
                  icon: Icons.person_outline,
                  title: "Profil",
                  isSelected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.logout_outlined,
                  title: "Keluar",
                  isSelected: false,
                  onTap: () async {
                    try {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                    } catch (e) {
                      // ignore
                    }

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "© 2026 Mamba'ul Ulum",
              style: TextStyle(color: Colors.white38, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white60,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7F6),
      body: Row(
        children: [
          buildSidebar(),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ================= HEADER =================
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Assalamu'alaikum, $userName",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0B5D35),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  getTanggal(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Color(0xff0B5D35),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      getJam(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff0B5D35),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xff0B5D35,
                                        ).withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.mosque,
                                            size: 12,
                                            color: Color(0xff0B5D35),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            _statusShalat,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff0B5D35),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xff0B5D35),
                            child: Text(
                              userName.isNotEmpty && userName != "Santri"
                                  ? userName.substring(0, 2).toUpperCase()
                                  : "MU",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= BANNER =================
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xff0F766E), Color(0xff10B981)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff10B981).withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            bottom: -30,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.03),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Assalamu'alaikum 👋",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Selamat Datang di",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Text(
                                        "Pondok Pesantren Mamba'ul Ulum",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  "assets/images/logo.png",
                                  width: 48,
                                  height: 48,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.school,
                                      color: Colors.white,
                                      size: 40,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= MENU 3 KOLOM =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                        children: [
                          _buildDashboardCard(
                            "Modul",
                            "Materi Pembelajaran",
                            Icons.menu_book,
                            [Colors.green.shade600, Colors.teal.shade600],
                            const ModulScreen(),
                          ),
                          _buildDashboardCard(
                            "Absensi",
                            "Kehadiran Santri",
                            Icons.fact_check,
                            [
                              Colors.orange.shade600,
                              Colors.deepOrange.shade600,
                            ],
                            const AbsensiScreen(),
                          ),
                          _buildDashboardCard(
                            "Hizib",
                            "Hizib Nahdlatul Wathan",
                            Icons.book,
                            [
                              Colors.deepPurple.shade600,
                              Colors.indigo.shade600,
                            ],
                            const HizibScreen(),
                          ),
                          _buildDashboardCard(
                            "Kitab",
                            "Kitab Tajwid",
                            Icons.book,
                            [Colors.blue.shade600, Colors.indigo.shade600],
                            const KitabScreen(),
                          ),
                          _buildDashboardCard(
                            "Al-Barzanji",
                            "Maulid Nabi",
                            Icons.book_outlined,
                            [Colors.pink.shade600, Colors.purple.shade600],
                            const BarzanjiScreen(),
                          ),
                          _buildDashboardCard(
                            "Jadwal Sholat",
                            "Waktu Sholat Harian",
                            Icons.access_time,
                            [Colors.cyan.shade600, Colors.teal.shade600],
                            const JadwalSholatScreen(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String subtitle,
    IconData icon,
    List<Color> colors,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
