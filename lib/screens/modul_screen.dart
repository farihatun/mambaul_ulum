import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui_web' as ui_web;
import 'package:universal_html/html.dart' as html;
import '../services/api_service.dart';

class ModulScreen extends StatefulWidget {
  const ModulScreen({super.key});

  @override
  State<ModulScreen> createState() => _ModulScreenState();
}

class _ModulScreenState extends State<ModulScreen> {
  List<dynamic> modulList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadModul();
  }

  Future<void> loadModul() async {
    try {
      final data = await ApiService.getModul();

      setState(() {
        modulList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat modul: $e")));
    }
  }

  Future<void> refreshData() async {
    await loadModul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),

      appBar: AppBar(
        title: const Text(
          "Modul Pembelajaran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0B5D35),
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: refreshData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : modulList.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada modul tersedia",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: modulList.length,
                itemBuilder: (context, index) {
                  final modul = modulList[index];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),

                      leading: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.picture_as_pdf, color: Colors.white),
                      ),

                      title: Text(
                        modul['judul'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        modul['deskripsi'] ?? 'Tidak ada deskripsi',
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                      onTap: () {
                        final fileUrl = modul['file_url'] ?? '';

                        print("PDF URL = $fileUrl");

                        if (fileUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("File PDF tidak ditemukan"),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfViewerScreen(
                              title: modul['judul'] ?? 'Modul',
                              fileUrl: fileUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String fileUrl;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.fileUrl,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late String _viewId;

  @override
  void initState() {
    super.initState();
    // Membuat ID unik untuk komponen tampilan web HTML
    _viewId = 'pdf-iframe-${DateTime.now().millisecondsSinceEpoch}';

    // Mendaftarkan elemen IFrame bawaan browser ke dalam mesin registrasi Flutter Web
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final element = html.IFrameElement()
        ..src = widget.fileUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      return element;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF0B5D35),
        foregroundColor: Colors.white,
      ),
      // Menampilkan IFrame HTML asli sebagai sebuah Widget Flutter biasa
      body: HtmlElementView(viewType: _viewId),
    );
  }
}
