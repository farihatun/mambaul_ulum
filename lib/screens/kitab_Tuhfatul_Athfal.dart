import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class KitabScreen extends StatefulWidget {
  const KitabScreen({super.key});

  @override
  State<KitabScreen> createState() => _KitabScreenState();
}

class _KitabScreenState extends State<KitabScreen> {
  late final String viewId;

  @override
  void initState() {
    super.initState();

    viewId = 'tuhfatul-athfal-${DateTime.now().millisecondsSinceEpoch}';

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

          Expanded(
            child: HtmlElementView(
              viewType: viewId,
            ),
          ),
        ],
      ),
    );
  }
}