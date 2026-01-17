import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/rapat_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class RapatViewmodel extends ChangeNotifier {
  List<Data> _rapatList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Data> get rapatList => _rapatList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final dbHelper = DatabaseHelper.instance;
  
  Future<void> fetchRapat() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchRapat();
      
      // Update DB lokal
      for (var rapatData in fromApi) {
        await dbHelper.insertRapat(rapatData);
      }
      
      _rapatList = fromApi;
      print('✅ Data rapat berhasil disinkronkan');

    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Gagal API Rapat: $e. Memuat data offline...');
      _rapatList = await dbHelper.getAllRapat();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRapatFromDb() async {
    _isLoading = true;
    notifyListeners();
    _rapatList = await dbHelper.getAllRapat();
    _isLoading = false;
    notifyListeners();
  }
}