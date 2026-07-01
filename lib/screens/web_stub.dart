// lib/screens/web_stub.dart
import 'package:flutter/material.dart';

// 1. Shims for platform view registrations (Fixes UI registration compiler crashes)
class FakePlatformViewRegistry {
  void registerViewFactory(String viewId, dynamic cb) {}
}

// 2. Shims for HTML DOM structural nodes (Fixes IFrame element property setter crashes)
class FakeIFrameElement {
  String src = '';
  var style = FakeStyle();
  String width = '';  
  String height = ''; 
}

class FakeStyle {
  String border = '';
  String width = '';
  String height = '';
}

// Global variable and type mappings assigned for Android cross-compiling
final platformViewRegistry = FakePlatformViewRegistry();
typedef IFrameElement = FakeIFrameElement;
typedef HTMLIFrameElement = FakeIFrameElement;

// 3. Shims for flutter_pdfview package (Fixes Web/Chrome compiler validation check crashes)
class PDFView extends StatelessWidget {
  final String? filePath;
  final String? pdfData;
  const PDFView({super.key, this.filePath, this.pdfData});
  
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
