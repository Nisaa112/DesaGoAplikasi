import 'package:desa_go_aplikasi/db_helper.dart';
import 'package:desa_go_aplikasi/models/user_model.dart';
import 'package:desa_go_aplikasi/service/api_service.dart';
import 'package:flutter/foundation.dart';

class UserViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<UserDetail> _users = [];
  List<UserDetail> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Load data dari Lokal lalu Sync ke API
  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Load dari Database Lokal
      _users = await _dbHelper.getAllUsers();
      notifyListeners();

      // 2. Sinkronisasi dengan API
      await synchronizeUsers();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> synchronizeUsers() async {
    try {
      final apiUsers = await ApiService.fetchUsers();
      await _dbHelper.clearUserTable();
      for (var user in apiUsers) {
        await _dbHelper.insertUser(user);
      }
      _users = apiUsers;
      notifyListeners();
    } catch (e) {
      print('Sinkronisasi User gagal: $e');
    }
  }

  Future<void> createUser(String name, String serial, String role, String password, int? idRw) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        'name': name,
        'serial_number': serial,
        'role': role,
        'password': password,
        'password_confirmation': password,  
        'id_rw': idRw,
      };

      final newUser = await ApiService.createUser(data);
      if (newUser != null) {
        await _dbHelper.insertUser(newUser);
        _users.add(newUser);
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}