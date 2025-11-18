import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel; 
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/foundation.dart';

class StrukturViewModel extends ChangeNotifier {
  List<StrukturModel.Data> _strukturList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<StrukturModel.Data> get strukturList => _strukturList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final dbHelper = DatabaseHelper.instance;

  Future<void> fetchStruktur() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchStruktur(); 
      _strukturList = fromApi;

      await dbHelper.clearStrukturTable();

      for (var strukturData in fromApi) { 
        await dbHelper.insertStruktur(strukturData);
      }
      print('✅ Data Struktur berhasil diambil dari API dan disimpan ke DB');

    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Gagal mengambil data Struktur dari API: $e. Mencoba memuat dari DB...');
      
      await loadStrukturFromDb();

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStrukturFromDb() async {
    _isLoading = true;
    notifyListeners();
    
    _strukturList = await dbHelper.getAllStruktur();
    print('📦 Data Struktur berhasil dimuat dari database lokal. Jumlah: ${_strukturList.length}');
    
    _isLoading = false;
    notifyListeners();
  }
}