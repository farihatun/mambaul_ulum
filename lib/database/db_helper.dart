import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  static const String usersKey = 'users';
  static const String absensiKey = 'absensi';

  Future<void> initAdmin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(usersKey)) {
      List<Map<String, dynamic>> users = [
        {
          'id': 1,
          'nama': 'Administrator',
          'email': 'mambaululum@gmail.com',
          'password': 'Mambaululum',
          'role': 'admin',
        }
      ];

      await prefs.setString(
        usersKey,
        jsonEncode(users),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString(usersKey);

    if (data == null) return [];

    List decoded = jsonDecode(data);

    return decoded.cast<Map<String, dynamic>>();
  }

  Future<int> registerUser(
    String nama,
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> users =
        await getAllUsers();

    int newId = users.isEmpty
        ? 1
        : users.last['id'] + 1;

    users.add({
      'id': newId,
      'nama': nama,
      'email': email,
      'password': password,
      'role': 'user',
    });

    await prefs.setString(
      usersKey,
      jsonEncode(users),
    );

    return newId;
  }

  Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final users = await getAllUsers();

    try {
      return users.firstWhere(
        (user) =>
            user['email'] == email &&
            user['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ================= ABSENSI =================

  Future<void> simpanAbsensi({
    required String nama,
    required String tanggal,
    required String status,
    required String alasan,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String? data =
        prefs.getString(absensiKey);

    List<Map<String, dynamic>> absensi =
        [];

    if (data != null) {
      List decoded = jsonDecode(data);

      absensi =
          decoded.cast<Map<String, dynamic>>();
    }

    absensi.add({
      'nama': nama,
      'tanggal': tanggal,
      'status': status,
      'alasan': alasan,
      'waktu':
          DateTime.now().toString(),
    });

    await prefs.setString(
      absensiKey,
      jsonEncode(absensi),
    );
  }

  Future<List<Map<String, dynamic>>>
      getAllAbsensi() async {
    final prefs = await SharedPreferences.getInstance();

    String? data =
        prefs.getString(absensiKey);

    if (data == null) return [];

    List decoded = jsonDecode(data);

    return decoded.cast<Map<String, dynamic>>();
  }
}