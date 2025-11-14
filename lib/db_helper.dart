import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:desa_go_aplikasi/models/warga_model.dart';
import 'package:desa_go_aplikasi/models/user_model.dart';

class DatabaseHelper {
  static final _databaseName = "DesaGo.db";
  static final _databaseVersion = 2; 

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE warga (
        id INTEGER PRIMARY KEY,
        id_rt INTEGER,
        id_users INTEGER,
        nama TEXT,
        nik TEXT,
        no_telp TEXT,
        alamat TEXT,
        foto TEXT,
        created_at TEXT,
        updated_at TEXT,
        rt TEXT,   
        user TEXT  
      )
    ''');
  }

  Future<int> insertWarga(Data warga) async {
    final db = await database;

    final rtJson = warga.rt != null ? jsonEncode(warga.rt!.toJson()) : null;
    final userJson = warga.user != null ? jsonEncode(warga.user!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': warga.id,
      'id_rt': warga.idRt,
      'id_users': warga.idUsers,
      'nama': warga.nama,
      'nik': warga.nik,
      'no_telp': warga.noTelp,
      'alamat': warga.alamat,
      'foto': warga.foto,
      'created_at': warga.createdAt,
      'updated_at': warga.updatedAt,
      'rt': rtJson, 
      'user': userJson,
    };

    return await db.insert(
      'warga',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE warga ADD COLUMN rt TEXT;');
      await db.execute('ALTER TABLE warga ADD COLUMN user TEXT;');
    }
  }

  Future<List<Data>> getAllWarga() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('warga');

    return List.generate(maps.length, (i) {
      // 1. Deserialize JSON String kembali ke Map
      final rtMap = maps[i]['rt'] != null ? jsonDecode(maps[i]['rt']) : null;
      final userMap = maps[i]['user'] != null ? jsonDecode(maps[i]['user']) : null;
      
      return Data(
        id: maps[i]['id'],
        idRt: maps[i]['id_rt'],
        idUsers: maps[i]['id_users'],
        nama: maps[i]['nama'],
        nik: maps[i]['nik'],
        noTelp: maps[i]['no_telp'],
        alamat: maps[i]['alamat'],
        foto: maps[i]['foto'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
        
        // 2. Ubah Map kembali ke model menggunakan fromJson
        rt: rtMap != null ? Rt.fromJson(rtMap) : null,
        user: userMap != null ? UserDetail.fromJson(userMap) : null,
      );
    });
  }
  
  // Fungsi clearWargaTable (asumsi Anda sudah memilikinya)
  Future<void> clearWargaTable() async {
    final db = await database;
    await db.delete('warga');
  }
}