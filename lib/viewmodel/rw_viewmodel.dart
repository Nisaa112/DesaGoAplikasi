import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;

class RwViewModel extends ChangeNotifier {
  
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<RwModel.Data> _listRw = [];
  List<RwModel.Data> get listRw => _listRw;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadRw() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listRw = await _dbHelper.getAllRw();
      _listRw.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners(); 

      await synchronizeRw();

    } catch (e) {
      _errorMessage = 'Gagal memuat data RW: $e';
      print('Error saat loadRw: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizeRw() async {
    try {
      final apiRw = await ApiService.fetchRw();

      await _dbHelper.clearRwTable();
      for (var rw in apiRw) {
        await _dbHelper.insertRw(rw); 
      }
      
      _listRw = apiRw;
      _listRw.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners();
      print('✅ Sinkronisasi RW berhasil. Total: ${_listRw.length}');

    } catch (e) {
      print('⚠️ Gagal sinkronisasi RW dari API: $e');
    }
  }
  
  Future<void> createRw(RwModel.Data rw) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newRw = await ApiService.createRw(rw);

      if (newRw != null && newRw.id != null) {
        await _dbHelper.insertRw(newRw);

        _listRw.add(newRw);
        _listRw.sort((a, b) => a.id!.compareTo(b.id!));
      } else {
        throw Exception("API tidak mengembalikan data RW yang valid setelah pembuatan.");
      }
    } catch (e) {
      _errorMessage = 'Gagal menambah RW: $e';
      print('Error saat createRw: $e');
      rethrow; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRw(RwModel.Data rw) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (rw.id == null) {
        throw Exception("ID RW harus ada untuk operasi update.");
      }

      await ApiService.updateRw(rw);

      await _dbHelper.updateRw(rw);

      final index = _listRw.indexWhere((element) => element.id == rw.id);
      if (index != -1) {
        _listRw[index] = rw;
      }

    } catch (e) {
      _errorMessage = 'Gagal mengupdate RW: $e';
      print('Error saat updateRw: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRw(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiService.deleteRw(id);

      await _dbHelper.deleteRw(id);

      _listRw.removeWhere((element) => element.id == id);

    } catch (e) {
      _errorMessage = 'Gagal menghapus RW: $e';
      print('Error saat deleteRw: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}