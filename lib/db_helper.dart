import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// --- IMPOR DENGAN ALIAS KETAT ---
import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga;
import 'package:desa_go_aplikasi/models/struktur_model.dart' as Struktur;
import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/models/jabatan_model.dart' as JabatanModel;
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
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
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

    await db.execute('''
      CREATE TABLE struktur (
        id INTEGER PRIMARY KEY,
        id_rw INTEGER,
        id_rt INTEGER,
        id_jabatan INTEGER,
        nama TEXT,
        nik TEXT,
        alamat TEXT,
        no_telp TEXT,
        foto TEXT,
        created_at TEXT,
        updated_at TEXT,
        rt TEXT,
        rw TEXT,
        jabatan TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE struktur (
          id INTEGER PRIMARY KEY,
          id_rw INTEGER,
          id_rt INTEGER,
          id_jabatan INTEGER,
          nama TEXT,
          nik TEXT,
          alamat TEXT,
          no_telp TEXT,
          foto TEXT,
          created_at TEXT,
          updated_at TEXT,
          rt TEXT,
          rw TEXT,
          jabatan TEXT
        )
      ''');
    }
  }

  // --------------------------------------------------------------------------
  // --- WARGA ---
  // --------------------------------------------------------------------------

  Future<int> insertWarga(Warga.Data warga) async {
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

  Future<List<Warga.Data>> getAllWarga() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('warga');

    return List.generate(maps.length, (i) {
      final rtMap = maps[i]['rt'] != null ? jsonDecode(maps[i]['rt']) : null;
      final userMap = maps[i]['user'] != null ? jsonDecode(maps[i]['user']) : null;

      return Warga.Data(
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

        rt: rtMap != null ? Warga.Rt.fromJson(rtMap) : null,
        user: userMap != null ? UserDetail.fromJson(userMap) : null,
      );
    });
  }

  Future<void> clearWargaTable() async {
    final db = await database;
    await db.delete('warga');
  }

  // --------------------------------------------------------------------------
  // --- STRUKTUR ---
  // --------------------------------------------------------------------------

  Future<int> insertStruktur(Struktur.Data struktur) async {
    final db = await database;

    final rwJson = struktur.rw != null ? jsonEncode(struktur.rw!.toJson()) : null;
    final rtJson = struktur.rt != null ? jsonEncode(struktur.rt!.toJson()) : null;
    final jabatanJson = struktur.jabatan != null ? jsonEncode(struktur.jabatan!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': struktur.id,
      'id_rw': struktur.idRw,
      'id_rt': struktur.idRt,
      'id_jabatan': struktur.idJabatan,
      'nama': struktur.nama,
      'nik': struktur.nik,
      'no_telp': struktur.noTelp,
      'alamat': struktur.alamat,
      'foto': struktur.foto,
      'created_at': struktur.createdAt,
      'updated_at': struktur.updatedAt,
      'rw': rwJson,
      'rt': rtJson,
      'jabatan': jabatanJson,
    };

    return await db.insert(
      'struktur',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Struktur.Data>> getAllStruktur() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('struktur');

    return List.generate(maps.length, (i) {
      final rwMap = maps[i]['rw'] != null ? jsonDecode(maps[i]['rw']) : null;
      final rtMap = maps[i]['rt'] != null ? jsonDecode(maps[i]['rt']) : null;
      final jabatanMap = maps[i]['jabatan'] != null ? jsonDecode(maps[i]['jabatan']) : null;

      return Struktur.Data(
        id: maps[i]['id'],
        idRw: maps[i]['id_rw'],
        idRt: maps[i]['id_rt'],
        idJabatan: maps[i]['id_jabatan'],
        nama: maps[i]['nama'],
        nik: maps[i]['nik'],
        noTelp: maps[i]['no_telp'],
        alamat: maps[i]['alamat'],
        foto: maps[i]['foto'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
        
        // Pemanggilan 'fromJson' ini sudah benar
        rw: rwMap != null ? RwModel.Rw.fromJson(rwMap) : null,
        rt: rtMap != null ? RtModel.Rt.fromJson(rtMap) : null,
        jabatan: jabatanMap != null ? JabatanModel.Data.fromJson(jabatanMap) : null,
      );
    });
  }
  
  Future<void> clearStrukturTable() async {
    final db = await database;
    await db.delete('struktur');
  }
}