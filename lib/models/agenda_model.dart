class AgendaModel {
  bool? success;
  String? message;
  Data? data; // Diubah dari List menjadi objek tunggal sesuai JSON baru

  AgendaModel({this.success, this.message, this.data});

  AgendaModel.fromJson(Map<String, dynamic> json) {
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
  String? namaAgenda;
  String? tanggal;
  String? lokasi;
  String? penanggungJawab;
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaAgenda = json['nama_agenda'];
    tanggal = json['tanggal'];
    lokasi = json['lokasi'];
    penanggungJawab = json['penanggung_jawab'];
    idKas = json['id_kas'];
    anggaran = json['anggaran'];
    hasil = json['hasil'];
    jamMulai = json['jam_mulai'];
    status = json['status'];
    keterangan = json['keterangan'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_agenda'] = this.namaAgenda;
    data['tanggal'] = this.tanggal;
    data['lokasi'] = this.lokasi;
    data['penanggung_jawab'] = this.penanggungJawab;
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