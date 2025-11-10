// lib/db_helper.dart

import 'dart:async';
import 'dart:io';
import 'package:desa_go_aplikasi/models/warga_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "proyek_baru.db";
  static final _databaseVersion = 3;

  static final tableWarga = 'warga';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableWarga (
        id INTEGER PRIMARY KEY,
        id_rt TEXT,
        id_users TEXT,
        nama TEXT,
        nik TEXT,
        no_telp TEXT,
        alamat TEXT,
        foto TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }
  
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Jika Anda ingin skema baru diterapkan, Anda bisa drop tabel lama dan buat ulang
    await db.execute('DROP TABLE IF EXISTS $tableWarga');
    await _onCreate(db, newVersion);
  }

  // [DITAMBAHKAN] Method untuk memasukkan data warga ke DB
  Future<void> insertWarga(Data warga) async {
    final db = await database;
    // Menggunakan conflictAlgorithm.replace agar data lama ditimpa jika id sama
    await db.insert(
      tableWarga,
      warga.toJson(), // Model 'Data' sudah punya method toJson() yang cocok
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // [DIPERBAIKI] Mengambil List<Data>, bukan List<WargaModel>
  Future<List<Data>> getAllWarga() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableWarga);
    if (maps.isEmpty) {
      return [];
    }
    // Mapping dari Map ke objek Data
    return maps.map((json) => Data.fromJson(json)).toList();
  }

  // Method untuk membersihkan tabel sebelum memasukkan data baru
  Future<void> clearWargaTable() async {
    final db = await database;
    await db.delete(tableWarga);
  }
}