// lib/service/api_service.dart

import 'dart:convert';
import 'package:desa_go_aplikasi/models/warga_model.dart'; 
import 'package:desa_go_aplikasi/utils/token_storage.dart'; 
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://thaddeus-blastomycotic-margy.ngrok-free.dev';

  static Future<List<Data>> fetchWarga() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/warga'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status Warga: ${response.statusCode}');
    print('📥 Response body Warga: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      
      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => Data.fromJson(json)).toList();
      } else {
        // Jika data tidak ditemukan atau bukan list, kembalikan list kosong
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data Warga dari API');
    }
  }
}