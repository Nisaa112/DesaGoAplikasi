import 'package:desa_go_aplikasi/service/auth_service.dart';
import 'package:desa_go_aplikasi/utils/token_storage.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _userName;
  String? get userName => _userName;
  
  String? _userEmail; 
  String? get userEmail => _userEmail;

  int? _userId;
  int? get userId => _userId;
  
  String? _token;
  String? get token => _token;

  AuthViewModel() {
    checkAuthStatus();
  }

  /// Cek status login saat aplikasi dimulai.
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _token = await TokenStorage.getToken();

    if (_token != null && _token!.isNotEmpty) {
      // Jika token ada, muat data user dari storage
      _userId = await TokenStorage.getUserId();
      _userName = await TokenStorage.getUserName();
      // _userEmail = await TokenStorage.getUserEmail(); // Ambil juga email/serial dari storage
      _isLoggedIn = true;
      print('✅ Sesi ditemukan untuk user: $_userName (ID: $_userId)');
    } else {
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<bool> login(String serial, String password) async { 
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggil AuthService dengan Nomor Serial dan Password
      final loginData = await _authService.login(serial, password);
      
      final user = loginData.user;
      if (user == null || user.id == null) {
        throw Exception("Data user tidak valid dari server.");
      }

      // Simpan seluruh data sesi menggunakan TokenStorage
      await TokenStorage.saveUserSession(
        id: user.id!,
        name: user.name ?? 'No Name',
        // Menggunakan serialNumber jika email nullable
        email: user.serialNumber ?? 'No Serial', 
      ); 
      // AuthService sudah menyimpan token, jadi tidak perlu disimpan lagi di sini.

      // Update state di ViewModel
      _isLoggedIn = true;
      _token = loginData.accessToken;
      _userId = user.id;
      _userName = user.name;
      // Gunakan serialNumber untuk _userEmail agar ada nilai yang tersimpan
      _userEmail = user.serialNumber; 

      // TODO: Panggil fungsi fetch data untuk ViewModel lain di sini jika perlu
      // await Provider.of<TugasViewModel>(context, listen: false).fetchTugas();

      _isLoading = false;
      notifyListeners();
      return true; // Sukses

    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      _isLoggedIn = false;
      notifyListeners();
      return false; // Gagal
    }
  }

  /// Fungsi untuk menangani proses logout.
  Future<void> logout(BuildContext context) async {
    // Panggil AuthService untuk logout (menghapus token lokal)
    await _authService.logout();

    // Hapus semua sisa data sesi dari storage
    await TokenStorage.clearAll();
    
    // TODO: Hapus data lokal dari ViewModel lain
    // await Provider.of<TugasViewModel>(context, listen: false).clearLocalData();
    // await Provider.of<LabelViewModel>(context, listen: false).clearLocalData();

    // Reset state ViewModel
    _isLoggedIn = false;
    _token = null;
    _userId = null;
    _userName = null;
    _userEmail = null;
    
    print("🔴 Pengguna berhasil logout.");
    notifyListeners();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}