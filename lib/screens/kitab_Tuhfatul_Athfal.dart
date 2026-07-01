import 'dart:io';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Conditional imports: Loads genuine web libraries on Chrome, loads the safe stub on Android
import 'web_stub.dart' if (dart.library.js_interop) 'dart:ui_web' as ui;
import 'web_stub.dart' if (dart.library.js_interop) 'package:web/web.dart' as web;
import 'web_stub.dart' if (dart.library.js_util) 'package:flutter_pdfview/flutter_pdfview.dart' as mobile_pdf;

class KitabScreen extends StatefulWidget {
  const KitabScreen({super.key});

  @override
  State<KitabScreen> createState() => _KitabScreenState();
}

class _KitabScreenState extends State<KitabScreen> {
  late final String viewId;
  String? localPdfPath;
  bool isPreparingMobilePdf = true;

  @override
  void initState() {
    super.initState();
    viewId = 'tuhfatul-athfal-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      // 1. Web Engine Initialization
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int id) {
          final iframe = web.HTMLIFrameElement()
            ..src = 'assets/pdf/Tuhfatul-Athfal.pdf'
            ..style.border = 'none'
            ..width = '100%'
            ..height = '100%';

          return iframe;
        },
      );
    } else {
      // 2. Mobile Engine Initialization: Copy asset to local device storage
      prepareLocalPdf();
    }
  }

  Future<void> prepareLocalPdf() async {
    try {
      final byteData = await rootBundle.load('assets/pdf/Tuhfatul-Athfal.pdf');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Tuhfatul-Athfal.pdf');
      
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      
      setState(() {
        localPdfPath = file.path;
        isPreparingMobilePdf = false;
      });
    } catch (e) {
      setState(() => isPreparingMobilePdf = false);
      print("Error loading local mobile PDF asset: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B5D35),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Kitab Tuhfatul Athfal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B5D35),
                  Color(0xFF2ECC71),
                ],
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Kitab Tuhfatul Athfal",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Separate native layout from web rendering safely
          Expanded(
            child: kIsWeb
                ? HtmlElementView(viewType: viewId) // Web view engine
                : isPreparingMobilePdf
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0B5D35),
                        ),
                      )
                    : localPdfPath != null
                        ? mobile_pdf.PDFView(filePath: localPdfPath) // Native Mobile View engine
                        : const Center(
                            child: Text(
                              "Gagal memuat PDF",
                              style: TextStyle(
                                color: Color(0xFF0B5D35),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
