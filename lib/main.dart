import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MambaulUlumApp());
}

class MambaulUlumApp extends StatelessWidget {
  const MambaulUlumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Mambaul Ulum',

      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor:
            const Color(0xFFF3F7F5),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D5E2A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}