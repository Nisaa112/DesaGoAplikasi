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
  String? namaAgenda;
  String? tanggal;
  String? lokasi;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.namaAgenda,
      this.tanggal,
      this.lokasi,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaAgenda = json['nama_agenda'];
    tanggal = json['tanggal'];
    lokasi = json['lokasi'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_agenda'] = this.namaAgenda;
    data['tanggal'] = this.tanggal;
    data['lokasi'] = this.lokasi;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}