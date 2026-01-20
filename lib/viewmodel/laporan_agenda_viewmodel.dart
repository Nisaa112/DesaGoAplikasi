import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Pastikan path ini benar (service tanpa s)
import '../models/laporan_agenda_model.dart';

class LaporanAgendaViewModel extends ChangeNotifier {
  List<LaporanAgendaModel> _data = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<LaporanAgendaModel> get data => _data;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Default Filter (Bulan & Tahun Saat Ini)
  int selectedBulan = DateTime.now().month;
  int selectedTahun = DateTime.now().year;

  // Fungsi Ambil Data dari API
  Future<void> fetchLaporan() async {
    _isLoading = true;
    _errorMessage = ''; // Reset error sebelum memanggil API
    notifyListeners();

    try {
      _data = await ApiService.fetchLaporanAgenda(
        bulan: selectedBulan,
        tahun: selectedTahun,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _data = []; // Kosongkan data jika terjadi error
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

    // Hanya fetch ulang jika filter benar-benar berubah
    if (hasChanged) {
      fetchLaporan();
    }
  }
}