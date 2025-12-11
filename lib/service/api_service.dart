import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as AgendaModel;
import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as PengaduanModel;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as PosyanduModel;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as RapatModel;
import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/utils/token_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ronda_model.dart' as RondaModel;

class ApiService {
  static const String baseUrl = 'https://exiguous-smilelessly-marylynn.ngrok-free.dev';

  static Future<dynamic> _handleApiRequest(
    Future<http.Response> request, String operationType, String endpoint
  ) async {
    try {
      final response = await request;
      print("📤 Response Body $endpoint: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return null; 
        
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return decoded['data'];
        } else if (response.statusCode == 200) {
            
            return null;
        } else {
          throw Exception('Respons API tidak valid: data tidak ditemukan');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Data $endpoint tidak ditemukan');
      } else {
        print("❌ Gagal $operationType $endpoint, code: ${response.statusCode}");
        throw Exception('Gagal $operationType $endpoint. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat $operationType $endpoint: $e');
    }
  }
  
  // --------------------------------------------------------------------------
  // --- WARGA ---
  // --------------------------------------------------------------------------

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
    // print('📥 Response body Warga: ${response.body}');

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
  
  static Future<WargaModel.Data?> createWarga(WargaModel.Data warga) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/warga'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(warga.toJson()),
      ),
      'tambah',
      'warga',
    );
    
    if (result != null) {
        return WargaModel.Data.fromJson(result);
    }
    return null;
  }

  
  static Future<void> updateWarga(WargaModel.Data warga) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/warga/${warga.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(warga.toJson()),
      ),
      'mengupdate',
      'warga',
    );
  }

  static Future<void> deleteWarga(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/warga/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'warga',
    );
  }

  // --------------------------------------------------------------------------
  // --- STRUKTUR ---
  // --------------------------------------------------------------------------

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

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => StrukturModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data struktur dari API');
    }
  }
 
  static Future<StrukturModel.Data?> createStruktur(StrukturModel.Data struktur) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/struktur'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(struktur.toJson()),
      ),
      'tambah',
      'struktur',
    );

    if (result != null) {
      return StrukturModel.Data.fromJson(result);
    }
    return null;
  }

  
  static Future<void> updateStruktur(StrukturModel.Data struktur) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/struktur/${struktur.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(struktur.toJson()),
      ),
      'mengupdate',
      'struktur',
    );
  }

  static Future<void> deleteStruktur(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/struktur/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'struktur',
    );
  }

  // --------------------------------------------------------------------------
  // --- RAPAT ---
  // --------------------------------------------------------------------------

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

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => RapatModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data rapat dari API');
    }
  }
    
  static Future<RapatModel.Data?> createRapat(RapatModel.Data rapat) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/rapat'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(rapat.toJson()),
      ),
      'tambah',
      'rapat',
    );

    if (result != null) {
      return RapatModel.Data.fromJson(result);
    }
    return null;
  }

  static Future<void> updateRapat(RapatModel.Data rapat) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/rapat/${rapat.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(rapat.toJson()),
      ),
      'mengupdate',
      'rapat',
    );
  }

  static Future<void> deleteRapat(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/rapat/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'rapat',
    );
  }

  // --------------------------------------------------------------------------
  // --- AGENDA ---
  // --------------------------------------------------------------------------

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

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => AgendaModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data agenda dari API');
    }
  }

  static Future<AgendaModel.Data?> createAgenda(AgendaModel.Data agenda) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/agenda'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(agenda.toJson()),
      ),
      'tambah',
      'agenda',
    );

    if (result != null) {
      return AgendaModel.Data.fromJson(result);
    }
    return null;
  }

  static Future<void> updateAgenda(AgendaModel.Data agenda) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/agenda/${agenda.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(agenda.toJson()),
      ),
      'mengupdate',
      'agenda',
    );
  }

  static Future<void> deleteAgenda(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/agenda/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'agenda',
    );
  }

  // --------------------------------------------------------------------------
  // --- POSYANDU ---
  // --------------------------------------------------------------------------

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

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => PosyanduModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data posyandu dari API');
    }
  }

  static Future<PosyanduModel.Data?> createPosyandu(PosyanduModel.Data posyandu) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/posyandu'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(posyandu.toJson()),
      ),
      'tambah',
      'posyandu',
    );

    if (result != null) {
      return PosyanduModel.Data.fromJson(result);
    }
    return null;
  }

  static Future<void> updatePosyandu(PosyanduModel.Data posyandu) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/posyandu/${posyandu.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(posyandu.toJson()),
      ),
      'mengupdate',
      'posyandu',
    );
  }

  static Future<void> deletePosyandu(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/posyandu/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'posyandu',
    );
  }

  // --------------------------------------------------------------------------
  // --- RONDA ---
  // --------------------------------------------------------------------------

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

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => RondaModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data ronda dari API');
    }
  }
    
  static Future<RondaModel.Data?> createRonda(RondaModel.Data ronda) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/ronda'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(ronda.toJson()),
      ),
      'tambah',
      'ronda',
    );

    if (result != null) {
      return RondaModel.Data.fromJson(result);
    }
    return null;
  }

  static Future<void> updateRonda(RondaModel.Data ronda) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/ronda/${ronda.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(ronda.toJson()),
      ),
      'mengupdate',
      'ronda',
    );
  }

  static Future<void> deleteRonda(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/ronda/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'ronda',
    );
  }

  // --------------------------------------------------------------------------
  // --- DETAIL RONDA ---
  // --------------------------------------------------------------------------

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

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        
        return dataList.map((json) => RondaModel.DetailRondas.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data detail ronda dari API'); 
    }
  }
    
  static Future<RondaModel.DetailRondas?> createRondaDetail(RondaModel.DetailRondas detailRonda) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/detail-ronda'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(detailRonda.toJson()),
      ),
      'tambah',
      'detail ronda',
    );

    if (result != null) {
      return RondaModel.DetailRondas.fromJson(result);
    }
    return null;
  }

  static Future<void> updateRondaDetail(RondaModel.DetailRondas detailRonda) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/detail-ronda/${detailRonda.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(detailRonda.toJson()),
      ),
      'mengupdate',
      'detail ronda',
    );
  }

  static Future<void> deleteRondaDetail(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/detail-ronda/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'detail ronda',
    );
  }

  // --------------------------------------------------------------------------
  // --- PENGADUAN ---
  // --------------------------------------------------------------------------

  static Future<List<PengaduanModel.Data>> fetchPengaduan() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/komentar-masukan'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status Pengaduan: ${response.statusCode}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        
        return dataList.map((json) => PengaduanModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data Pengaduan dari API'); 
    }
  }
  
  static Future<PengaduanModel.Data?> createPengaduan(PengaduanModel.Data pengaduan) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/komentar-masukan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(pengaduan.toJson()),
      ),
      'tambah',
      'pengaduan',
    );

    if (result != null) {
      return PengaduanModel.Data.fromJson(result);
    }
    return null;
  }

  
  static Future<void> updatePengaduan(PengaduanModel.Data pengaduan) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/komentar-masukan/${pengaduan.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(pengaduan.toJson()),
      ),
      'mengupdate',
      'pengaduan',
    );
  }

  static Future<void> deletePengaduan(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/komentar-masukan/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'pengaduan',
    );
  }
  
  // --------------------------------------------------------------------------
  // --- RT ---
  // --------------------------------------------------------------------------

  static Future<List<RtModel.Data>> fetchRt() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/rt'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status RT: ${response.statusCode}');
    // print('📥 Response body RT: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => RtModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data RT dari API');
    }
  }
  
  static Future<RtModel.Data?> createRt(RtModel.Data rt) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/rt'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(rt.toJson()),
      ),
      'tambah',
      'rt',
    );
    
    if (result != null) {
        return RtModel.Data.fromJson(result);
    }
    return null;
  }

  
  static Future<void> updateRt(RtModel.Data rt) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/rt/${rt.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(rt.toJson()),
      ),
      'mengupdate',
      'rt',
    );
  }

  static Future<void> deleteRt(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/rt/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'rt',
    );
  }

}