import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/foundation.dart';

class StrukturViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<StrukturModel.Data> _strukturList = [];
  List<StrukturModel.Data> get strukturList => _strukturList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- READ (Load Data) ---
  
  // Mengambil data dari lokal database dan memicu sinkronisasi dari API
  // Mengikuti pola WargaViewModel: Load Lokal -> Sync API
  Future<void> loadStruktur() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Ambil data dari lokal database (untuk tampilan cepat/offline)
      _strukturList = await _dbHelper.getAllStruktur();
      // Opsional: Urutkan jika perlu (misal berdasarkan jabatan atau id)
      _strukturList.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      notifyListeners();

      // 2. Lakukan sinkronisasi dari API secara otomatis
      await synchronizeStruktur();

    } catch (e) {
      _errorMessage = 'Gagal memuat data Struktur: $e';
      print('❌ Error saat loadStruktur: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Melakukan sinkronisasi data dari API ke database lokal
  Future<void> synchronizeStruktur() async {
    try {
      final apiStruktur = await ApiService.fetchStruktur();

      // Hapus data lama dan masukkan data baru dari API (Single Source of Truth)
      await _dbHelper.clearStrukturTable();
      for (var struktur in apiStruktur) {
        await _dbHelper.insertStruktur(struktur);
      }

      // Perbarui state lokal dengan data yang sudah disinkronisasi
      _strukturList = apiStruktur;
      _strukturList.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      
      notifyListeners();
      print('✅ Sinkronisasi Struktur berhasil. Total: ${_strukturList.length}');

    } catch (e) {
      print('⚠️ Gagal sinkronisasi Struktur dari API: $e');
      // Tidak menyetel errorMessage di sini agar data lokal yang sudah tampil tidak tertutup error
    }
  }

  // --- CREATE (Tambah Struktur) ---

  Future<void> createStruktur(StrukturModel.Data struktur) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Kirim ke API
      final newStruktur = await ApiService.createStruktur(struktur);

      if (newStruktur != null && newStruktur.id != null) {
        // 2. Simpan ke lokal database
        await _dbHelper.insertStruktur(newStruktur);

        // 3. Perbarui state list
        _strukturList.add(newStruktur);
        _strukturList.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      } else {
        throw Exception("API tidak mengembalikan data struktur yang valid.");
      }
    } catch (e) {
      _errorMessage = 'Gagal menambah Struktur: $e';
      print('❌ Error saat createStruktur: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- UPDATE (Ubah Struktur) ---

  Future<void> updateStruktur(StrukturModel.Data struktur) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (struktur.id == null) {
        throw Exception("ID Struktur diperlukan untuk pembaruan.");
      }

      // 1. Kirim ke API
      await ApiService.updateStruktur(struktur);

      // 2. Perbarui lokal database
      await _dbHelper.updateStruktur(struktur);

      // 3. Perbarui state list di memori
      final index = _strukturList.indexWhere((element) => element.id == struktur.id);
      if (index != -1) {
        _strukturList[index] = struktur;
      }
    } catch (e) {
      _errorMessage = 'Gagal mengupdate Struktur: $e';
      print('❌ Error saat updateStruktur: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- DELETE (Hapus Struktur) ---

  Future<void> deleteStruktur(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Kirim ke API
      await ApiService.deleteStruktur(id);

      // 2. Hapus dari lokal database
      await _dbHelper.deleteStruktur(id);

      // 3. Hapus dari state memori
      _strukturList.removeWhere((element) => element.id == id);
    } catch (e) {
      _errorMessage = 'Gagal menghapus Struktur: $e';
      print('❌ Error saat deleteStruktur: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}