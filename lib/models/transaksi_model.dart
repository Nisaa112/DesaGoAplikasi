class transaksiModel {
  bool? status;
  String? message;
  Data? data;

  transaksiModel({this.status, this.message, this.data});

  transaksiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? kasId;
  String? kode;
  String? tanggal;
  String? jenis;
  int? jumlah;
  String? keterangan;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.kasId,
      this.kode,
      this.tanggal,
      this.jenis,
      this.jumlah,
      this.keterangan,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    kasId = json['kas_id'];
    kode = json['kode'];
    tanggal = json['tanggal'];
    jenis = json['jenis'];
    jumlah = json['jumlah'];
    keterangan = json['keterangan'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kas_id'] = this.kasId;
    data['kode'] = this.kode;
    data['tanggal'] = this.tanggal;
    data['jenis'] = this.jenis;
    data['jumlah'] = this.jumlah;
    data['keterangan'] = this.keterangan;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}