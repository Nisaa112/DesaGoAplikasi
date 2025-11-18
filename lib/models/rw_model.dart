class RwModel {
  String? message;
  List<Rw>? data;

  RwModel({this.message, this.data});

  RwModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Rw>[];
      json['data'].forEach((v) {
        data!.add(new Rw.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rw {
  int? id;
  String? namaRw;
  String? createdAt;
  String? updatedAt;

  Rw({this.id, this.namaRw, this.createdAt, this.updatedAt});

  Rw.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaRw = json['nama_rw'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_rw'] = this.namaRw;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}