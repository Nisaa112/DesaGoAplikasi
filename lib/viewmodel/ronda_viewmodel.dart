import 'dart:convert';
import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda;

class RondaViewModel extends ChangeNotifier {
    final DatabaseHelper _dbHelper = DatabaseHelper.instance;

    List<Ronda.Data> _listRonda = [];
    bool _isLoading = false;
    String _errorMessage = '';

    List<Ronda.Data> get listRonda => _listRonda;
    bool get isLoading => _isLoading;
    String get errorMessage => _errorMessage;

    RondaViewModel() {
        loadRondaData(fetchFromApi: true);
    }

    // ------------------------------------------------------------------
    // --- Load Data Dari Database Lokal ---
    // ------------------------------------------------------------------

    Future<void> loadDataFromDb() async {
        try {
            _listRonda = await _dbHelper.getAllRonda();
            
            await _attachDetailsToRondaList(_listRonda);

            _errorMessage = '';
        } catch (e) {
            _errorMessage = 'Gagal memuat data lokal: ${e.toString()}';
            debugPrint('Error loading Ronda data from DB: $e');
        }
    }


    // ------------------------------------------------------------------
    // --- Fungsi Utama: Load dan Sinkronisasi Data ---
    // ------------------------------------------------------------------

    Future<void> loadRondaData({bool fetchFromApi = false}) async {
        _isLoading = true;
        notifyListeners(); 

        await loadDataFromDb();
        notifyListeners();

        if (!fetchFromApi) {
            _isLoading = false;
            notifyListeners();
            return;
        }

        try {
            final apiRondaList = await ApiService.fetchRonda();

            if (apiRondaList.isNotEmpty) {
                await _dbHelper.clearRondaTable();
                for (var ronda in apiRondaList) {
                    await _dbHelper.insertRonda(ronda);
                }

                final apiDetailRondaList = await ApiService.fetchRondaDetail();
                await _dbHelper.clearDetailRondaTable();
                for (var detailRonda in apiDetailRondaList) {
                    await _dbHelper.insertDetailRonda(detailRonda);
                }
                
                await loadDataFromDb();

                _errorMessage = '';
            } else if (_listRonda.isEmpty) {
                 _errorMessage = 'Tidak dapat mengambil data baru dari server dan data lokal kosong.';
            }

        } catch (e) {
            _errorMessage = 'Gagal melakukan sinkronisasi dengan server: ${e.toString()}';
            debugPrint('Error loading Ronda data from API: $e');
        } finally {
            _isLoading = false;
            notifyListeners(); 
        }
    }

    // ------------------------------------------------------------------
    // --- Fungsi Helper: Menggabungkan Detail ke Data Utama ---
    // ------------------------------------------------------------------
    
    Future<void> _attachDetailsToRondaList(List<Ronda.Data> list) async {
        final allDetails = await _dbHelper.getAllDetailRonda();
        
        Map<int, List<Ronda.DetailRondas>> detailsMap = {};
        for (var detail in allDetails) {
            if (detail.idRonda != null) {
                if (!detailsMap.containsKey(detail.idRonda)) {
                    detailsMap[detail.idRonda!] = [];
                }
                detailsMap[detail.idRonda!]!.add(detail);
            }
        }

        for (var ronda in list) {
            if (ronda.id != null && detailsMap.containsKey(ronda.id)) {
                ronda.detailRondas = detailsMap[ronda.id]; 
            } else {
                 ronda.detailRondas = [];
            }
        }
    }
}