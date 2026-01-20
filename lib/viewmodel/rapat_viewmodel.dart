import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/rapat_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class RapatViewmodel extends ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  List<Data> _rapatList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Data> get rapatList => _rapatList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load data (Offline First)
  Future<void> fetchRapat() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1️⃣ Load data lokal dulu
      _rapatList = await dbHelper.getAllRapat();
      notifyListeners();

      // 2️⃣ Sync API
      await synchronizeRapat();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sinkronisasi API → DB
  Future<void> synchronizeRapat() async {
    try {
      final apiData = await ApiService.fetchRapat();

      for (var item in apiData) {
        await dbHelper.insertRapat(item);
      }

      _rapatList = await dbHelper.getAllRapat();
      notifyListeners();
    } catch (e) {
      print('Sync Rapat Gagal: $e');
    }
  }

  /// Create Rapat
  Future<void> createRapat(Data data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.createRapat(data);
      if (res != null) {
        await dbHelper.insertRapat(res);
        _rapatList.insert(0, res);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update Rapat
  Future<void> updateRapat(Data data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.updateRapat(data);
      await dbHelper.updateRapat(data);

      final index = _rapatList.indexWhere((e) => e.id == data.id);
      if (index != -1) {
        _rapatList[index] = data;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete Rapat
  Future<void> deleteRapat(int id) async {
    try {
      await ApiService.deleteRapat(id);
      await dbHelper.deleteRapat(id);
      _rapatList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
