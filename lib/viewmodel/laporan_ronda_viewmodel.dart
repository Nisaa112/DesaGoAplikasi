import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import '../models/laporan_ronda_model.dart';

class LaporanRondaViewModel extends ChangeNotifier {
  List<LaporanRondaModel> _data = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<LaporanRondaModel> get data => _data;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Filter Default
  int selectedBulan = DateTime.now().month;
  int selectedTahun = DateTime.now().year;

  // Fungsi Ambil Data
  Future<void> fetchLaporan() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI untuk menampilkan loading

    try {
      _data = await ApiService.fetchLaporanRonda(
        bulan: selectedBulan,
        tahun: selectedTahun,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _data = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI data sudah siap
    }
  }

  // Fungsi Ganti Filter
  void updateFilter(int? bulan, int? tahun) {
    if (bulan != null) selectedBulan = bulan;
    if (tahun != null) selectedTahun = tahun;
    fetchLaporan(); // Otomatis refresh data
  }
}