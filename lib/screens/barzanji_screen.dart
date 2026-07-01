import 'dart:io';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Conditional imports: Loads genuine web libraries on Chrome, loads the safe stub on Android
import 'web_stub.dart' if (dart.library.js_interop) 'dart:ui_web' as ui;
import 'web_stub.dart' if (dart.library.js_interop) 'package:web/web.dart' as web;
import 'web_stub.dart' if (dart.library.js_util) 'package:flutter_pdfview/flutter_pdfview.dart' as mobile_pdf;

class BarzanjiScreen extends StatefulWidget {
  const BarzanjiScreen({super.key});

  @override
  State<BarzanjiScreen> createState() => _BarzanjiScreenState();
}

class _BarzanjiScreenState extends State<BarzanjiScreen> {
  final String viewId = 'al-barzanji-pdf-viewer';
  String? localPdfPath;
  bool isPreparingMobilePdf = true;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // 1. Web Engine Initialization
      ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = 'assets/pdf/al-barzanji.pdf'
          ..style.border = 'none'
          ..width = '100%'
          ..height = '100%';
        return iframe;
      });
    } else {
      // 2. Mobile Engine Initialization: Copy asset to local device storage
      prepareLocalPdf();
    }
  }

  Future<void> prepareLocalPdf() async {
    try {
      final byteData = await rootBundle.load('assets/pdf/al-barzanji.pdf');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/al-barzanji.pdf');
      
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
      appBar: AppBar(
        title: const Text('Al-Barzanji'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: kIsWeb
          ? HtmlElementView(viewType: viewId) // Web view engine
          : isPreparingMobilePdf
              ? const Center(child: CircularProgressIndicator(color: Colors.green))
              : localPdfPath != null
                  ? mobile_pdf.PDFView(filePath: localPdfPath) // Native Mobile View engine
                  : const Center(child: Text("Gagal memuat PDF")),
    );
  }
}
