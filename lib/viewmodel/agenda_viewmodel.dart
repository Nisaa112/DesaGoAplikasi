import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/agenda_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class AgendaViewmodel extends ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  List<Data> _agendaList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Data> get agendaList => _agendaList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load data (Offline First)
  Future<void> fetchAgenda() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1️⃣ Load data lokal dulu
      _agendaList = await dbHelper.getAllAgenda();
      notifyListeners();

      // 2️⃣ Sync dengan API
      await synchronizeAgenda();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sinkronisasi API → DB
  Future<void> synchronizeAgenda() async {
    try {
      final apiData = await ApiService.fetchAgenda();

      for (var item in apiData) {
        await dbHelper.insertAgenda(item);
      }

      _agendaList = await dbHelper.getAllAgenda();
      notifyListeners();
    } catch (e) {
      print('Sync Agenda Gagal: $e');
    }
  }

  /// Create Agenda
  Future<void> createAgenda(Data data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.createAgenda(data);
      if (res != null) {
        await dbHelper.insertAgenda(res);
        _agendaList.insert(0, res);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update Agenda
  Future<void> updateAgenda(Data data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.updateAgenda(data);
      await dbHelper.updateAgenda(data);

      final index = _agendaList.indexWhere((e) => e.id == data.id);
      if (index != -1) {
        _agendaList[index] = data;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete Agenda
  Future<void> deleteAgenda(int id) async {
    try {
      await ApiService.deleteAgenda(id);
      await dbHelper.deleteAgenda(id);
      _agendaList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
