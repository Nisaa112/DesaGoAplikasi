import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/transaksi_model.dart' as TransaksiModel;

class TransaksiViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<TransaksiModel.Data> _listTransaksi = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // State untuk filter: 'semua', 'masuk', atau 'keluar'
  String _filterStatus = 'semua';

  List<TransaksiModel.Data> get listTransaksi => _listTransaksi;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get filterStatus => _filterStatus;

  // Getter untuk mendapatkan data yang sudah difilter
  List<TransaksiModel.Data> get filteredTransaksi {
    if (_filterStatus == 'masuk') {
      return _listTransaksi.where((t) => t.jenis == 'masuk').toList();
    } else if (_filterStatus == 'keluar') {
      return _listTransaksi.where((t) => t.jenis == 'keluar').toList();
    }
    return _listTransaksi; // Default: semua
  }

  // Fungsi untuk mengganti filter (Toggle)
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
      final apiTrx = await ApiService.fetchTransaksi();
      await _dbHelper.clearTransaksiTable();
      for (var item in apiTrx) { await _dbHelper.insertTransaksi(item); }
      _listTransaksi = apiTrx;
      notifyListeners();
    } catch (e) {
      print('⚠️ Sinkronisasi Transaksi Gagal: $e');
    }
  }

  Future<void> createTransaksi(TransaksiModel.Data data) async {
    _isLoading = true; notifyListeners();
    try {
      final newData = await ApiService.createTransaksi(data);
      if (newData != null) {
        await _dbHelper.insertTransaksi(newData);
        _listTransaksi.add(newData);
      }
    } catch (e) { _errorMessage = e.toString(); rethrow; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> updateTransaksi(TransaksiModel.Data data) async {
    _isLoading = true; notifyListeners();
    try {
      await ApiService.updateTransaksi(data);
      await _dbHelper.updateTransaksi(data);
      final index = _listTransaksi.indexWhere((e) => e.id == data.id);
      if (index != -1) { _listTransaksi[index] = data; }
    } catch (e) { _errorMessage = e.toString(); rethrow; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> deleteTransaksi(int id) async {
    _isLoading = true; notifyListeners();
    try {
      await ApiService.deleteTransaksi(id);
      await _dbHelper.deleteTransaksi(id);
      _listTransaksi.removeWhere((e) => e.id == id);
    } catch (e) { _errorMessage = e.toString(); rethrow; }
    finally { _isLoading = false; notifyListeners(); }
  }
}