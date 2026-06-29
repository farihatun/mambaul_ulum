import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const String usersKey = 'users';

  Future<void> initDatabase() async {
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

  Future<bool> emailSudahAda(String email) async {
    final users = await getAllUsers();

    return users.any(
      (user) => user['email'] == email,
    );
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
        : (users.last['id'] as int) + 1;

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

  Future<void> deleteUser(int id) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> users =
        await getAllUsers();

    users.removeWhere(
      (user) => user['id'] == id,
    );

    await prefs.setString(
      usersKey,
      jsonEncode(users),
    );
  }
}