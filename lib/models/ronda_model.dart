class RondaModel {
  bool? success;
  String? message;
  List<Data>? data;

  RondaModel({this.success, this.message, this.data});

  RondaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? tanggal;
  String? lokasi;
  String? detail;
  String? createdAt;
  String? updatedAt;
  List<DetailRondas>? detailRondas;

  Data(
      {this.id,
      this.tanggal,
      this.lokasi,
      this.detail,
      this.createdAt,
      this.updatedAt,
      this.detailRondas});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    lokasi = json['lokasi'];
    detail = json['detail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['detail_rondas'] != null) {
      detailRondas = <DetailRondas>[];
      json['detail_rondas'].forEach((v) {
        detailRondas!.add(new DetailRondas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tanggal'] = this.tanggal;
    data['lokasi'] = this.lokasi;
    data['detail'] = this.detail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.detailRondas != null) {
      data['detail_rondas'] =
          this.detailRondas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailRondas {
  int? id;
  int? idRonda;
  int? idWarga;
  String? jamMulai;
  String? jamSelesai;
  String? areaPatroli;
  int? hadir;
  String? createdAt;
  String? updatedAt;
  Warga? warga;

  DetailRondas(
      {this.id,
      this.idRonda,
      this.idWarga,
      this.jamMulai,
      this.jamSelesai,
      this.areaPatroli,
      this.hadir,
      this.createdAt,
      this.updatedAt,
      this.warga});

  DetailRondas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRonda = json['id_ronda'];
    idWarga = json['id_warga'];
    jamMulai = json['jam_mulai'];
    jamSelesai = json['jam_selesai'];
    areaPatroli = json['area_patroli'];
    hadir = json['hadir'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warga = json['warga'] != null ? new Warga.fromJson(json['warga']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_ronda'] = this.idRonda;
    data['id_warga'] = this.idWarga;
    data['jam_mulai'] = this.jamMulai;
    data['jam_selesai'] = this.jamSelesai;
    data['area_patroli'] = this.areaPatroli;
    data['hadir'] = this.hadir;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.warga != null) {
      data['warga'] = this.warga!.toJson();
    }
    return data;
  }
}

class Warga {
  int? id;
  int? idRt;
  int? idUsers;
  String? nama;
  String? nik;
  String? noTelp;
  String? alamat;
  Null? foto;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Warga(
      {this.id,
      this.idRt,
      this.idUsers,
      this.nama,
      this.nik,
      this.noTelp,
      this.alamat,
      this.foto,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Warga.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRt = json['id_rt'];
    idUsers = json['id_users'];
    nama = json['nama'];
    nik = json['nik'];
    noTelp = json['no_telp'];
    alamat = json['alamat'];
    foto = json['foto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_rt'] = this.idRt;
    data['id_users'] = this.idUsers;
    data['nama'] = this.nama;
    data['nik'] = this.nik;
    data['no_telp'] = this.noTelp;
    data['alamat'] = this.alamat;
    data['foto'] = this.foto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}