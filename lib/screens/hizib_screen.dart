import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class HizibScreen extends StatefulWidget {
  const HizibScreen({super.key});

  @override
  State<HizibScreen> createState() => _HizibScreenState();
}

class _HizibScreenState extends State<HizibScreen> {
  final String viewId = 'hizib-pdf-viewer';

  @override
  void initState() {
    super.initState();

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

      body: HtmlElementView(
        viewType: viewId,
      ),
    );
  }
}