import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  String status = "Belum Absen";
  final TextEditingController alasanController = TextEditingController();
  final String pondok = "Pondok Pesantren Mamba'ul Ulum";

  bool loading = false;
  bool isInitLoading =
      true; // TAMBAHKAN INI: Flag untuk loading data awal SharedPreferences

  Color getStatusColor() {
    switch (status) {
      case "Hadir":
        return Colors.green;
      case "Izin":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getTanggal() {
    DateTime now = DateTime.now();
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

  String? name_id;
  int? user_id;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        // PERBAIKAN: Gunakan '??' untuk memberikan nilai alternatif jika key di lokal kosong/null
        user_id = prefs.getInt('user_id')!;
        name_id = prefs.getString('nama') ?? 'Santri';
        isInitLoading = false; // Loading data awal selesai
      });
    } catch (e) {
      setState(() {
        isInitLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat data lokal: $e")));
      }
    }
  }

  Future<void> simpanAbsensi(String statusAbsen) async {
    setState(() {
      loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://157.10.252.115/api/absensi"),
        headers: {'Accept': 'application/json'},
        body: {
          'user_id': '${user_id}',
          'tanggal': DateTime.now().toIso8601String(),
          'status': statusAbsen,
          'alasan': statusAbsen == "Izin" ? alasanController.text.trim() : "",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || data["success"] == true) {
        setState(() {
          status = statusAbsen;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data["message"] ?? "Absensi berhasil"),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"] ?? "Gagal menyimpan absensi"),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Tampilkan indikator loading jika SharedPreferences belum selesai dibaca
    if (isInitLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B5D35)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B5D35),
        foregroundColor: Colors.white,
        title: const Text("Absensi Santri"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B5D35), Color(0xFF2ECC71)],
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name_id ??
                        'Santri', // PERBAIKAN: Menghapus operator '!' yang memicu error null
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(pondok, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Text(
                    getTanggal(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: alasanController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Alasan Izin (Opsional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: loading
                    ? null
                    : () {
                        simpanAbsensi("Hadir");
                      },
                icon: const Icon(Icons.check_circle),
                label: const Text("Hadir"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: loading
                    ? null
                    : () {
                        if (alasanController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Masukkan alasan izin"),
                            ),
                          );
                          return;
                        }
                        simpanAbsensi("Izin");
                      },
                icon: const Icon(Icons.info),
                label: const Text("Izin"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text("Kembali ke Beranda"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}