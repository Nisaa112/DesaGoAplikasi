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
  String? judulPosyandu;
  String? penanggungJawab;
  String? tanggal;
  String? lokasi;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.judulPosyandu,
      this.penanggungJawab,
      this.tanggal,
      this.lokasi,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    judulPosyandu = json['judul_posyandu'];
    penanggungJawab = json['penanggung_jawab'];
    tanggal = json['tanggal'];
    lokasi = json['lokasi'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['judul_posyandu'] = this.judulPosyandu;
    data['penanggung_jawab'] = this.penanggungJawab;
    data['tanggal'] = this.tanggal;
    data['lokasi'] = this.lokasi;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}