import 'dart:async';
import 'dart:convert';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as Agenda;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as Posyandu;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as Rapat;
import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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

  // --------------------------------------------------------------------------
  // --- RAPAT ---
  // --------------------------------------------------------------------------

  Future<int> insertRapat(Rapat.Data rapat) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': rapat.id,
      'judul_rapat': rapat.judulRapat,
      'lokasi': rapat.lokasi,
      'tujuan': rapat.tujuan,
      'kesimpulan': rapat.kesimpulan,
      'created_at': rapat.createdAt,
      'updated_at': rapat.updatedAt,
    };

    return await db.insert(
      'rapat',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Rapat.Data>> getAllRapat() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rapat');

    return List.generate(maps.length, (i) {

      return Rapat.Data(
        id: maps[i]['id'],
        judulRapat: maps[i]['judul_rapat'],
        lokasi: maps[i]['lokasi'],
        tujuan: maps[i]['tujuan'],
        kesimpulan: maps[i]['kesimpulan'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
      );
    });
  }
  
  Future<void> clearRapatTable() async {
    final db = await database;
    await db.delete('rapat');
  }

  // --------------------------------------------------------------------------
  // --- POSYANDU ---
  // --------------------------------------------------------------------------

  Future<int> insertPosyandu(Posyandu.Data posyandu) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': posyandu.id,
      'judul_posyandu': posyandu.judulPosyandu,
      'penanggung_jawab': posyandu.penanggungJawab,
      'tanggal': posyandu.tanggal,
      'lokasi': posyandu.lokasi,
      'created_at': posyandu.createdAt,
      'updated_at': posyandu.updatedAt,
    };

    return await db.insert(
      'posyandu',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Posyandu.Data>> getAllPosyandu() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posyandu');

    return List.generate(maps.length, (i) {

      return Posyandu.Data(
        id: maps[i]['id'],
        judulPosyandu: maps[i]['judul_posyandu'],
        penanggungJawab: maps[i]['penanggung_jawab'],
        tanggal: maps[i]['tanggal'],
        lokasi: maps[i]['lokasi'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
      );
    });
  }
  
  Future<void> clearPosyanduTable() async {
    final db = await database;
    await db.delete('posyandu');
  }

  // --------------------------------------------------------------------------
  // --- RONDA ---
  // --------------------------------------------------------------------------

  Future<int> insertRonda(Ronda.Data ronda) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': ronda.id,
      'tanggal': ronda.tanggal,
      'lokasi': ronda.lokasi,
      'detail': ronda.detail,
      'created_at': ronda.createdAt,
      'updated_at': ronda.updatedAt,
    };

    return await db.insert(
      'ronda',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ronda.Data>> getAllRonda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ronda');

    return List.generate(maps.length, (i) {

      return Ronda.Data(
        id: maps[i]['id'],
        tanggal: maps[i]['tanggal'],
        lokasi: maps[i]['lokasi'],
        detail: maps[i]['detail'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
      );
    });
  }
  
  Future<void> clearRondaTable() async {
    final db = await database;
    await db.delete('ronda');
  }

  
  // --------------------------------------------------------------------------
  // --- DETAIL RONDA ---
  // --------------------------------------------------------------------------

  Future<int> insertDetailRonda(Ronda.DetailRondas detailRonda) async {
    final db = await database;

    final wargaJson = detailRonda.warga != null ? jsonEncode(detailRonda.warga!.toJson()) : null;

    Map<String, dynamic> row = {
      'id': detailRonda.id,
      'id_ronda': detailRonda.idRonda,
      'id_warga': detailRonda.idWarga,
      'jam_mulai': detailRonda.jamMulai,
      'jam_selesai': detailRonda.jamSelesai,
      'area_patroli': detailRonda.areaPatroli,
      'hadir': detailRonda.hadir,
      'created_at': detailRonda.createdAt,
      'updated_at': detailRonda.updatedAt,
      'warga': wargaJson,
    };

    return await db.insert(
      'detail_ronda',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ronda.DetailRondas>> getAllDetailRonda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('detail_ronda');

    return List.generate(maps.length, (i) {
      final wargaMap = maps[i]['warga'] != null ? jsonDecode(maps[i]['warga']) : null;

      return Ronda.DetailRondas(
        id: maps[i]['id'],
        idRonda: maps[i]['id_ronda'],
        idWarga: maps[i]['id_warga'],
        jamMulai: maps[i]['jam_mulai'],
        jamSelesai: maps[i]['jam_selesai'],
        areaPatroli: maps[i]['area_patroli'],
        hadir: maps[i]['hadir'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],

        warga: wargaMap != null ? Ronda.Warga.fromJson(wargaMap) : null,
      );
    });
  }

  Future<void> clearDetailRondaTable() async {
    final db = await database;
    await db.delete('detail_ronda');
  }
  
  // --------------------------------------------------------------------------
  // --- AGENDA ---
  // --------------------------------------------------------------------------

  Future<int> insertAgenda(Agenda.Data agenda) async {
    final db = await database;

    Map<String, dynamic> row = {
      'id': agenda.id,
      'nama_agenda': agenda.namaAgenda,
      'tanggal': agenda.tanggal,
      'lokasi': agenda.lokasi,
      'created_at': agenda.createdAt,
      'updated_at': agenda.updatedAt,
    };

    return await db.insert(
      'agenda',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Agenda.Data>> getAllAgenda() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agenda');

    return List.generate(maps.length, (i) {

      return Agenda.Data(
        id: maps[i]['id'],
        namaAgenda: maps[i]['nama_agenda'],
        tanggal: maps[i]['tanggal'],
        lokasi: maps[i]['lokasi'],
        updatedAt: maps[i]['updated_at'],
        createdAt: maps[i]['created_at'],
      );
    });
  }
  
  Future<void> clearAgendaTable() async {
    final db = await database;
    await db.delete('agenda');
  }
}