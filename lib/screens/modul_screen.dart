import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Conditional imports: genuine web libraries on Chrome, safe stub on Android
import 'web_stub.dart' if (dart.library.js_interop) 'dart:ui_web' as ui_web;
import 'web_stub.dart' if (dart.library.js_interop) 'package:universal_html/html.dart' as html;
import 'web_stub.dart' if (dart.library.js_util) 'package:flutter_pdfview/flutter_pdfview.dart' as mobile_pdf;
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
  String? _localPdfPath;
  bool _isDownloadingMobilePdf = true;

  @override
  void initState() {
    super.initState();
    _viewId = 'pdf-iframe-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      // 1. Web Configuration
      ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
        final element = html.IFrameElement()
          ..src = widget.fileUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return element;
      });
    } else {
      // 2. Mobile Configuration: Download the remote file into the phone's memory cache
      downloadNetworkPdf();
    }
  }

  Future<void> downloadNetworkPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.fileUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        
        // Use a unique file name derived from the URL or timestamp
        final filename = 'modul_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${tempDir.path}/$filename');
        
        await file.writeAsBytes(bytes, flush: true);
        
        setState(() {
          _localPdfPath = file.path;
          _isDownloadingMobilePdf = false;
        });
      } else {
        throw Exception("Gagal mengunduh file, status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isDownloadingMobilePdf = false);
      print("Error downloading network PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF0B5D35),
        foregroundColor: Colors.white,
      ),
      body: kIsWeb
          ? HtmlElementView(viewType: _viewId) // Web Engine
          : _isDownloadingMobilePdf
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0B5D35),
                  ),
                )
              : _localPdfPath != null
                  ? mobile_pdf.PDFView(filePath: _localPdfPath) // Native Mobile Engine
                  : const Center(
                      child: Text(
                        "Gagal menampilkan PDF modul.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0B5D35),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
    );
  }
}
