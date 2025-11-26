import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as AgendaModel;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as PosyanduModel;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as RapatModel;
import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:desa_go_aplikasi/utils/token_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ronda_model.dart' as RondaModel;

class ApiService {
  static const String baseUrl = 'https://exiguous-smilelessly-marylynn.ngrok-free.dev';

  static Future<List<WargaModel.Data>> fetchWarga() async {
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
        return dataList.map((json) => WargaModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data Warga dari API');
    }
  }

  static Future<List<StrukturModel.Data>> fetchStruktur() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/struktur'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status struktur: ${response.statusCode}');
    print('📥 Response body struktur: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList
            .map((json) => StrukturModel.Data.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data struktur dari API');
    }
  }

  static Future<List<RapatModel.Data>> fetchRapat() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/rapat'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status rapat: ${response.statusCode}');
    print('📥 Response body rapat: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList
            .map((json) => RapatModel.Data.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data rapat dari API');
    }
  }

  static Future<List<AgendaModel.Data>> fetchAgenda() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/agenda'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status agenda: ${response.statusCode}');
    print('📥 Response body agenda: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList
            .map((json) => AgendaModel.Data.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data agenda dari API');
    }
  }

  static Future<List<PosyanduModel.Data>> fetchPosyandu() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/posyandu'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status posyandu: ${response.statusCode}');
    print('📥 Response body posyandu: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList
            .map((json) => PosyanduModel.Data.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data posyandu dari API');
    }
  }

  static Future<List<RondaModel.Data>> fetchRonda() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/ronda'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status ronda: ${response.statusCode}');
    print('📥 Response body ronda: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList
            .map((json) => RondaModel.Data.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data ronda dari API');
    }
  }

  static Future<List<RondaModel.DetailRondas>> fetchRondaDetail() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/detail-ronda'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status detail ronda: ${response.statusCode}');
    print('📥 Response body detail ronda: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        
        return dataList
            .map((json) => RondaModel.DetailRondas.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data detail ronda dari API'); 
    }
  }
}