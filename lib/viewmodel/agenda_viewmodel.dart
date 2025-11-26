import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/agenda_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/material.dart';

class AgendaViewmodel extends ChangeNotifier {
  List<Data> _agendaList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Data> get agendaList => _agendaList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final dbHelper =  DatabaseHelper.instance;
  
  Future<void> fetchAgenda() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
    final fromApi = await ApiService.fetchAgenda();
    _agendaList = fromApi;

    await dbHelper.clearAgendaTable();

    for (var agendaData in fromApi) {
      await dbHelper.insertAgenda(agendaData);
    }
    print('✅ Data Agenda berhasil diambil dari API dan disimpan ke DB');

    } catch (e) {
    _errorMessage = e.toString();
    print('❌ Gagal mengambil data dari API: $e. Mencoba memuat dari DB...');
    
    await loadAgendaFromDb();

    } finally {
    _isLoading = false;
    notifyListeners();
    }
  }

  Future<void> loadAgendaFromDb() async {
    _isLoading = true;
    notifyListeners();
    
    _agendaList = await dbHelper.getAllAgenda();
    print('📦 Data Agenda berhasil dimuat dari database lokal. Jumlah: ${_agendaList.length}');
    
    _isLoading = false;
    notifyListeners();
  }
}