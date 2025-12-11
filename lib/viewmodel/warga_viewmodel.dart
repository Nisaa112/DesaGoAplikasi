import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga;

class WargaViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Warga.Data> _listWarga = [];
  List<Warga.Data> get listWarga => _listWarga;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  
  // Mengambil data dari lokal database dan memicu sinkronisasi dari API
  Future<void> loadWarga() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Ambil data dari lokal database (untuk tampilan cepat)
      _listWarga = await _dbHelper.getAllWarga();
      _listWarga.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners(); 

      // 2. Lakukan sinkronisasi dari API
      await synchronizeWarga();

    } catch (e) {
      _errorMessage = 'Gagal memuat data Warga: $e';
      print('Error saat loadWarga: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Melakukan sinkronisasi data dari API ke database lokal
  Future<void> synchronizeWarga() async {
    try {
      final apiWarga = await ApiService.fetchWarga();

      // Hapus data lama dan masukkan data baru dari API
      await _dbHelper.clearWargaTable();
      for (var warga in apiWarga) {
        await _dbHelper.insertWarga(warga);
      }
      
      // Perbarui state lokal dengan data yang sudah disinkronisasi
      _listWarga = apiWarga;
      _listWarga.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners();
      print('✅ Sinkronisasi Warga berhasil. Total: ${_listWarga.length}');

    } catch (e) {
      print('⚠️ Gagal sinkronisasi Warga dari API: $e');
      // Tidak perlu set error message, karena ini hanyalah latar belakang sinkronisasi
      // dan data lokal sudah ditampilkan.
    }
  }

  // --- CREATE (Tambah Warga) ---

  Future<void> createWarga(Warga.Data warga) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Kirim ke API
      final newWarga = await ApiService.createWarga(warga);

      if (newWarga != null && newWarga.id != null) {
        // 2. Simpan/perbarui ke lokal database
        await _dbHelper.insertWarga(newWarga);

        // 3. Perbarui state
        _listWarga.add(newWarga);
        _listWarga.sort((a, b) => a.id!.compareTo(b.id!));
      } else {
        throw Exception("API tidak mengembalikan data warga yang valid setelah pembuatan.");
      }
    } catch (e) {
      _errorMessage = 'Gagal menambah Warga: $e';
      print('Error saat createWarga: $e');
      rethrow; // Melempar error agar bisa ditangkap oleh UI/widget
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- UPDATE (Ubah Warga) ---

  Future<void> updateWarga(Warga.Data warga) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (warga.id == null) {
        throw Exception("ID Warga harus ada untuk operasi update.");
      }

      // 1. Kirim ke API (Fungsi API tidak mengembalikan objek, hanya success/error)
      await ApiService.updateWarga(warga);

      // 2. Perbarui lokal database. Kita asumsikan data yang di-update sudah lengkap
      // Jika API mengembalikan data updated, lebih baik gunakan data itu. 
      // Karena API Anda mengembalikan 'void', kita gunakan objek input.
      await _dbHelper.updateWarga(warga);

      // 3. Perbarui state
      final index = _listWarga.indexWhere((element) => element.id == warga.id);
      if (index != -1) {
        _listWarga[index] = warga;
      }

    } catch (e) {
      _errorMessage = 'Gagal mengupdate Warga: $e';
      print('Error saat updateWarga: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- DELETE (Hapus Warga) ---

  Future<void> deleteWarga(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Kirim ke API
      await ApiService.deleteWarga(id);

      // 2. Hapus dari lokal database
      await _dbHelper.deleteWarga(id);

      // 3. Hapus dari state
      _listWarga.removeWhere((element) => element.id == id);

    } catch (e) {
      _errorMessage = 'Gagal menghapus Warga: $e';
      print('Error saat deleteWarga: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}