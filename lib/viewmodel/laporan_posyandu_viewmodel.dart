import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Pastikan path ini sesuai dengan struktur folder kamu
import '../models/laporan_posyandu_model.dart';

class LaporanPosyanduViewModel extends ChangeNotifier {
  List<LaporanPosyanduModel> _data = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<LaporanPosyanduModel> get data => _data;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Filter Default (Bulan & Tahun Saat Ini)
  int selectedBulan = DateTime.now().month;
  int selectedTahun = DateTime.now().year;

  // Fungsi Ambil Data dari API
  Future<void> fetchLaporan() async {
    _isLoading = true;
    _errorMessage = ''; // Reset pesan error setiap kali request baru
    notifyListeners();

    try {
      _data = await ApiService.fetchLaporanPosyandu(
        bulan: selectedBulan,
        tahun: selectedTahun,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _data = []; // Kosongkan data jika terjadi error agar UI tidak menampilkan data lama
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi Update Filter (Dipanggil dari Dropdown di UI)
  void updateFilter(int? bulan, int? tahun) {
    bool hasChanged = false;

    if (bulan != null && bulan != selectedBulan) {
      selectedBulan = bulan;
      hasChanged = true;
    }
    
    if (tahun != null && tahun != selectedTahun) {
      selectedTahun = tahun;
      hasChanged = true;
    }

    // Hanya fetch ulang jika filter benar-benar berubah untuk menghemat kuota/resource
    if (hasChanged) {
      fetchLaporan();
    }
  }
}