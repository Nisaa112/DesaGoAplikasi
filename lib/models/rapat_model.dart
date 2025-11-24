class RapatModel {
  bool? success;
  String? message;
  List<Data>? data;

  RapatModel({this.success, this.message, this.data});

  RapatModel.fromJson(Map<String, dynamic> json) {
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
  String? judulRapat;
  String? lokasi;
  String? tujuan;
  String? kesimpulan;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.judulRapat,
      this.lokasi,
      this.tujuan,
      this.kesimpulan,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judulRapat = json['judul_rapat'];
    lokasi = json['lokasi'];
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
    data['tujuan'] = this.tujuan;
    data['kesimpulan'] = this.kesimpulan;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}