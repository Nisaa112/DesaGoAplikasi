import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/posyandu_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class PosyanduViewmodel extends ChangeNotifier {
  List<Data> _posyanduList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Data> get posyanduList => _posyanduList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final dbHelper =  DatabaseHelper.instance;
  
  Future<void> fetchPosyandu() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
    final fromApi = await ApiService.fetchPosyandu();
    _posyanduList = fromApi;

    await dbHelper.clearPosyanduTable();

    for (var posyanduData in fromApi) {
      await dbHelper.insertPosyandu(posyanduData);
    }
    print('✅ Data Posyandu berhasil diambil dari API dan disimpan ke DB');

    } catch (e) {
    _errorMessage = e.toString();
    print('❌ Gagal mengambil data dari API: $e. Mencoba memuat dari DB...');
    
    await loadPosyanduFromDb();

    } finally {
    _isLoading = false;
    notifyListeners();
    }
  }

  Future<void> loadPosyanduFromDb() async {
    _isLoading = true;
    notifyListeners();
    
    _posyanduList = await dbHelper.getAllPosyandu();
    print('📦 Data Posyandu berhasil dimuat dari database lokal. Jumlah: ${_posyanduList.length}');
    
    _isLoading = false;
    notifyListeners();
  }
}