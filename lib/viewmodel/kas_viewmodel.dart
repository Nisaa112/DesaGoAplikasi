import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel;

class KasViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<KasModel.Data> _listKas = [];
  List<KasModel.Data> get listKas => _listKas;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadKas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _listKas = await _dbHelper.getAllKas();
      notifyListeners();
      await synchronizeKas();
    } catch (e) {
      _errorMessage = 'Gagal memuat data Kas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizeKas() async {
    try {
      final List<dynamic> apiKasRaw = await ApiService.fetchKas();
      
      // Mapping dari List<dynamic> ke List<KasModel.Data>
      final List<KasModel.Data> apiKas = apiKasRaw.map((e) => KasModel.Data.fromJson(e)).toList();
      
      await _dbHelper.clearKasTable();
      for (var item in apiKas) { 
        await _dbHelper.insertKas(item); 
      }
      
      _listKas = apiKas;
      notifyListeners();
    } catch (e) {
      print('DEBUG ERROR synchronizeKas: $e');
    }
  }

  Future<void> createKas(KasModel.Data data) async {
    _isLoading = true; 
    notifyListeners();
    try {
      // Kirim dalam bentuk JSON (Map)
      final Map<String, dynamic> responseData = await ApiService.createKas(data.toJson());
      
      // Konversi hasil API kembali ke Object
      final newData = KasModel.Data.fromJson(responseData);
      
      await _dbHelper.insertKas(newData);
      _listKas.add(newData);
    } catch (e) { 
      _errorMessage = e.toString(); 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  Future<void> updateKas(KasModel.Data data) async {
    _isLoading = true; 
    notifyListeners();
    try {
      await ApiService.updateKas(data.toJson());
      await _dbHelper.updateKas(data);
      final index = _listKas.indexWhere((e) => e.id == data.id);
      if (index != -1) { _listKas[index] = data; }
    } catch (e) { 
      _errorMessage = e.toString(); 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  Future<void> deleteKas(int id) async {
    _isLoading = true; 
    notifyListeners();
    try {
      await ApiService.deleteKas(id);
      await _dbHelper.deleteKas(id);
      _listKas.removeWhere((e) => e.id == id);
    } catch (e) { 
      _errorMessage = e.toString(); 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }
}