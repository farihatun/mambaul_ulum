import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class BarzanjiScreen extends StatefulWidget {
  const BarzanjiScreen({super.key});

  @override
  State<BarzanjiScreen> createState() => _BarzanjiScreenState();
}

class _BarzanjiScreenState extends State<BarzanjiScreen> {
  final String viewId = 'pdf-viewer';

  @override
  void initState() {
    super.initState();

    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = 'assets/pdf/al-barzanji.pdf'
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%';

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Barzanji'),
        backgroundColor: Colors.green,
      ),
      body: HtmlElementView(viewType: viewId),
    );
  }
}
