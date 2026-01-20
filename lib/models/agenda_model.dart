// lib/models/agenda_model.dart

// Model ini dirancang untuk menangani respons API yang berisi daftar agenda.
class AgendaModel {
  bool? success;
  String? message;
  List<Data>? data;

  AgendaModel({this.success, this.message, this.data});

  AgendaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      // Iterasi melalui setiap item dalam array 'data' dari JSON
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Model untuk satu item Agenda
class Data {
  int? id;
  String? namaAgenda;
  String? tanggal;
  String? lokasi;
  PenanggungJawabWarga? penanggungJawab; // Menggunakan model objek, bukan String
  int? idKas;
  int? anggaran;
  String? hasil;
  String? jamMulai;
  String? status;
  String? keterangan;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.namaAgenda,
    this.tanggal,
    this.lokasi,
    this.penanggungJawab,
    this.idKas,
    this.anggaran,
    this.hasil,
    this.jamMulai,
    this.status,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  // Konstruktor factory untuk membuat objek Data dari JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      namaAgenda: json['nama_agenda'],
      tanggal: json['tanggal'],
      lokasi: json['lokasi'],
      idKas: json['id_kas'] != null ? int.tryParse(json['id_kas'].toString()) : null,
      anggaran: json['anggaran'] != null ? int.tryParse(json['anggaran'].toString()) : null,
      
      // LOGIKA CERDAS:
      // Memeriksa apakah 'penanggung_jawab' adalah objek Map (berisi ID dan nama)
      // atau hanya sebuah nilai (ID).
      penanggungJawab: json['penanggung_jawab'] != null
          ? (json['penanggung_jawab'] is Map
              ? PenanggungJawabWarga.fromJson(json['penanggung_jawab'])
              // Jika bukan Map, kita asumsikan itu adalah ID.
              // Kita buat objek PenanggungJawabWarga hanya dengan ID.
              // UI nanti yang akan mencari namanya menggunakan ID ini.
              : PenanggungJawabWarga(id: int.tryParse(json['penanggung_jawab'].toString())))
          : null,

      hasil: json['hasil'],
      jamMulai: json['jam_mulai'],
      status: json['status'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method untuk mengubah objek Data menjadi JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nama_agenda'] = this.namaAgenda;
    data['tanggal'] = this.tanggal;
    data['lokasi'] = this.lokasi;
    
    // PENTING: Saat mengirim data ke API, backend hanya butuh ID-nya.
    // Kode ini memastikan hanya ID yang dikirim.
    if (this.penanggungJawab != null) {
      data['penanggung_jawab'] = this.penanggungJawab!.id;
    }

    data['id_kas'] = this.idKas;
    data['anggaran'] = this.anggaran;
    data['hasil'] = this.hasil;
    data['jam_mulai'] = this.jamMulai;
    data['status'] = this.status;
    data['keterangan'] = this.keterangan;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

// Model kecil khusus untuk menampung data Penanggung Jawab
class PenanggungJawabWarga {
  int? id;
  String? nama;

  PenanggungJawabWarga({this.id, this.nama});

  // Konstruktor factory untuk membuat objek dari JSON
  factory PenanggungJawabWarga.fromJson(Map<String, dynamic> json) {
    return PenanggungJawabWarga(
      id: json['id'],
      nama: json['nama'], // Membaca key 'nama' yang benar dari API
    );
  }

  // Method untuk mengubah objek menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nama'] = this.nama;
    return data;
  }
}