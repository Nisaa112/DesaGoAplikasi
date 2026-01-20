class PosyanduModel {
  bool? success;
  String? message;
  Data? data;

  PosyanduModel({this.success, this.message, this.data});

  PosyanduModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? idKas;
  int? anggaran;
  String? judulPosyandu;
  String? penanggungJawab;
  String? tanggal;
  String? keterangan;
  String? lokasi;
  String? jamMulai;
  String? status;
  int? totalDiperiksa;
  int? totalSehat;
  int? totalPerluTindakLanjut;
  int? totalDiimunisasi;
  String? ringkasanHasil;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.idKas,
    this.anggaran,
    this.judulPosyandu,
    this.penanggungJawab,
    this.tanggal,
    this.keterangan,
    this.lokasi,
    this.jamMulai,
    this.status,
    this.totalDiperiksa,
    this.totalSehat,
    this.totalPerluTindakLanjut,
    this.totalDiimunisasi,
    this.ringkasanHasil,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idKas = json['id_kas'] != null ? int.tryParse(json['id_kas'].toString()) : null;
    anggaran = json['anggaran'] != null ? int.tryParse(json['anggaran'].toString()) : null;
    judulPosyandu = json['judul_posyandu'];
    
    // Perbaikan untuk penanggung_jawab yang bisa berupa Map (Objek) atau String
    if (json['penanggung_jawab'] is Map) {
       penanggungJawab = json['penanggung_jawab']['name']?.toString() ?? "Admin";
    } else {
       penanggungJawab = json['penanggung_jawab']?.toString();
    }
    tanggal = json['tanggal'];
    keterangan = json['keterangan'];
    lokasi = json['lokasi'];
    jamMulai = json['jam_mulai'];
    status = json['status'];
    totalDiperiksa = json['total_diperiksa'];
    totalSehat = json['total_sehat'];
    totalPerluTindakLanjut = json['total_perlu_tindak_lanjut'];
    totalDiimunisasi = json['total_diimunisasi'];
    ringkasanHasil = json['ringkasan_hasil'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_kas'] = this.idKas;
    data['anggaran'] = this.anggaran;
    data['judul_posyandu'] = this.judulPosyandu;
    data['penanggung_jawab'] = this.penanggungJawab;
    data['tanggal'] = this.tanggal;
    data['keterangan'] = this.keterangan;
    data['lokasi'] = this.lokasi;
    data['jam_mulai'] = this.jamMulai;
    data['status'] = this.status;
    data['total_diperiksa'] = this.totalDiperiksa;
    data['total_sehat'] = this.totalSehat;
    data['total_perlu_tindak_lanjut'] = this.totalPerluTindakLanjut;
    data['total_diimunisasi'] = this.totalDiimunisasi;
    data['ringkasan_hasil'] = this.ringkasanHasil;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}