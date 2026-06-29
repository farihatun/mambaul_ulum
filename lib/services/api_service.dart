import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './session_service.dart';

class ApiService {
  // Flutter Web (Chrome)
  static const String baseUrl = 'http://157.10.252.115/api';

  // Jika Android HP ganti menjadi:
  // static const String baseUrl =
  // 'http://192.168.1.10:8000/api';

  // ================= LOGIN =================

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'email': email, 'password': password},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal koneksi: $e'};
    }
  }

  // ================= REGISTER =================

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'name': name, 'email': email, 'password': password},
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal koneksi: $e'};
    }
  }

  // ================= GET MODUL =================

  static Future<List<dynamic>> getModul() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/modul'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          return jsonData['data'];
        }
      }

      return [];
    } catch (e) {
      debugPrint('GET MODUL ERROR : $e');
      return [];
    }
  }

  // ================= DETAIL MODUL =================

  static Future<Map<String, dynamic>?> getDetailModul(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/modul/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          return jsonData['data'];
        }
      }

      return null;
    } catch (e) {
      debugPrint('DETAIL MODUL ERROR : $e');
      return null;
    }
  }
}
