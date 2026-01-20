import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/ronda_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class RondaViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<RondaData> _listRonda = [];
  List<RondaData> get listRonda => _listRonda;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadRondaData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Offline first
      _listRonda = await _dbHelper.getAllRonda();
      _listRonda.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      notifyListeners();
      
      // Sinkronkan
      await synchronizeRonda();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizeRonda() async {
    try {
      final apiData = await ApiService.fetchRonda();
      
      for (var item in apiData) {
        await _dbHelper.insertRonda(item);
      }
      
      _listRonda = await _dbHelper.getAllRonda();
      _listRonda.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      notifyListeners();
    } catch (e) {
      print('Sinkronisasi ronda gagal: $e');
    }
  }

  Future<void> createRonda(Map<String, dynamic> rondaData) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Panggil ApiService dengan Map, bukan objek RondaData
      final newRonda = await ApiService.createRonda(rondaData);
      if (newRonda != null) {
        await _dbHelper.insertRonda(newRonda);
        _listRonda.insert(0, newRonda);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRonda(RondaData ronda) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedRonda = await ApiService.updateRonda(ronda);
      
      if (updatedRonda != null) {
        await _dbHelper.updateRonda(updatedRonda);
        int index = _listRonda.indexWhere((element) => element.id == updatedRonda.id);
        if (index != -1) {
          _listRonda[index] = updatedRonda;
        }
      }
    } catch (e) {
      _errorMessage = 'Gagal mengupdate: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRonda(int id) async {
    try {
      await ApiService.deleteRonda(id);
      await _dbHelper.deleteRonda(id);
      _listRonda.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}