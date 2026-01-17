class RondaModel {
  bool? success; // Diubah dari status ke success sesuai JSON
  String? message;
  List<RondaData>? data;

  RondaModel({this.success, this.message, this.data});

  RondaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RondaData>[];
      json['data'].forEach((v) {
        data!.add(RondaData.fromJson(v));
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

class RondaData {
  int? id;
  int? idKas;
  int? anggaran;
  String? tanggal;
  String? lokasi;
  String? detail;
  String? hasil;
  String? createdAt;
  String? updatedAt;
  int? penanggungJawab;
  Kas? kas; // Relasi ke Kas
  List<DetailRondas>? detailRondas;

  RondaData({
    this.id,
    this.idKas,
    this.anggaran,
    this.tanggal,
    this.lokasi,
    this.detail,
    this.hasil,
    this.createdAt,
    this.updatedAt,
    this.penanggungJawab,
    this.kas,
    this.detailRondas,
  });

  RondaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idKas = json['id_kas'];
    anggaran = json['anggaran'];
    tanggal = json['tanggal'];
    lokasi = json['lokasi'];
    detail = json['detail'];
    hasil = json['hasil'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    penanggungJawab = json['penanggung_jawab'];
    kas = json['kas'] != null ? Kas.fromJson(json['kas']) : null;
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
    data['id_kas'] = idKas;
    data['anggaran'] = anggaran;
    data['tanggal'] = tanggal;
    data['lokasi'] = lokasi;
    data['detail'] = detail;
    data['hasil'] = hasil;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['penanggung_jawab'] = penanggungJawab;
    if (kas != null) {
      data['kas'] = kas!.toJson();
    }
    if (detailRondas != null) {
      data['details'] = detailRondas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Kas {
  int? id;
  String? namaPengguna;
  String? email;
  String? peran;
  String? saldo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Kas({
    this.id,
    this.namaPengguna,
    this.email,
    this.peran,
    this.saldo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Kas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaPengguna = json['nama_pengguna'];
    email = json['email'];
    peran = json['peran'];
    saldo = json['saldo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_pengguna'] = namaPengguna;
    data['email'] = email;
    data['peran'] = peran;
    data['saldo'] = saldo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
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
  WargaRonda? warga;

  DetailRondas({
    this.id,
    this.idRonda,
    this.idWarga,
    this.jamMulai,
    this.jamSelesai,
    this.areaPatroli,
    this.hadir,
    this.createdAt,
    this.updatedAt,
    this.warga,
  });

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
    warga = json['warga'] != null ? WargaRonda.fromJson(json['warga']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_ronda'] = idRonda;
    data['id_warga'] = idWarga;
    data['jam_mulai'] = jamMulai;
    data['jam_selesai'] = jamSelesai;
    data['area_patroli'] = areaPatroli;
    data['hadir'] = hadir;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (warga != null) {
      data['warga'] = warga!.toJson();
    }
    return data;
  }
}

class WargaRonda {
  int? id;
  String? nama;
  String? nik;
  String? alamat;
  String? foto;

  WargaRonda({this.id, this.nama, this.nik, this.alamat, this.foto});

  WargaRonda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    nik = json['nik'];
    alamat = json['alamat'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['nik'] = nik;
    data['alamat'] = alamat;
    data['foto'] = foto;
    return data;
  }
}