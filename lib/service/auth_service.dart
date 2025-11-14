import 'dart:convert';
import 'package:desa_go_aplikasi/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String _baseUrl = 'https://spinose-transovarian-merrill.ngrok-free.dev/api';
  
  static const String _tokenKey = 'auth_token';
  Future<LoginModel> login(String serial, String password) async { 
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'serial_number': serial,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      print('DEBUG LOGIN URL: $url');
      print('DEBUG LOGIN Status: ${response.statusCode}');
      print('DEBUG LOGIN Body: ${response.body}');

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final loginData = LoginModel.fromJson(responseBody);
        
        if (loginData.accessToken != null) {
          await _saveToken(loginData.accessToken!);
          print('✅ Token berhasil disimpan.');
        }
        
        return loginData;
      } else {
        String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan saat login.';
        throw Exception(errorMessage);
      }
    } catch (e) {
        print('❌ Error saat login (Catch All): $e');
        throw Exception('Terjadi kesalahan yang tidak terduga saat login. $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Opsional: Panggil API logout jika ada untuk invalidate token di server
    final token = await getToken();
    if (token != null) {
      await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    }
    
    // Hapus token dari SharedPreferences
    await prefs.remove(_tokenKey);
    print('🔑 Token lokal telah dihapus.');
  }

  /// Menyimpan token ke SharedPreferences (metode privat).
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}