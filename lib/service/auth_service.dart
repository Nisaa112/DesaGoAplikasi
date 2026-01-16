import 'dart:convert';
import 'package:desa_go_aplikasi/models/login_model.dart';
import 'package:desa_go_aplikasi/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://cod-active-bluejay.ngrok-free.app/api';
  static const String _tokenKey = 'auth_token'; 

  Future<bool> verifyToken(String token) async {
    final url = Uri.parse('$_baseUrl/auth/profile'); 
    
    try {
        final response = await http.get(
            url,
            headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
            },
        ).timeout(const Duration(seconds: 15));

        print('DEBUG VERIFY Status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
            return true; 
        }

        if (response.statusCode == 401) {
            return false;
        }

        return false;
    } catch (e) {
        print('❌ Error saat verifikasi token: $e');
        return false;
    }
  }

  // Ubah Return Type menjadi Future<UserModel>
  Future<UserModel> login(String serial, String password) async { 
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

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Gunakan UserModel saja
        return UserModel.fromJson(responseBody);
      } else {
        throw Exception(responseBody['message'] ?? 'Gagal login');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
      } catch (e) {
        print('Warning: Gagal memanggil API logout ke server.');
      }
    }
    // Hapus semua data lokal
    await prefs.clear();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}