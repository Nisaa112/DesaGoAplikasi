class RtModel {
  String? message;
  List<Rt>? data;

  RtModel({this.message, this.data});

  RtModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Rt>[];
      json['data'].forEach((v) {
        data!.add(new Rt.fromJson(v));
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

class Rt {
  int? id;
  String? namaRt;
  int? idRw;
  String? createdAt;
  String? updatedAt;
  Rw? rw;

  Rt(
      {this.id,
      this.namaRt,
      this.idRw,
      this.createdAt,
      this.updatedAt,
      this.rw});

  Rt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaRt = json['nama_rt'];
    idRw = json['id_rw'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rw = json['rw'] != null ? new Rw.fromJson(json['rw']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_rt'] = this.namaRt;
    data['id_rw'] = this.idRw;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.rw != null) {
      data['rw'] = this.rw!.toJson();
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