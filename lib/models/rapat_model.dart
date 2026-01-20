class RapatModel {
  bool? success;
  String? message;
  Data? data;

  RapatModel({this.success, this.message, this.data});

  RapatModel.fromJson(Map<String, dynamic> json) {
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
  String? judulRapat;
  String? lokasi;
  String? tanggal;
  String? penanggungJawab;
  int? idKas;
  int? anggaran;
  String? jamMulai;
  String? status;
  String? tujuan;
  String? kesimpulan;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.judulRapat,
    this.lokasi,
    this.tanggal,
    this.penanggungJawab,
    this.idKas,
    this.anggaran,
    this.jamMulai,
    this.status,
    this.tujuan,
    this.kesimpulan,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judulRapat = json['judul_rapat'];
    lokasi = json['lokasi'];
    tanggal = json['tanggal'];
    idKas = json['id_kas'] != null ? int.tryParse(json['id_kas'].toString()) : null;
    anggaran = json['anggaran'] != null ? int.tryParse(json['anggaran'].toString()) : null;
    
    // Perbaikan untuk penanggung_jawab yang bisa berupa Map (Objek) atau String
    if (json['penanggung_jawab'] is Map) {
       penanggungJawab = json['penanggung_jawab']['name']?.toString() ?? "Admin";
    } else {
       penanggungJawab = json['penanggung_jawab']?.toString();
    }
    jamMulai = json['jam_mulai'];
    status = json['status'];
    tujuan = json['tujuan'];
    kesimpulan = json['kesimpulan'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul_rapat'] = this.judulRapat;
    data['lokasi'] = this.lokasi;
    data['tanggal'] = this.tanggal;
    data['penanggung_jawab'] = this.penanggungJawab;
    data['id_kas'] = this.idKas;
    data['anggaran'] = this.anggaran;
    data['jam_mulai'] = this.jamMulai;
    data['status'] = this.status;
    data['tujuan'] = this.tujuan;
    data['kesimpulan'] = this.kesimpulan;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}