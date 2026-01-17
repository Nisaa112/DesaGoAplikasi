import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/posyandu_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class PosyanduViewmodel extends ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  List<Data> _posyanduList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Data> get posyanduList => _posyanduList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosyandu() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Load data lokal dulu agar UI cepat muncul (Offline First)
      _posyanduList = await dbHelper.getAllPosyandu();
      notifyListeners();
      
      // Kemudian sinkronkan dengan API
      await synchronizePosyandu();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizePosyandu() async {
    try {
      final apiData = await ApiService.fetchPosyandu();
      
      // Update database lokal dengan data terbaru dari API
      for (var item in apiData) { 
        await dbHelper.insertPosyandu(item); 
      }
      
      _posyanduList = await dbHelper.getAllPosyandu();
      notifyListeners();
    } catch (e) { 
      print('Sync Posyandu Gagal: $e'); 
    }
  }

  Future<void> createPosyandu(Data data) async {
    _isLoading = true; 
    notifyListeners();
    try {
      final res = await ApiService.createPosyandu(data);
      if (res != null) {
        await dbHelper.insertPosyandu(res);
        _posyanduList.insert(0, res);
      }
    } catch (e) { 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  Future<void> updatePosyandu(Data data) async {
    _isLoading = true; 
    notifyListeners();
    try {
      await ApiService.updatePosyandu(data);
      await dbHelper.updatePosyandu(data);
      int index = _posyanduList.indexWhere((e) => e.id == data.id);
      if (index != -1) _posyanduList[index] = data;
    } catch (e) { 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  Future<void> deletePosyandu(int id) async {
    try {
      await ApiService.deletePosyandu(id);
      await dbHelper.deletePosyandu(id);
      _posyanduList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) { 
      rethrow; 
    }
  }
}