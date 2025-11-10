// lib/viewmodels/warga_viewmodel.dart

import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/warga_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/foundation.dart';

class WargaViewmodel extends ChangeNotifier {
  // [DIPERBAIKI] Tipe list diubah menjadi List<Data>
  List<Data> _wargaList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // [DIPERBAIKI] Getter diubah nama dan tipenya
  List<Data> get wargaList => _wargaList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final dbHelper = DatabaseHelper.instance;

  Future<void> fetchWarga() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // 1. Ambil data dari API
      final fromApi = await ApiService.fetchWarga();
      _wargaList = fromApi;

      // 2. Bersihkan tabel lokal
      await dbHelper.clearWargaTable();

      // 3. Simpan data baru ke tabel lokal
      for (var wargaData in fromApi) {
        await dbHelper.insertWarga(wargaData);
      }
      print('✅ Data Warga berhasil diambil dari API dan disimpan ke DB');

    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Gagal mengambil data dari API: $e. Mencoba memuat dari DB...');
      
      // 4. Jika API gagal, coba muat dari database sebagai fallback
      await loadWargaFromDb();

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk memuat data dari database lokal
  Future<void> loadWargaFromDb() async {
    _isLoading = true;
    notifyListeners();
    
    _wargaList = await dbHelper.getAllWarga();
    print('📦 Data Warga berhasil dimuat dari database lokal. Jumlah: ${_wargaList.length}');
    
    _isLoading = false;
    notifyListeners();
  }
}