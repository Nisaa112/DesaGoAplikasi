import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../models/laporan_keuangan_model.dart';

class LaporanKeuanganViewModel extends ChangeNotifier {
  LaporanKeuanganResponse? _data;
  bool _isLoading = false;
  String _errorMessage = '';

  LaporanKeuanganResponse? get data => _data;
  SummaryKeuangan? get summary => _data?.summary;
  List<TransaksiData> get transactions => _data?.data ?? [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  int selectedTahun = DateTime.now().year;

  Future<void> fetchLaporan() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final dynamic rawData =
          await ApiService.fetchLaporanKeuangan(selectedTahun);

      // 🔍 LOG RAW DATA
      debugPrint('📦 RAW DATA TYPE : ${rawData.runtimeType}');
      debugPrint('📦 RAW DATA VALUE: $rawData');

      if (rawData == null) {
        _data = null;
      }
      // JIKA RESPONSE LIST
      else if (rawData is List) {
        _data = LaporanKeuanganResponse(
          data: rawData
              .map((item) =>
                  TransaksiData.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      }
      // JIKA RESPONSE MAP
      else if (rawData is Map<String, dynamic>) {
        _data = LaporanKeuanganResponse.fromJson(
          rawData as Map<String, dynamic>,
        );
      } else {
        throw Exception('Format response API tidak dikenali');
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Detail Error fetchLaporan: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilter(int tahun) {
    selectedTahun = tahun;
    fetchLaporan();
  }
}
