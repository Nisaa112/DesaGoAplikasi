import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as AgendaModel;
import 'package:desa_go_aplikasi/models/jabatan_model.dart' as JabatanModel;
import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel show Data;
import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as PengaduanModel;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as PosyanduModel;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as RapatModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/models/transaksi_model.dart' as TransaksiModel show Data;
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

  static Future<RapatModel.Data?> updateRapat(RapatModel.Data rapat) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/rapat/${rapat.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(rapat.toJson()),
      );

      print('📤 Response update rapat: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        // Cek null safety agar tidak error Map <String, dynamic>
        if (decodedBody['data'] != null) {
          return RapatModel.Data.fromJson(decodedBody['data']);
        } else {
          return rapat;
        }
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Gagal mengupdate rapat';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ Error updateRapat: $e');
      rethrow;
    }
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

  static Future<AgendaModel.Data?> updateAgenda(AgendaModel.Data agenda) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/agenda/${agenda.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(agenda.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        if (decodedBody['data'] != null) {
          return AgendaModel.Data.fromJson(decodedBody['data']);
        } else {
          return agenda; 
        }
      } else {
        throw Exception('Gagal update agenda');
      }
    } catch (e) {
      rethrow;
    }
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

  static Future<PosyanduModel.Data?> updatePosyandu(PosyanduModel.Data posyandu) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/posyandu/${posyandu.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(posyandu.toJson()),
      );

      print('📤 Response update posyandu: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        if (decodedBody['data'] != null) {
          return PosyanduModel.Data.fromJson(decodedBody['data']);
        } else {
          return posyandu; 
        }
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Gagal mengupdate posyandu';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ Error updatePosyandu: $e');
      rethrow;
    }
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
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ronda'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('📥 Response status ronda: ${response.statusCode}');

      if (response.statusCode == 200) {
        print("RAW JSON: ${response.body}");
        Map<String, dynamic> decodedBody = jsonDecode(response.body);
        
        // Pastikan mengambil dari key 'data'
        if (decodedBody['data'] != null && decodedBody['data'] is List) {
          List<dynamic> dataList = decodedBody['data'];
          return dataList.map((json) => RondaModel.RondaData.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Server mengembalikan error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetchRonda: $e');
      rethrow; 
    }
  }

  static Future<RondaModel.RondaData?> createRonda(Map<String, dynamic> rondaPayload) async {
    final token = await TokenStorage.getToken();
    try {
      // Tambahkan print ini untuk memastikan payload yang dikirim sudah benar
      print('📤 Payload create ronda: ${jsonEncode(rondaPayload)}');

      final response = await http.post(
        Uri.parse('$baseUrl/api/ronda'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // LANGSUNG GUNAKAN PAYLOAD MAP YANG SUDAH BERSIH
        body: jsonEncode(rondaPayload),
      );

      print('📥 Response create ronda: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        // Pastikan mengambil objek dari key 'data'
        if (decodedBody.containsKey('data')) {
          return RondaModel.RondaData.fromJson(decodedBody['data']);
        } else {
          // Jika server tidak mengembalikan 'data', coba parse langsung
          return RondaModel.RondaData.fromJson(decodedBody);
        }
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Gagal menambah data ronda';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ Error createRonda: $e');
      rethrow;
    }
  }

  static Future<RondaModel.RondaData?> updateRonda(RondaModel.RondaData ronda) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/ronda/${ronda.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(ronda.toJson()),
      );

      print('📤 Response update ronda: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
          if (decodedBody['data'] != null) {
          return RondaModel.RondaData.fromJson(decodedBody['data']);
        } else {
          return ronda; 
        }
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Gagal mengupdate data ronda';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ Error updateRonda: $e');
      rethrow;
    }
  }

  static Future<void> deleteRonda(int id) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/ronda/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🗑️ Response delete ronda: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus data di server. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleteRonda: $e');
      rethrow;
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
  // --- KAS ---
  // --------------------------------------------------------------------------

  static Future<List<KasModel.Data>> fetchKas() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/kas'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => KasModel.Data.fromJson(json)).toList();
      }
      return [];
    } else {
      throw Exception('Gagal mengambil data Kas dari API');
    }
  }

  static Future<KasModel.Data?> createKas(KasModel.Data kas) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/kas'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(kas.toJson()),
      ),
      'tambah', 'kas',
    );
    return result != null ? KasModel.Data.fromJson(result) : null;
  }

  static Future<void> updateKas(KasModel.Data kas) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/kas/${kas.id}'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(kas.toJson()),
      ),
      'mengupdate', 'kas',
    );
  }

  static Future<void> deleteKas(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(Uri.parse('$baseUrl/api/kas/$id'), headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
      'menghapus', 'kas',
    );
  }

  // --------------------------------------------------------------------------
  // --- TRANSAKSI ---
  // --------------------------------------------------------------------------

  static Future<List<TransaksiModel.Data>> fetchTransaksi() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/kas/transaksi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      if (decodedBody['data'] is List) {
        List<dynamic> dataList = decodedBody['data'];
        return dataList.map((json) => TransaksiModel.Data.fromJson(json)).toList();
      }
      return [];
    } else {
      throw Exception('Gagal mengambil data Transaksi dari API');
    }
  }

  static Future<TransaksiModel.Data?> createTransaksi(TransaksiModel.Data trx) async {
    final token = await TokenStorage.getToken();
    final result = await _handleApiRequest(
      http.post(
        Uri.parse('$baseUrl/api/kas/transaksi'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(trx.toJson()),
      ),
      'tambah', 'transaksi',
    );
    return result != null ? TransaksiModel.Data.fromJson(result) : null;
  }

  static Future<void> updateTransaksi(TransaksiModel.Data trx) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.put(
        Uri.parse('$baseUrl/api/kas/transaksi/${trx.id}'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(trx.toJson()),
      ),
      'mengupdate', 'transaksi',
    );
  }

  static Future<void> deleteTransaksi(int id) async {
    final token = await TokenStorage.getToken();
    await _handleApiRequest(
      http.delete(Uri.parse('$baseUrl/api/kas/transaksi/$id'), headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
      'menghapus', 'transaksi',
    );
  }
}