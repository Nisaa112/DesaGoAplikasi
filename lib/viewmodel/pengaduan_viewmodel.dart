import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:flutter/material.dart';
import '../models/pengaduan_model.dart' as PengaduanModel;
import '../service/api_service.dart';

class PengaduanViewModel extends ChangeNotifier {
  List<PengaduanModel.Data> _pengaduanList = [];
  bool _isLoading = false;

  List<PengaduanModel.Data> get pengaduanList => _pengaduanList;
  bool get isLoading => _isLoading;

  PengaduanViewModel() {
    fetchPengaduan();
  }

  Future<void> fetchPengaduan() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<PengaduanModel.Data> fromApi = await ApiService.fetchPengaduan();

      final db = DatabaseHelper.instance;
      await db.clearPengaduanTable(); 

      for (var pengaduan in fromApi) {
        if (pengaduan.id != null) {
          await db.insertPengaduan(pengaduan); 
        }
      }

      _pengaduanList = fromApi;
      print("✅ Data Pengaduan disinkronkan dan diupdate dari API.");

    } catch (e) {
      print('⚠️ Gagal sinkronisasi Pengaduan dari API: $e');
      final db = DatabaseHelper.instance;
      _pengaduanList = await db.getAllPengaduan();
      print("📦 Mengambil Pengaduan dari SQLite karena API gagal.");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPengaduan(PengaduanModel.Data pengaduan) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('🛠️ Menambahkan Pengaduan baru: ${pengaduan.judul}');
      
      final created = await ApiService.createPengaduan(pengaduan);

      if (created != null && created.id != null) {
        _pengaduanList.insert(0, created);

        await DatabaseHelper.instance.insertPengaduan(created); 

        debugPrint('✅ Pengaduan berhasil ditambahkan (API & Lokal): ${created.judul}');
      } else {
        debugPrint('⚠️ Gagal menambahkan Pengaduan: Response null/ID null dari API');
      }
    } catch (e) {
      debugPrint('❌ Error saat tambah Pengaduan ke API: $e');

      try {
        final db = DatabaseHelper.instance;
        pengaduan.id = -(DateTime.now().millisecondsSinceEpoch); 
        await db.insertPengaduan(pengaduan);
        _pengaduanList.insert(0, pengaduan);
        debugPrint('📦 Pengaduan disimpan secara lokal sebagai fallback dengan ID: ${pengaduan.id}');
      } catch (dbError) {
        debugPrint('❌ Gagal menyimpan ke database lokal: $dbError');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePengaduan(PengaduanModel.Data updatedPengaduan) async {
    if (updatedPengaduan.id == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.updatePengaduan(updatedPengaduan);
      
      await DatabaseHelper.instance.updatePengaduanLocal(updatedPengaduan); 

      final index = _pengaduanList.indexWhere((p) => p.id == updatedPengaduan.id);
      if (index != -1) {
        _pengaduanList[index] = updatedPengaduan;
      }
      
      print("✅ Pengaduan '${updatedPengaduan.judul}' berhasil diupdate (API & Lokal).");

    } catch (e) {
      print("❌ Gagal mengirim update Pengaduan ke API/Lokal: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePengaduan(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ApiService.deletePengaduan(id); 

      await DatabaseHelper.instance.deletePengaduanLocal(id);
      
      _pengaduanList.removeWhere((p) => p.id == id);

      print("✅ Pengaduan dengan ID $id berhasil dihapus.");

    } catch (e) {
      print('❌ Error saat hapus Pengaduan: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearLocalPengaduan() async {
    await DatabaseHelper.instance.clearPengaduanTable();
    _pengaduanList = [];
    print("🗑️ Semua data pengaduan lokal telah dihapus.");
    notifyListeners();
  }
}