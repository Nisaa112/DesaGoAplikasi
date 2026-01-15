import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/jabatan_model.dart' as JabatanModel;
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/foundation.dart';

class JabatanViewModel extends ChangeNotifier {
  List<JabatanModel.Data> _jabatanList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<JabatanModel.Data> get jabatanList => _jabatanList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final dbHelper = DatabaseHelper.instance;

  Future<void> fetchJabatan() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Mengambil data dari API
      final fromApi = await ApiService.fetchJabatan(); 
      _jabatanList = fromApi;

      // Sinkronisasi ke Database Lokal
      await dbHelper.clearJabatanTable(); // Pastikan method ini ada di db_helper.dart

      for (var jabatanData in fromApi) { 
        await dbHelper.insertJabatan(jabatanData); // Pastikan method ini ada di db_helper.dart
      }
      print('✅ Data Jabatan berhasil diambil dari API dan disimpan ke DB');

    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Gagal mengambil data Jabatan dari API: $e. Mencoba memuat dari DB...');
      
      // Jika API gagal, coba muat dari database lokal
      await loadJabatanFromDb();

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadJabatanFromDb() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _jabatanList = await dbHelper.getAllJabatan(); // Pastikan method ini ada di db_helper.dart
      print('📦 Data Jabatan berhasil dimuat dari database lokal. Jumlah: ${_jabatanList.length}');
    } catch (e) {
      _errorMessage = "Gagal memuat data lokal: ${e.toString()}";
    }
    
    _isLoading = false;
    notifyListeners();
  }
}