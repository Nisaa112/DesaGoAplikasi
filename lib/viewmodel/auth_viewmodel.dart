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
  
  String? _userRole; 
  String? get userRole => _userRole;

  int? _userId;
  int? get userId => _userId;
  
  String? _token;
  String? get token => _token;

  AuthViewModel() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _token = await TokenStorage.getToken();

    if (_token != null && _token!.isNotEmpty) {
      print('⏳ Token lokal ditemukan. Memvalidasi ke server...');
      
      final isTokenValid = await _authService.verifyToken(_token!);
      
      if (isTokenValid) {
        _userId = await TokenStorage.getUserId();
        _userName = await TokenStorage.getUserName();
        _userEmail = await TokenStorage.getUserEmail();
        _userRole = await TokenStorage.getUserRole();
        _isLoggedIn = true;
        print('✅ Sesi ditemukan & valid untuk user: $_userName (ID: $_userId) (Role: $_userRole)');
      } else {
        print('⚠️ Token tidak valid dari server. Sesi akan dihapus.');
        await TokenStorage.clearAll();
        _token = null;
        _isLoggedIn = false;
        _userRole = null;
      }
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
      final loginData = await _authService.login(serial, password);
      
      final user = loginData.user;
      final accessToken = loginData.accessToken;

      final userRole = user?.role; 
      
      if (user == null || user.id == null || accessToken == null || userRole == null) {
        throw Exception("Data user atau token tidak valid dari server.");
      }

      await TokenStorage.saveUserSession(
        token: accessToken,
        id: user.id!,
        name: user.name ?? 'No Name',
        email: user.serialNumber ?? 'No Serial', 
        role: userRole,
      ); 

      _isLoggedIn = true;
      _token = accessToken;
      _userId = user.id;
      _userName = user.name;
      _userEmail = user.serialNumber; 
      _userRole = userRole; 


      _isLoading = false;
      notifyListeners();
      return true; 

    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout(); 
    await TokenStorage.clearAll();
    
    _isLoggedIn = false;
    _token = null;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    
    print("🔴 Pengguna berhasil logout.");
    notifyListeners();

    // Navigasi ke halaman login dan hapus semua rute sebelumnya
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}