import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as AgendaModel;
import 'package:desa_go_aplikasi/models/jabatan_model.dart' as JabatanModel;
import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as PengaduanModel;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as PosyanduModel;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as RapatModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/models/user_model.dart';
import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/utils/token_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ronda_model.dart' as RondaModel;

class ApiService {
  static const String baseUrl = 'https://cod-active-bluejay.ngrok-free.app';

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

  //   if (result.statusCode == 422) {
  //     // Ambil body respons JSON
  //     final responseBody = jsonDecode(result.body);
      
  //     // Asumsi: Server mengembalikan array error untuk 'id_users'
  //     String errorMessage = 'Gagal validasi data.';
  //     if (responseBody.containsKey('errors') && responseBody['errors'].containsKey('id_users')) {
  //       errorMessage = responseBody['errors']['id_users'][0];
  //     }
      
  //     // Throw Exception dengan pesan yang spesifik dari server
  //     throw Exception("Error saat tambah warga: Exception: $errorMessage");
  // } else if (result.statusCode != 200) {
  //     // Penanganan error HTTP lainnya
  //     throw Exception("Gagal tambah warga. Status: ${result.statusCode}");
  // }
    
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

  static Future<List<RondaModel.RondaData>> fetchRonda() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/ronda'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      List<dynamic> dataList = decodedBody['data'];
      // Gunakan RondaData (dari model yang kita buat sebelumnya)
      return dataList.map((json) => RondaModel.RondaData.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data ronda dari server');
    }
  }

  static Future<RondaModel.RondaData?> createRonda(RondaModel.RondaData ronda) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/ronda'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(ronda.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return RondaModel.RondaData.fromJson(body['data']);
    }
    return null;
  }

  static Future<RondaModel.RondaData?> updateRonda(RondaModel.RondaData ronda) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/ronda/${ronda.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(ronda.toJson()),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return RondaModel.RondaData.fromJson(body['data']);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengupdate data ronda');
    }
  }

  static Future<void> deleteRonda(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/ronda/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus data di server');
    }
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
  
  // --------------------------------------------------------------------------
  // --- RW ---
  // --------------------------------------------------------------------------

  static Future<List<RwModel.Data>> fetchRw() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/rw'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status RW: ${response.statusCode}');
    // print('📥 Response body RW: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => RwModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data RW dari API');
    }
  }
  
  static Future<RwModel.Data?> createRw(RwModel.Data rw) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/rw'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(rw.toJson()),
      ),
      'tambah',
      'rw',
    );
    
    if (result != null) {
        return RwModel.Data.fromJson(result);
    }
    return null;
  }

  
  static Future<void> updateRw(RwModel.Data rw) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/rw/${rw.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(rw.toJson()),
      ),
      'mengupdate',
      'rw',
    );
  }

  static Future<void> deleteRw(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/rw/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'rw',
    );
  }
  
  // --------------------------------------------------------------------------
  // --- JABATAN ---
  // --------------------------------------------------------------------------

  static Future<List<JabatanModel.Data>> fetchJabatan() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/jabatan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status jabatan: ${response.statusCode}');
    // print('📥 Response body jabatan: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => JabatanModel.Data.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data jabatan dari API');
    }
  }
  
  static Future<JabatanModel.Data?> createJabatan(JabatanModel.Data jabatan) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/jabatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jabatan.toJson()),
      ),
      'tambah',
      'jabatan',
    );
    
    if (result != null) {
        return JabatanModel.Data.fromJson(result);
    }
    return null;
  }

  
  static Future<void> updateJabatan(JabatanModel.Data jabatan) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/jabatan/${jabatan.id}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(jabatan.toJson()),
      ),
      'mengupdate',
      'jabatan',
    );
  }

  static Future<void> deleteJabatan(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/jabatan/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'jabatan',
    );
  }

  // --------------------------------------------------------------------------
  // --- USER ---
  // --------------------------------------------------------------------------

  static Future<List<UserDetail>> fetchUsers() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((json) => UserDetail.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data user dari server');
    }
  }

  static Future<UserDetail?> createUser(Map<String, dynamic> data) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}"); 

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return UserDetail.fromJson(body['data']);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal membuat user baru');
    }
  }
  
  static Future<void> deleteUser(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(
        Uri.parse('$baseUrl/api/users/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ),
      'menghapus',
      'user',
    );
  }

  // --------------------------------------------------------------------------
  // --- LAPORAN RONDA ---
  // --------------------------------------------------------------------------

  static Future<List<RondaModel.RondaData>> fetchLaporanRonda({int? bulan, int? tahun}) async {
    final token = await TokenStorage.getToken();
    
    String query = '';
    if (bulan != null && tahun != null) {
      query = '?bulan=$bulan&tahun=$tahun';
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/laporan-ronda$query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      List<dynamic> dataList = decodedBody['data']; 
      return dataList.map((json) => RondaModel.RondaData.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil laporan ronda');
    }
  }

  static Future<RondaModel.RondaData> showLaporanRonda(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/laporan-ronda/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return RondaModel.RondaData.fromJson(body['data']);
    } else {
      throw Exception('Gagal memuat detail laporan');
    }
  }

  static Future<dynamic> createLaporanInsiden(int idRonda, String judul, String deskripsi) async {
    final token = await TokenStorage.getToken();
    
    final response = await http.post(
      Uri.parse('$baseUrl/api/laporan-ronda'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_ronda': idRonda,
        'judul': judul,
        'deskripsi': deskripsi,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengirim laporan');
    }
  }

  // --------------------------------------------------------------------------
  // --- LAPORAN AGENDA ---
  // --------------------------------------------------------------------------

  static Future<List<AgendaModel.Data>> fetchLaporanAgenda({int? bulan, int? tahun}) async {
    final token = await TokenStorage.getToken();
    String query = '';
    if (bulan != null && tahun != null) query = '?bulan=$bulan&tahun=$tahun';

    final response = await http.get(
      Uri.parse('$baseUrl/api/laporan-agenda$query'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      return data.map((json) => AgendaModel.Data.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil laporan agenda');
    }
  }

  static Future<void> createLaporanAgenda(int idAgenda, String deskripsi, int jumlahHadir) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/laporan-agenda'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_agenda': idAgenda,
        'deskripsi_hasil': deskripsi,
        'jumlah_hadir': jumlahHadir,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menyimpan laporan agenda');
    }
  }

  // --------------------------------------------------------------------------
  // --- LAPORAN POSYANDU ---
  // --------------------------------------------------------------------------

  static Future<List<PosyanduModel.Data>> fetchLaporanPosyandu({int? bulan, int? tahun}) async {
    final token = await TokenStorage.getToken();
    String query = '';
    if (bulan != null && tahun != null) query = '?bulan=$bulan&tahun=$tahun';

    final response = await http.get(
      Uri.parse('$baseUrl/api/laporan-posyandu$query'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      return data.map((json) => PosyanduModel.Data.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil laporan posyandu');
    }
  }

  static Future<void> createLaporanPosyandu(int idPosyandu, String deskripsi, int balita, int ibuHamil, int lansia) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/laporan-posyandu'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_posyandu': idPosyandu,
        'deskripsi_kegiatan': deskripsi,
        'jumlah_balita': balita,
        'jumlah_ibu_hamil': ibuHamil,
        'jumlah_lansia': lansia,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menyimpan laporan posyandu');
    }
  }

  // --------------------------------------------------------------------------
  // --- LAPORAN RAPAT ---
  // --------------------------------------------------------------------------

  static Future<List<RapatModel.Data>> fetchLaporanRapat({int? bulan, int? tahun}) async {
    final token = await TokenStorage.getToken();
    String query = '';
    if (bulan != null && tahun != null) query = '?bulan=$bulan&tahun=$tahun';

    final response = await http.get(
      Uri.parse('$baseUrl/api/laporan-rapat$query'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      return data.map((json) => RapatModel.Data.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil laporan rapat');
    }
  }

  static Future<void> createLaporanRapat(int idRapat, String hasil, int jumlahHadir) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/laporan-rapat'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_rapat': idRapat,
        'hasil_keputusan': hasil,
        'jumlah_hadir': jumlahHadir,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menyimpan laporan rapat');
    }
  }

  // --------------------------------------------------------------------------
  // --- KEUANGAN (KAS & TRANSAKSI) ---
  // --------------------------------------------------------------------------

  static Future<List<dynamic>> fetchKas() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/kas'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'];
    } else {
      throw Exception('Gagal mengambil data kas');
    }
  }

  static Future<Map<String, dynamic>> showKas(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/kas/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'];
    } else {
      throw Exception('Gagal mengambil detail kas');
    }
  }

  static Future<void> createTransaksi(int kasId, String tanggal, String jenis, int jumlah, String keterangan) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/kas/transaksi'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'kas_id': kasId,
        'tanggal': tanggal,
        'jenis': jenis,
        'jumlah': jumlah,
        'keterangan': keterangan,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menyimpan transaksi');
    }
  }

  // --------------------------------------------------------------------------
  // --- LAPORAN KEUANGAN (REKAP) ---
  // --------------------------------------------------------------------------

  static Future<Map<String, dynamic>> fetchLaporanKeuangan(int tahun) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/laporan-keuangan?tahun=$tahun'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil laporan keuangan');
    }
  }
}
