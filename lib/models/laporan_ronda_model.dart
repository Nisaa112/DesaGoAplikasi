import 'ronda_model.dart'; 

class LaporanRondaModel {
  bool? success;
  String? message;
  List<LaporanRondaData>? data;

  LaporanRondaModel({this.success, this.message, this.data});

  LaporanRondaModel.fromJson(Map<String, dynamic> json) {
    success = json['success']; 
    message = json['message'];
    if (json['data'] != null) {
      data = <LaporanRondaData>[];
      json['data'].forEach((v) {
        data!.add(LaporanRondaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LaporanRondaData {
  int? id;
  String? tanggal;
  String? lokasi;
  String? detail;
  List<LaporanInsiden>? laporans;
  List<DetailRondas>? detailRondas; 

  LaporanRondaData({
    this.id,
    this.tanggal,
    this.lokasi,
    this.detail,
    this.laporans,
    this.detailRondas,
  });

  LaporanRondaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    lokasi = json['lokasi'];
    detail = json['detail'];

    if (json['laporans'] != null) {
      laporans = <LaporanInsiden>[];
      json['laporans'].forEach((v) {
        laporans!.add(LaporanInsiden.fromJson(v));
      });
    }

    if (json['details'] != null) { 
      detailRondas = <DetailRondas>[];
      json['details'].forEach((v) {
        detailRondas!.add(DetailRondas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tanggal'] = tanggal;
    data['lokasi'] = lokasi;
    data['detail'] = detail;
    if (laporans != null) {
      data['laporans'] = laporans!.map((v) => v.toJson()).toList();
    }
    if (detailRondas != null) {
      data['details'] = detailRondas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LaporanInsiden {
  int? id;
  int? idRonda;
  String? judul;
  String? deskripsi;
  String? foto;

  LaporanInsiden({this.id, this.idRonda, this.judul, this.deskripsi, this.foto});

  LaporanInsiden.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRonda = json['id_ronda'];
    judul = json['judul'];
    deskripsi = json['deskripsi'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_ronda'] = idRonda;
    data['judul'] = judul;
    data['deskripsi'] = deskripsi;
    data['foto'] = foto;
    return data;
  }
}