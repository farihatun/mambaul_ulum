import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'home_screen.dart';

class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});

  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  PrayerTimes? prayerTimes;
  String nextPrayer = "-";
  String countdown = "-";
  Timer? timer;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAndLoad();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeAndLoad() async {
    try {
      // Inisialisasi locale untuk format tanggal Indonesia
      await initializeDateFormatting('id_ID', null);
      await loadPrayerTimes();
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> loadPrayerTimes() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Lokasi tidak diaktifkan. Silakan aktifkan GPS.';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Izin lokasi ditolak.';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Izin lokasi ditolak permanen.';
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      final coordinates = Coordinates(position.latitude, position.longitude);

      // Menggunakan method Jakarta untuk Indonesia
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.shafi;

      final today = DateComponents.from(DateTime.now());

      final prayer = PrayerTimes(coordinates, today, params);

      setState(() {
        prayerTimes = prayer;
        isLoading = false;
      });

      updateNextPrayer();

      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          updateNextPrayer();
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  void updateNextPrayer() {
    if (prayerTimes == null) return;

    final now = DateTime.now();
    final next = prayerTimes!.nextPrayer();

    DateTime? waktu;

    switch (next) {
      case Prayer.fajr:
        waktu = prayerTimes!.fajr;
        nextPrayer = "Subuh";
        break;
      case Prayer.dhuhr:
        waktu = prayerTimes!.dhuhr;
        nextPrayer = "Dzuhur";
        break;
      case Prayer.asr:
        waktu = prayerTimes!.asr;
        nextPrayer = "Ashar";
        break;
      case Prayer.maghrib:
        waktu = prayerTimes!.maghrib;
        nextPrayer = "Maghrib";
        break;
      case Prayer.isha:
        waktu = prayerTimes!.isha;
        nextPrayer = "Isya";
        break;
      default:
        waktu = prayerTimes!.fajr;
        nextPrayer = "Subuh";
    }

    final diff = waktu.difference(now);

    setState(() {
      if (diff.isNegative) {
        countdown = "00:00:00";
      } else {
        countdown =
            "${diff.inHours.toString().padLeft(2, '0')}:"
            "${(diff.inMinutes % 60).toString().padLeft(2, '0')}:"
            "${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
      }
    });
  }

  String jam(DateTime time) {
    return DateFormat("HH:mm").format(time);
  }

  String getFormattedDate() {
    try {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());
    } catch (e) {
      // Fallback jika locale belum diinisialisasi
      return DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
    }
  }

  Widget prayerCard(String nama, String waktu, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(
          nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            waktu,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B5D35)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Memuat jadwal sholat...",
                      style: TextStyle(
                        color: Color(0xFF0B5D35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B5D35),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                errorMessage = '';
                              });
                              _initializeAndLoad();
                            },
                            child: const Text("Coba Lagi"),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            },
                            child: const Text("Kembali ke Dashboard"),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // HEADER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0B5D35),
                              Color(0xFF1FA463),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.mosque,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Jadwal Sholat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              getFormattedDate(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // NEXT PRAYER
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFC107),
                                Color(0xFFFFD54F),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Sholat Berikutnya",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                nextPrayer,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                countdown,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              const Text(
                                "Menuju waktu sholat",
                                style: TextStyle(
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // DAFTAR SHOLAT
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            prayerCard(
                              "Imsak",
                              jam(prayerTimes!.fajr.subtract(
                                const Duration(minutes: 10),
                              )),
                              Icons.alarm,
                            ),
                            prayerCard(
                              "Subuh",
                              jam(prayerTimes!.fajr),
                              Icons.dark_mode,
                            ),
                            prayerCard(
                              "Dzuhur",
                              jam(prayerTimes!.dhuhr),
                              Icons.wb_sunny,
                            ),
                            prayerCard(
                              "Ashar",
                              jam(prayerTimes!.asr),
                              Icons.sunny,
                            ),
                            prayerCard(
                              "Maghrib",
                              jam(prayerTimes!.maghrib),
                              Icons.nightlight,
                            ),
                            prayerCard(
                              "Isya",
                              jam(prayerTimes!.isha),
                              Icons.bedtime,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 55,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0B5D35),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.home),
                                label: const Text("Kembali ke Dashboard"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}