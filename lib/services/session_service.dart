import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  // 1. Menyimpan Token / Data Login
  static Future<void> saveSession(String token, int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setInt('user_id', userId);
    await prefs.setBool('is_logged_in', true);
  }

  // 2. Mengambil Token (Untuk Request API HTTP Header)
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // 3. Mengecek Apakah User Sudah Login atau Belum
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // 4. Menghapus Session (Log Out)
  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.setBool('is_logged_in', false);
    // Atau gunakan prefs.clear() jika ingin menghapus semua data di lokal
  }
}
