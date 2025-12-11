import 'dart:convert';
import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;

class RtViewModel extends ChangeNotifier {
  
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<RtModel.Data> _listRt = [];
  List<RtModel.Data> get listRt => _listRt;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadRt() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listRt = await _dbHelper.getAllRt();
      _listRt.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners(); 

      await synchronizeRt();

    } catch (e) {
      _errorMessage = 'Gagal memuat data RT: $e';
      print('Error saat loadRt: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizeRt() async {
    try {
      final apiRt = await ApiService.fetchRt();

      await _dbHelper.clearRtTable();
      for (var rt in apiRt) {
        await _dbHelper.insertRt(rt);
      }
      
      _listRt = apiRt;
      _listRt.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners();
      print('✅ Sinkronisasi RT berhasil. Total: ${_listRt.length}');

    } catch (e) {
      print('⚠️ Gagal sinkronisasi RT dari API: $e');
    }
  }
  
  Future<void> createRt(RtModel.Data rt) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newRt = await ApiService.createRt(rt);

      if (newRt != null && newRt.id != null) {
        await _dbHelper.insertRt(newRt);

        _listRt.add(newRt);
        _listRt.sort((a, b) => a.id!.compareTo(b.id!));
      } else {
        throw Exception("API tidak mengembalikan data RT yang valid setelah pembuatan.");
      }
    } catch (e) {
      _errorMessage = 'Gagal menambah RT: $e';
      print('Error saat createRt: $e');
      rethrow; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRt(RtModel.Data rt) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (rt.id == null) {
        throw Exception("ID RT harus ada untuk operasi update.");
      }

      await ApiService.updateRt(rt);

      await _dbHelper.updateRt(rt);

      final index = _listRt.indexWhere((element) => element.id == rt.id);
      if (index != -1) {
        _listRt[index] = rt;
      }

    } catch (e) {
      _errorMessage = 'Gagal mengupdate RT: $e';
      print('Error saat updateRt: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRt(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiService.deleteRt(id);

      await _dbHelper.deleteRt(id);

      _listRt.removeWhere((element) => element.id == id);

    } catch (e) {
      _errorMessage = 'Gagal menghapus RT: $e';
      print('Error saat deleteRt: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}