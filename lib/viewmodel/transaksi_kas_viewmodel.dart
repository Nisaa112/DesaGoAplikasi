import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/transaksi_model.dart' as TransaksiModel;

class TransaksiViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<TransaksiModel.Data> _listTransaksi = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _filterStatus = 'semua';

  List<TransaksiModel.Data> get listTransaksi => _listTransaksi;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get filterStatus => _filterStatus;

  List<TransaksiModel.Data> get filteredTransaksi {
    if (_filterStatus == 'masuk') {
      return _listTransaksi.where((t) => t.jenis == 'masuk').toList();
    } else if (_filterStatus == 'keluar') {
      return _listTransaksi.where((t) => t.jenis == 'keluar').toList();
    }
    return _listTransaksi;
  }

  void toggleFilter() {
    if (_filterStatus == 'semua') {
      _filterStatus = 'masuk';
    } else if (_filterStatus == 'masuk') {
      _filterStatus = 'keluar';
    } else {
      _filterStatus = 'semua';
    }
    notifyListeners();
  }

  Future<void> loadTransaksi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _listTransaksi = await _dbHelper.getAllTransaksi();
      notifyListeners();
      await synchronizeTransaksi();
    } catch (e) {
      _errorMessage = 'Gagal memuat data Transaksi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizeTransaksi() async {
    try {
      final List<dynamic> apiTrxRaw = await ApiService.fetchTransaksi();
      
      // Mapping dari List<dynamic> ke List<TransaksiModel.Data>
      final List<TransaksiModel.Data> apiTrx = apiTrxRaw.map((e) => TransaksiModel.Data.fromJson(e)).toList();
      
      await _dbHelper.clearTransaksiTable();
      for (var item in apiTrx) { 
        await _dbHelper.insertTransaksi(item); 
      }
      
      _listTransaksi = apiTrx;
      notifyListeners();
    } catch (e) {
      print('⚠️ Sinkronisasi Transaksi Gagal: $e');
    }
  }

  Future<void> createTransaksi(TransaksiModel.Data data) async {
    _isLoading = true; 
    notifyListeners();
    try {
      final Map<String, dynamic> responseData = await ApiService.createTransaksi(data.toJson());
      
      final newData = TransaksiModel.Data.fromJson(responseData);
      
      await _dbHelper.insertTransaksi(newData);
      _listTransaksi.add(newData);
    } catch (e) { 
      _errorMessage = e.toString(); 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  Future<void> updateTransaksi(TransaksiModel.Data data) async {
    _isLoading = true; 
    notifyListeners();
    try {
      await ApiService.updateTransaksi(data.toJson());
      await _dbHelper.updateTransaksi(data);
      final index = _listTransaksi.indexWhere((e) => e.id == data.id);
      if (index != -1) { _listTransaksi[index] = data; }
    } catch (e) { 
      _errorMessage = e.toString(); 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  Future<void> deleteTransaksi(int id) async {
    _isLoading = true; 
    notifyListeners();
    try {
      await ApiService.deleteTransaksi(id);
      await _dbHelper.deleteTransaksi(id);
      _listTransaksi.removeWhere((e) => e.id == id);
    } catch (e) { 
      _errorMessage = e.toString(); 
      rethrow; 
    } finally { 
      _isLoading = false; 
      notifyListeners(); 
    }
  }
}