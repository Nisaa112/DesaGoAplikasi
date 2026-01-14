import 'dart:async';
import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as Agenda;
import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as Pengaduan;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as Posyandu;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as Rapat;
import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda;
import 'package:desa_go_aplikasi/models/rt_model.dart' as Rt;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga;
import 'package:desa_go_aplikasi/models/struktur_model.dart' as Struktur;
import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/models/jabatan_model.dart' as JabatanModel;
import 'package:desa_go_aplikasi/models/user_model.dart';

import 'models/rw_model.dart' as Rw;


class DatabaseHelper {
  // Nama file database
  static final _databaseName = "DesaGo.db";
  // Versi database saat ini.
  static final _databaseVersion = 3; 

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
    return await openDatabase(
      path,
      version: _databaseVersion, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    // ------------------- WARGA -------------------
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
    // ------------------- STRUKTUR -------------------
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
    // ------------------- RAPAT -------------------
    await db.execute('''
      CREATE TABLE rapat (
        id INTEGER PRIMARY KEY,
        judul_rapat TEXT,
        lokasi TEXT,
        tujuan TEXT,
        kesimpulan TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- POSYANDU -------------------
    await db.execute('''
      CREATE TABLE posyandu (
        id INTEGER PRIMARY KEY,
        judul_posyandu TEXT,
        penanggung_jawab TEXT,
        tanggal TEXT,
        lokasi TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- RONDA -------------------
    await db.execute('''
      CREATE TABLE ronda (
        id INTEGER PRIMARY KEY,
        tanggal TEXT,
        lokasi TEXT,
        detail TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- DETAIL RONDA -------------------
    await db.execute('''
      CREATE TABLE detail_ronda (
        id INTEGER PRIMARY KEY,
        id_ronda INTEGER,
        id_warga INTEGER,
        jam_mulai TEXT,
        jam_selesai TEXT,
        area_patroli TEXT,
        hadir INTEGER,
        created_at TEXT,
        updated_at TEXT,
        ronda TEXT,
        warga TEXT
      )
    ''');
    // ------------------- AGENDA -------------------
    await db.execute('''
      CREATE TABLE agenda (
        id INTEGER PRIMARY KEY,
        nama_agenda TEXT,
        tanggal TEXT,
        lokasi TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- PENGADUAN -------------------
    await db.execute('''
      CREATE TABLE pengaduan (
        id INTEGER PRIMARY KEY,
        id_user INTEGER,
        recipient TEXT,
        kategori TEXT,
        judul TEXT,
        pesan TEXT,
        status TEXT,
        assigned_to TEXT,
        is_public INTEGER, 
        priority INTEGER,
        response TEXT,
        responded_at TEXT,
        ip_address TEXT,
        user_agent TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- RT -------------------
    await db.execute('''
      CREATE TABLE rt (
        id INTEGER PRIMARY KEY,
        id_rw INTEGER,
        nama_rt TEXT,
        created_at TEXT,
        updated_at TEXT,
        rw TEXT
      )
    ''');
    // ------------------- RW -------------------
    await db.execute('''
      CREATE TABLE rw (
        id INTEGER PRIMARY KEY,
        nama_rw TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }

  // Logika Migrasi
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      print("Migrasi Database: Membuat tabel 'pengaduan' untuk versi 2.");
      await db.execute('''
        CREATE TABLE pengaduan (
          id INTEGER PRIMARY KEY, id_user INTEGER, recipient TEXT,
          kategori TEXT, judul TEXT, pesan TEXT, status TEXT, 
          assigned_to TEXT, is_public INTEGER, priority INTEGER,
          response TEXT, responded_at TEXT, ip_address TEXT,
          user_agent TEXT, created_at TEXT, updated_at TEXT
        )
      ''');
      await db.execute('''
          CREATE TABLE rw(
            id INTEGER PRIMARY KEY,
            nama_rw TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
    }
    
    if (oldVersion < 3) {
      print("Migrasi Database: Membuat tabel 'rt' untuk versi 3.");
      await db.execute('''
        CREATE TABLE rt (
          id INTEGER PRIMARY KEY,
          id_rw INTEGER,
          nama_rt TEXT,
          created_at TEXT,
          updated_at TEXT,
          rw TEXT
        )
      ''');
    }
  }

  // ==========================================================================
  // --- CRUD WARGA (Warga.Data) ---
  // ==========================================================================

  Future<int> insertWarga(Warga.Data warga) async {
    final db = await database;
    final rtJson = warga.rt != null ? jsonEncode(warga.rt!.toJson()) : null;
    final userJson = warga.user != null ? jsonEncode(warga.user!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': warga.id, 'id_rt': warga.idRt, 'id_users': warga.idUsers, 'nama': warga.nama,
      'nik': warga.nik, 'no_telp': warga.noTelp, 'alamat': warga.alamat, 'foto': warga.foto,
      'created_at': warga.createdAt, 'updated_at': warga.updatedAt, 'rt': rtJson, 'user': userJson,
    };
    row.removeWhere((key, value) => value == null);
    print('RT JSON: $rtJson');
    print('User JSON: $userJson');
    return await db.insert('warga', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Warga.Data>> getAllWarga() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('warga');

    return List.generate(maps.length, (i) {
      final rtMap = maps[i]['rt'] != null ? jsonDecode(maps[i]['rt']) : null;
      final userMap = maps[i]['user'] != null ? jsonDecode(maps[i]['user']) : null;

      return Warga.Data(
        id: maps[i]['id'], idRt: maps[i]['id_rt'], idUsers: maps[i]['id_users'],
        nama: maps[i]['nama'], nik: maps[i]['nik'], noTelp: maps[i]['no_telp'],
        alamat: maps[i]['alamat'], foto: maps[i]['foto'], updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
        rt: rtMap != null ? Warga.Rt.fromJson(rtMap) : null,
        user: userMap != null ? UserDetail.fromJson(userMap) : null,
      );
    });
  }

  Future<int> updateWarga(Warga.Data warga) async {
    final db = await database;
    if (warga.id == null) throw Exception("ID Warga tidak boleh null untuk update.");

    final rtJson = warga.rt != null ? jsonEncode(warga.rt!.toJson()) : null;
    final userJson = warga.user != null ? jsonEncode(warga.user!.toJson()) : null;

    Map<String, dynamic> row = {
      'id_rt': warga.idRt, 'id_users': warga.idUsers, 'nama': warga.nama,
      'nik': warga.nik, 'no_telp': warga.noTelp, 'alamat': warga.alamat, 'foto': warga.foto,
      'updated_at': warga.updatedAt, 'rt': rtJson, 'user': userJson,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('warga', row, where: 'id = ?', whereArgs: [warga.id]);
  }

  Future<int> deleteWarga(int id) async {
    final db = await database;
    return await db.delete('warga', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearWargaTable() async {
    final db = await database;
    await db.delete('warga');
  }

  // ==========================================================================
  // --- CRUD RT (Rt.Data) ---
  // ==========================================================================

  Future<int> insertRt(Rt.Data rt) async {
    final db = await database;
    final rwJson = rt.rw != null ? jsonEncode(rt.rw!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': rt.id, 
      'id_rw': rt.idRw, 
      'nama_rt': rt.namaRt,
      'created_at': rt.createdAt, 
      'updated_at': rt.updatedAt, 
      'rw': rwJson
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('rt', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Rt.Data>> getAllRt() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rt');

    return List.generate(maps.length, (i) {
      final rwMap = maps[i]['rw'] != null ? jsonDecode(maps[i]['rw']) : null;

      return Rt.Data(
        id: maps[i]['id'], idRw: maps[i]['id_rw'], 
        namaRt: maps[i]['nama_rt'], 
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
        rw: rwMap != null ? Rt.Rw.fromJson(rwMap) : null,
      );
    });
  }

  Future<int> updateRt(Rt.Data rt) async {
    final db = await database;
    if (rt.id == null) throw Exception("ID rt tidak boleh null untuk update.");

    final rwJson = rt.rw != null ? jsonEncode(rt.rw!.toJson()) : null;

    Map<String, dynamic> row = {
      'id_rw': rt.idRw, 
      'nama_rt': rt.namaRt,
      'updated_at': rt.updatedAt, 
      'rw': rwJson,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('rt', row, where: 'id = ?', whereArgs: [rt.id]);
  }

  Future<int> deleteRt(int id) async {
    final db = await database;
    return await db.delete('rt', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearRtTable() async {
    final db = await database;
    await db.delete('rt');
  }

  // ==========================================================================
  // --- CRUD RW (Rw.Data) ---
  // ==========================================================================

  Future<int> insertRw(Rw.Data rw) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': rw.id, 
      'nama_rw': rw.namaRw,
      'created_at': rw.createdAt, 
      'updated_at': rw.updatedAt
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('rw', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Rw.Data>> getAllRw() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rw');

    return List.generate(maps.length, (i) {

      return Rw.Data(
        id: maps[i]['id'] as int?,
        namaRw: maps[i]['nama_rw'], 
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at']
      );
    });
  }

  Future<int> updateRw(Rw.Data rw) async {
    final db = await database;
    if (rw.id == null) throw Exception("ID rw tidak boleh null untuk update.");

    Map<String, dynamic> row = {
      'nama_rw': rw.namaRw,
      'updated_at': rw.updatedAt
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('rw', row, where: 'id = ?', whereArgs: [rw.id]);
  }

  Future<int> deleteRw(int id) async {
    final db = await database;
    return await db.delete('rw', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearRwTable() async {
    final db = await database;
    await db.delete('rw');
  }

  // ==========================================================================
  // --- CRUD STRUKTUR (Struktur.Data) ---
  // ==========================================================================

  Future<int> insertStruktur(Struktur.Data struktur) async {
    final db = await database;
    final rwJson = struktur.rw != null ? jsonEncode(struktur.rw!.toJson()) : null;
    final rtJson = struktur.rt != null ? jsonEncode(struktur.rt!.toJson()) : null;
    final jabatanJson = struktur.jabatan != null ? jsonEncode(struktur.jabatan!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': struktur.id, 'id_rw': struktur.idRw, 'id_rt': struktur.idRt, 
      'id_jabatan': struktur.idJabatan, 'nama': struktur.nama, 'nik': struktur.nik, 
      'no_telp': struktur.noTelp, 'alamat': struktur.alamat, 'foto': struktur.foto, 
      'created_at': struktur.createdAt, 'updated_at': struktur.updatedAt, 
      'rw': rwJson, 'rt': rtJson, 'jabatan': jabatanJson,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('struktur', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Struktur.Data>> getAllStruktur() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('struktur');

    return List.generate(maps.length, (i) {
      final rwMap = maps[i]['rw'] != null ? jsonDecode(maps[i]['rw']) : null;
      final rtMap = maps[i]['rt'] != null ? jsonDecode(maps[i]['rt']) : null;
      final jabatanMap = maps[i]['jabatan'] != null ? jsonDecode(maps[i]['jabatan']) : null;

      return Struktur.Data(
        id: maps[i]['id'], idRw: maps[i]['id_rw'], idRt: maps[i]['id_rt'],
        idJabatan: maps[i]['id_jabatan'], nama: maps[i]['nama'], nik: maps[i]['nik'],
        noTelp: maps[i]['no_telp'], alamat: maps[i]['alamat'], foto: maps[i]['foto'],
        updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
        rw: rwMap != null ? RwModel.Data.fromJson(rwMap) : null,
        rt: rtMap != null ? RtModel.Data.fromJson(rtMap) : null,
        jabatan: jabatanMap != null ? JabatanModel.Data.fromJson(jabatanMap) : null,
      );
    });
  }

  Future<int> updateStruktur(Struktur.Data struktur) async {
    final db = await database;
    if (struktur.id == null) throw Exception("ID Struktur tidak boleh null untuk update.");

    final rwJson = struktur.rw != null ? jsonEncode(struktur.rw!.toJson()) : null;
    final rtJson = struktur.rt != null ? jsonEncode(struktur.rt!.toJson()) : null;
    final jabatanJson = struktur.jabatan != null ? jsonEncode(struktur.jabatan!.toJson()) : null;

    Map<String, dynamic> row = {
      'id_rw': struktur.idRw, 'id_rt': struktur.idRt, 'id_jabatan': struktur.idJabatan,
      'nama': struktur.nama, 'nik': struktur.nik, 'no_telp': struktur.noTelp,
      'alamat': struktur.alamat, 'foto': struktur.foto, 'updated_at': struktur.updatedAt,
      'rw': rwJson, 'rt': rtJson, 'jabatan': jabatanJson,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('struktur', row, where: 'id = ?', whereArgs: [struktur.id]);
  }

  Future<int> deleteStruktur(int id) async {
    final db = await database;
    return await db.delete('struktur', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearStrukturTable() async {
    final db = await database;
    await db.delete('struktur');
  }

  // ==========================================================================
  // --- CRUD RAPAT (Rapat.Data) ---
  // ==========================================================================

  Future<int> insertRapat(Rapat.Data rapat) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': rapat.id, 'judul_rapat': rapat.judulRapat, 'lokasi': rapat.lokasi,
      'tujuan': rapat.tujuan, 'kesimpulan': rapat.kesimpulan,
      'created_at': rapat.createdAt, 'updated_at': rapat.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('rapat', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Rapat.Data>> getAllRapat() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rapat');

    return List.generate(maps.length, (i) {
      return Rapat.Data(
        id: maps[i]['id'], judulRapat: maps[i]['judul_rapat'], lokasi: maps[i]['lokasi'],
        tujuan: maps[i]['tujuan'], kesimpulan: maps[i]['kesimpulan'],
        updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
      );
    });
  }

  Future<int> updateRapat(Rapat.Data rapat) async {
    final db = await database;
    if (rapat.id == null) throw Exception("ID Rapat tidak boleh null untuk update.");

    Map<String, dynamic> row = {
      'judul_rapat': rapat.judulRapat, 'lokasi': rapat.lokasi,
      'tujuan': rapat.tujuan, 'kesimpulan': rapat.kesimpulan,
      'updated_at': rapat.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('rapat', row, where: 'id = ?', whereArgs: [rapat.id]);
  }

  Future<int> deleteRapat(int id) async {
    final db = await database;
    return await db.delete('rapat', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearRapatTable() async {
    final db = await database;
    await db.delete('rapat');
  }

  // ==========================================================================
  // --- CRUD POSYANDU (Posyandu.Data) ---
  // ==========================================================================

  Future<int> insertPosyandu(Posyandu.Data posyandu) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': posyandu.id, 'judul_posyandu': posyandu.judulPosyandu, 
      'penanggung_jawab': posyandu.penanggungJawab, 'tanggal': posyandu.tanggal, 
      'lokasi': posyandu.lokasi, 'created_at': posyandu.createdAt, 
      'updated_at': posyandu.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('posyandu', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Posyandu.Data>> getAllPosyandu() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posyandu');

    return List.generate(maps.length, (i) {
      return Posyandu.Data(
        id: maps[i]['id'], judulPosyandu: maps[i]['judul_posyandu'], 
        penanggungJawab: maps[i]['penanggung_jawab'], tanggal: maps[i]['tanggal'], 
        lokasi: maps[i]['lokasi'], updatedAt: maps[i]['updated_at'], 
        createdAt: maps[i]['created_at'],
      );
    });
  }

  Future<int> updatePosyandu(Posyandu.Data posyandu) async {
    final db = await database;
    if (posyandu.id == null) throw Exception("ID Posyandu tidak boleh null untuk update.");

    Map<String, dynamic> row = {
      'judul_posyandu': posyandu.judulPosyandu, 'penanggung_jawab': posyandu.penanggungJawab,
      'tanggal': posyandu.tanggal, 'lokasi': posyandu.lokasi, 'updated_at': posyandu.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('posyandu', row, where: 'id = ?', whereArgs: [posyandu.id]);
  }

  Future<int> deletePosyandu(int id) async {
    final db = await database;
    return await db.delete('posyandu', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearPosyanduTable() async {
    final db = await database;
    await db.delete('posyandu');
  }

  // ==========================================================================
  // --- CRUD RONDA (Ronda.Data) ---
  // ==========================================================================

  Future<int> insertRonda(Ronda.Data ronda) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': ronda.id, 'tanggal': ronda.tanggal, 'lokasi': ronda.lokasi,
      'detail': ronda.detail, 'created_at': ronda.createdAt, 'updated_at': ronda.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('ronda', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ronda.Data>> getAllRonda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ronda');

    return List.generate(maps.length, (i) {
      return Ronda.Data(
        id: maps[i]['id'], tanggal: maps[i]['tanggal'], lokasi: maps[i]['lokasi'],
        detail: maps[i]['detail'], updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
      );
    });
  }

  Future<int> updateRonda(Ronda.Data ronda) async {
    final db = await database;
    if (ronda.id == null) throw Exception("ID Ronda tidak boleh null untuk update.");

    Map<String, dynamic> row = {
      'tanggal': ronda.tanggal, 'lokasi': ronda.lokasi, 'detail': ronda.detail,
      'updated_at': ronda.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('ronda', row, where: 'id = ?', whereArgs: [ronda.id]);
  }

  Future<int> deleteRonda(int id) async {
    final db = await database;
    return await db.delete('ronda', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearRondaTable() async {
    final db = await database;
    await db.delete('ronda');
  }

  // ==========================================================================
  // --- CRUD DETAIL RONDA (Ronda.DetailRondas) ---
  // ==========================================================================

  Future<int> insertDetailRonda(Ronda.DetailRondas detailRonda) async {
    final db = await database;

    final wargaJson = detailRonda.warga != null ? jsonEncode(detailRonda.warga!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': detailRonda.id, 'id_ronda': detailRonda.idRonda, 'id_warga': detailRonda.idWarga,
      'jam_mulai': detailRonda.jamMulai, 'jam_selesai': detailRonda.jamSelesai, 
      'area_patroli': detailRonda.areaPatroli, 'hadir': detailRonda.hadir,
      'created_at': detailRonda.createdAt, 'updated_at': detailRonda.updatedAt,
      'warga': wargaJson,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('detail_ronda', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ronda.DetailRondas>> getAllDetailRonda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('detail_ronda');

    return List.generate(maps.length, (i) {
      final wargaMap = maps[i]['warga'] != null ? jsonDecode(maps[i]['warga']) : null;

      return Ronda.DetailRondas(
        id: maps[i]['id'], idRonda: maps[i]['id_ronda'], idWarga: maps[i]['id_warga'],
        jamMulai: maps[i]['jam_mulai'], jamSelesai: maps[i]['jam_selesai'],
        areaPatroli: maps[i]['area_patroli'], hadir: maps[i]['hadir'],
        updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
        warga: wargaMap != null ? Ronda.Warga.fromJson(wargaMap) : null,
      );
    });
  }

  Future<int> updateDetailRonda(Ronda.DetailRondas detailRonda) async {
    final db = await database;
    if (detailRonda.id == null) throw Exception("ID Detail Ronda tidak boleh null untuk update.");

    final wargaJson = detailRonda.warga != null ? jsonEncode(detailRonda.warga!.toJson()) : null;

    Map<String, dynamic> row = {
      'id_ronda': detailRonda.idRonda, 'id_warga': detailRonda.idWarga,
      'jam_mulai': detailRonda.jamMulai, 'jam_selesai': detailRonda.jamSelesai,
      'area_patroli': detailRonda.areaPatroli, 'hadir': detailRonda.hadir,
      'updated_at': detailRonda.updatedAt, 'warga': wargaJson,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('detail_ronda', row, where: 'id = ?', whereArgs: [detailRonda.id]);
  }

  Future<int> deleteDetailRonda(int id) async {
    final db = await database;
    return await db.delete('detail_ronda', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearDetailRondaTable() async {
    final db = await database;
    await db.delete('detail_ronda');
  }

  // ==========================================================================
  // --- CRUD AGENDA (Agenda.Data) ---
  // ==========================================================================

  Future<int> insertAgenda(Agenda.Data agenda) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': agenda.id, 'nama_agenda': agenda.namaAgenda, 'tanggal': agenda.tanggal,
      'lokasi': agenda.lokasi, 'created_at': agenda.createdAt, 'updated_at': agenda.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('agenda', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Agenda.Data>> getAllAgenda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agenda');

    return List.generate(maps.length, (i) {
      return Agenda.Data(
        id: maps[i]['id'], namaAgenda: maps[i]['nama_agenda'], tanggal: maps[i]['tanggal'],
        lokasi: maps[i]['lokasi'], updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
      );
    });
  }

  Future<int> updateAgenda(Agenda.Data agenda) async {
    final db = await database;
    if (agenda.id == null) throw Exception("ID Agenda tidak boleh null untuk update.");

    Map<String, dynamic> row = {
      'nama_agenda': agenda.namaAgenda, 'tanggal': agenda.tanggal,
      'lokasi': agenda.lokasi, 'updated_at': agenda.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('agenda', row, where: 'id = ?', whereArgs: [agenda.id]);
  }

  Future<int> deleteAgenda(int id) async {
    final db = await database;
    return await db.delete('agenda', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAgendaTable() async {
    final db = await database;
    await db.delete('agenda');
  }

  // ==========================================================================
  // --- CRUD PENGADUAN (Pengaduan.Data) ---
  // ==========================================================================

  Future<int> insertPengaduan(Pengaduan.Data pengaduan) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': pengaduan.id, 'id_user': pengaduan.userId, 'recipient': pengaduan.recipient,
      'kategori': pengaduan.kategori, 'judul': pengaduan.judul, 'pesan': pengaduan.pesan,
      'status': pengaduan.status, 'assigned_to': pengaduan.assignedTo, 
      'is_public': pengaduan.isPublic != null ? (pengaduan.isPublic! ? 1 : 0) : null,
      'priority': pengaduan.priority, 'response': pengaduan.response,
      'responded_at': pengaduan.respondedAt, 'ip_address': pengaduan.ipAddress,
      'user_agent': pengaduan.userAgent, 'created_at': pengaduan.createdAt,
      'updated_at': pengaduan.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('pengaduan', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pengaduan.Data>> getAllPengaduan() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pengaduan'); 

    return List.generate(maps.length, (i) {
      return Pengaduan.Data(
        id: maps[i]['id'], userId: maps[i]['id_user'], recipient: maps[i]['recipient'],
        kategori: maps[i]['kategori'], judul: maps[i]['judul'], pesan: maps[i]['pesan'],
        status: maps[i]['status'], assignedTo: maps[i]['assigned_to'],
        isPublic: maps[i]['is_public'] == 1, priority: maps[i]['priority'],
        response: maps[i]['response'], respondedAt: maps[i]['responded_at'],
        ipAddress: maps[i]['ip_address'], userAgent: maps[i]['user_agent'],
        updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
      );
    });
  }

  // UPDATE (sudah ada, dinamai updatePengaduanLocal)
  Future<int> updatePengaduanLocal(Pengaduan.Data pengaduan) async {
    final db = await database;
    if (pengaduan.id == null) throw Exception("ID Pengaduan tidak boleh null untuk operasi update.");
    
    Map<String, dynamic> row = {
      'id_user': pengaduan.userId, 'recipient': pengaduan.recipient,
      'kategori': pengaduan.kategori, 'judul': pengaduan.judul, 'pesan': pengaduan.pesan,
      'status': pengaduan.status, 'assigned_to': pengaduan.assignedTo, 
      'is_public': pengaduan.isPublic != null ? (pengaduan.isPublic! ? 1 : 0) : null, 
      'priority': pengaduan.priority, 'response': pengaduan.response,
      'responded_at': pengaduan.respondedAt, 'ip_address': pengaduan.ipAddress,
      'user_agent': pengaduan.userAgent, 'created_at': pengaduan.createdAt,
      'updated_at': pengaduan.updatedAt,
    };
    row.removeWhere((key, value) => value == null);
    
    return await db.update('pengaduan', row, where: 'id = ?', whereArgs: [pengaduan.id]);
  }

  // DELETE (sudah ada, dinamai deletePengaduanLocal)
  Future<int> deletePengaduanLocal(int id) async {
    final db = await database;
    return await db.delete('pengaduan', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearPengaduanTable() async {
    final db = await database;
    await db.delete('pengaduan');
  }
}