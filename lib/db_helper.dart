import 'dart:async';
import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as Agenda;
import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel show Data;
import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as Pengaduan;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as Posyandu;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as Rapat;
import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda;
import 'package:desa_go_aplikasi/models/rt_model.dart' as Rt;
import 'package:desa_go_aplikasi/models/transaksi_model.dart' as TransaksiModel show Data;
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
  static final _databaseVersion = 4; 

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
        id_kas INTEGER,
        anggaran INTEGER,
        judul_rapat TEXT,
        lokasi TEXT,
        tanggal TEXT,
        penanggung_jawab TEXT,
        jam_mulai TEXT,
        status TEXT,
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
        id_kas INTEGER,
        anggaran INTEGER,
        judul_posyandu TEXT,
        penanggung_jawab TEXT,
        tanggal TEXT,
        keterangan TEXT,
        lokasi TEXT,
        jam_mulai TEXT,
        status TEXT,
        total_diperiksa INTEGER,
        total_sehat INTEGER,
        total_perlu_tindak_lanjut INTEGER,
        total_diimunisasi INTEGER,
        ringkasan_hasil TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- RONDA -------------------
    await db.execute('''
      CREATE TABLE ronda (
        id INTEGER PRIMARY KEY,
        id_kas INTEGER,
        anggaran INTEGER,
        tanggal TEXT,
        lokasi TEXT,
        detail TEXT,
        hasil TEXT,
        penanggung_jawab INTEGER,
        kas_json TEXT,
        details_json TEXT, 
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
        id_kas INTEGER,
        anggaran INTEGER,
        nama_agenda TEXT,
        tanggal TEXT,
        lokasi TEXT,
        penanggung_jawab TEXT,
        jam_mulai TEXT,
        status TEXT,
        keterangan TEXT,
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
    // ------------------- JABATAN -------------------
    await db.execute('''
      CREATE TABLE jabatan (
        id INTEGER PRIMARY KEY,
        nama_jabatan TEXT,
        value_jabatan TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- USER -------------------
    await db.execute('''
      CREATE TABLE users_local (
        id INTEGER PRIMARY KEY,
        id_rw INTEGER,
        name TEXT,
        serial_number TEXT,
        email TEXT,
        role TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // ------------------- KAS -------------------
    await db.execute('''
      CREATE TABLE kas_local (
        id INTEGER PRIMARY KEY,
        nama_pengguna TEXT,
        email TEXT,
        peran TEXT,
        saldo TEXT,
        created_at TEXT,
        updated_at TEXT,
        deleted_at TEXT
      )
    ''');
    // ------------------- TRANSAKSI -------------------
    await db.execute('''
      CREATE TABLE transaksi_local (
        id INTEGER PRIMARY KEY,
        kas_id INTEGER,
        kode TEXT,
        tanggal TEXT,
        jenis TEXT,
        jumlah INTEGER,
        keterangan TEXT,
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
  // --- CRUD RAPAT ---
  // ==========================================================================

  Future<int> insertRapat(Rapat.Data rapat) async {
    final db = await database;
    Map<String, dynamic> row = rapat.toJson();
    row.removeWhere((key, value) => value == null);
    return await db.insert('rapat', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Rapat.Data>> getAllRapat() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rapat');
    return List.generate(maps.length, (i) => Rapat.Data.fromJson(maps[i]));
  }

  Future<int> updateRapat(Rapat.Data rapat) async {
    final db = await database;
    return await db.update('rapat', rapat.toJson(), where: 'id = ?', whereArgs: [rapat.id]);
  }

  Future<int> deleteRapat(int id) async {
    final db = await database;
    return await db.delete('rapat', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================================================
  // --- CRUD POSYANDU ---
  // ==========================================================================

  Future<int> insertPosyandu(Posyandu.Data posyandu) async {
    final db = await database;
    Map<String, dynamic> row = posyandu.toJson();
    row.removeWhere((key, value) => value == null);
    return await db.insert('posyandu', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Posyandu.Data>> getAllPosyandu() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posyandu');
    return List.generate(maps.length, (i) => Posyandu.Data.fromJson(maps[i]));
  }

  Future<int> updatePosyandu(Posyandu.Data posyandu) async {
    final db = await database;
    return await db.update('posyandu', posyandu.toJson(), where: 'id = ?', whereArgs: [posyandu.id]);
  }

  Future<int> deletePosyandu(int id) async {
    final db = await database;
    return await db.delete('posyandu', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================================================
  // --- CRUD RONDA ---
  // ==========================================================================

  Future<int> insertRonda(Ronda.RondaData ronda) async {
    final db = await database;
    
    // PENTING: Ubah Objek/List menjadi JSON String agar SQLite tidak marah
    final kasJson = ronda.kas != null ? jsonEncode(ronda.kas!.toJson()) : null;
    final detailsJson = ronda.detailRondas != null 
        ? jsonEncode(ronda.detailRondas!.map((v) => v.toJson()).toList()) 
        : null;

    Map<String, dynamic> row = {
      'id': ronda.id,
      'id_kas': ronda.idKas,
      'anggaran': ronda.anggaran,
      'tanggal': ronda.tanggal,
      'lokasi': ronda.lokasi,
      'detail': ronda.detail,
      'hasil': ronda.hasil,
      'penanggung_jawab': ronda.penanggungJawab,
      'created_at': ronda.createdAt,
      'updated_at': ronda.updatedAt,
      'kas_json': kasJson,       // Simpan sebagai Teks
      'details_json': detailsJson, // Simpan sebagai Teks
    };
    
    row.removeWhere((key, value) => value == null);
    return await db.insert('ronda', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ronda.RondaData>> getAllRonda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ronda');

    return List.generate(maps.length, (i) {
      Map<String, dynamic> item = Map<String, dynamic>.from(maps[i]);

      // Kembalikan Teks JSON menjadi Objek/List agar bisa dibaca Model
      if (item['details_json'] != null) {
        item['details'] = jsonDecode(item['details_json']);
      }
      if (item['kas_json'] != null) {
        item['kas'] = jsonDecode(item['kas_json']);
      }
      
      return Ronda.RondaData.fromJson(item);
    });
  }

  Future<int> updateRonda(Ronda.RondaData ronda) async {
    final db = await database;
    
    final kasJson = ronda.kas != null ? jsonEncode(ronda.kas!.toJson()) : null;
    final detailsJson = ronda.detailRondas != null 
        ? jsonEncode(ronda.detailRondas!.map((v) => v.toJson()).toList()) 
        : null;

    Map<String, dynamic> row = {
      'id_kas': ronda.idKas,
      'anggaran': ronda.anggaran,
      'tanggal': ronda.tanggal,
      'lokasi': ronda.lokasi,
      'detail': ronda.detail,
      'hasil': ronda.hasil,
      'penanggung_jawab': ronda.penanggungJawab,
      'updated_at': DateTime.now().toIso8601String(),
      'kas_json': kasJson,
      'details_json': detailsJson,
    };

    return await db.update('ronda', row, where: 'id = ?', whereArgs: [ronda.id]);
  }

  Future<int> deleteRonda(int id) async {
    final db = await database;
    return await db.delete('ronda', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================================================
  // --- CRUD AGENDA ---
  // ==========================================================================

  Future<int> insertAgenda(Agenda.Data agenda) async {
    final db = await database;
    Map<String, dynamic> row = agenda.toJson();
    row.removeWhere((key, value) => value == null);
    return await db.insert('agenda', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Agenda.Data>> getAllAgenda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agenda');
    return List.generate(maps.length, (i) => Agenda.Data.fromJson(maps[i]));
  }

  Future<int> updateAgenda(Agenda.Data agenda) async {
    final db = await database;
    return await db.update('agenda', agenda.toJson(), where: 'id = ?', whereArgs: [agenda.id]);
  }

  Future<int> deleteAgenda(int id) async {
    final db = await database;
    return await db.delete('agenda', where: 'id = ?', whereArgs: [id]);
  }

  // --- Utility ---
  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('rapat');
    await db.delete('posyandu');
    await db.delete('ronda');
    await db.delete('agenda');
  }

  // ==========================================================================
  // --- CRUD JABATAN (Jabatan.Data) ---
  // ==========================================================================

  Future<int> insertJabatan(JabatanModel.Data jabatan) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': jabatan.id, 'nama_jabatan': jabatan.namaJabatan, 'value_jabatan': jabatan.valueJabatan, 'created_at': jabatan.createdAt, 'updated_at': jabatan.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.insert('jabatan', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<JabatanModel.Data>> getAllJabatan() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('jabatan');

    return List.generate(maps.length, (i) {
      return JabatanModel.Data(
        id: maps[i]['id'], namaJabatan: maps[i]['nama_jabatan'], valueJabatan: maps[i]['value_jabatan'], updatedAt: maps[i]['updated_at'], createdAt: maps[i]['created_at'],
      );
    });
  }

  Future<int> updateJabatan(JabatanModel.Data jabatan) async {
    final db = await database;
    if (jabatan.id == null) throw Exception("ID jabatan tidak boleh null untuk update.");

    Map<String, dynamic> row = {
      'nama_jabatan': jabatan.namaJabatan, 'value_jabatan': jabatan.valueJabatan, 'updated_at': jabatan.updatedAt,
    };
    row.removeWhere((key, value) => value == null);

    return await db.update('jabatan', row, where: 'id = ?', whereArgs: [jabatan.id]);
  }

  Future<int> deleteJabatan(int id) async {
    final db = await database;
    return await db.delete('jabatan', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearJabatanTable() async {
    final db = await database;
    await db.delete('jabatan');
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

  // ==========================================================================
  // --- CRUD USER (User.Data) ---
  // ==========================================================================
  Future<int> insertUser(UserDetail user) async {
    final db = await database;
    return await db.insert('users_local', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<UserDetail>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users_local');
    return List.generate(maps.length, (i) => UserDetail.fromJson(maps[i]));
  }

  Future<void> clearUserTable() async {
    final db = await database;
    await db.delete('users_local');
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users_local', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================================================
  // --- CRUD KAS (KasModel.Data) ---
  // ==========================================================================

  Future<int> insertKas(KasModel.Data kas) async {
    final db = await database;
    Map<String, dynamic> row = kas.toJson();
    row.removeWhere((key, value) => value == null);
    print("DEBUG DB: Menghubungi SQLite untuk simpan saldo: ${row['saldo']}");
    return await db.insert('kas_local', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<KasModel.Data>> getAllKas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kas_local');
    return List.generate(maps.length, (i) => KasModel.Data.fromJson(maps[i]));
  }

  Future<int> updateKas(KasModel.Data kas) async {
    final db = await database;
    if (kas.id == null) throw Exception("ID Kas tidak boleh null untuk update.");
    return await db.update('kas_local', kas.toJson(), where: 'id = ?', whereArgs: [kas.id]);
  }

  Future<int> deleteKas(int id) async {
    final db = await database;
    return await db.delete('kas_local', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearKasTable() async {
    final db = await database;
    await db.delete('kas_local');
  }

  // ==========================================================================
  // --- CRUD TRANSAKSI (TransaksiModel.Data) ---
  // ==========================================================================

  Future<int> insertTransaksi(TransaksiModel.Data trx) async {
    final db = await database;
    Map<String, dynamic> row = trx.toJson();
    row.removeWhere((key, value) => value == null);
    return await db.insert('transaksi_local', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TransaksiModel.Data>> getAllTransaksi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi_local');
    return List.generate(maps.length, (i) => TransaksiModel.Data.fromJson(maps[i]));
  }

  Future<int> updateTransaksi(TransaksiModel.Data trx) async {
    final db = await database;
    if (trx.id == null) throw Exception("ID Transaksi tidak boleh null untuk update.");
    return await db.update('transaksi_local', trx.toJson(), where: 'id = ?', whereArgs: [trx.id]);
  }

  Future<int> deleteTransaksi(int id) async {
    final db = await database;
    return await db.delete('transaksi_local', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTransaksiTable() async {
    final db = await database;
    await db.delete('transaksi_local');
  }
}