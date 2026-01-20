class kasModel {
  bool? status;
  String? message;
  List<Data>? data;

  kasModel({this.status, this.message, this.data});

  kasModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? namaPengguna;
  String? email;
  String? peran;
  String? saldo;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Data(
      {this.id,
      this.namaPengguna,
      this.email,
      this.peran,
      this.saldo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaPengguna = json['nama_pengguna'];
    email = json['email'];
    peran = json['peran'];
    if (json['saldo'] != null) {
      saldo = json['saldo'].toString();
    } else {
      saldo = "0";
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_pengguna'] = this.namaPengguna;
    data['email'] = this.email;
    data['peran'] = this.peran;
    data['saldo'] = this.saldo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}