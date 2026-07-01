import 'dart:io';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Conditional imports: genuine web libraries on Chrome, safe stub on Android
import 'web_stub.dart' if (dart.library.js_interop) 'dart:ui_web' as ui;
import 'web_stub.dart' if (dart.library.js_interop) 'package:web/web.dart' as web;
import 'web_stub.dart' if (dart.library.js_util) 'package:flutter_pdfview/flutter_pdfview.dart' as mobile_pdf;

class HizibScreen extends StatefulWidget {
  const HizibScreen({super.key});

  @override
  State<HizibScreen> createState() => _HizibScreenState();
}

class _HizibScreenState extends State<HizibScreen> {
  final String viewId = 'hizib-pdf-viewer';
  String? localPdfPath;
  bool isPreparingMobilePdf = true;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // 1. Setup Web IFrame Engine
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int viewId) {
          final iframe = web.HTMLIFrameElement()
            ..src = 'assets/pdf/Hizib.pdf'
            ..style.border = 'none'
            ..width = '100%'
            ..height = '100%';

          return iframe;
        },
      );
    } else {
      // 2. Setup Mobile Engine: Copy asset file to device storage so the PDF viewer can read it
      prepareLocalPdf();
    }
  }

  Future<void> prepareLocalPdf() async {
    try {
      final byteData = await rootBundle.load('assets/pdf/Hizib.pdf');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Hizib.pdf');
      
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
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        title: const Text(
          'Hizib Nahdlatul Wathan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F6B3E),
        foregroundColor: Colors.white,
      ),
      // Use kIsWeb to separate mobile layout from web layout
      body: kIsWeb
          ? HtmlElementView(viewType: viewId) // Web Engine
          : isPreparingMobilePdf
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0F6B3E),
                  ),
                )
              : localPdfPath != null
                  ? mobile_pdf.PDFView(filePath: localPdfPath) // Native Mobile Engine
                  : const Center(
                      child: Text(
                        "Gagal memuat PDF",
                        style: TextStyle(color: Color(0xFF0F6B3E)),
                      ),
                    ),
    );
  }
}
