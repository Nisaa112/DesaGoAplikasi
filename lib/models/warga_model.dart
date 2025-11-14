import 'package:desa_go_aplikasi/models/user_model.dart';

class WargaModel {
 String? message;
 List<Data>? data; 

 WargaModel({this.message, this.data});

 WargaModel.fromJson(Map<String, dynamic> json) {
  message = json['message'];
    
  if (json['data'] != null) {
      data = (json['data'] as List)
          .map((i) => Data.fromJson(i as Map<String, dynamic>))
          .toList();
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

class Data {
 int? idRt;
 int? idUsers;
 String? nama;
 String? nik;
 String? noTelp;
 String? alamat;
 String? foto;
 String? updatedAt;
 String? createdAt;
 int? id;
 Rt? rt;
 UserDetail? user;

 Data(
   {this.idRt,
   this.idUsers,
   this.nama,
   this.nik,
   this.noTelp,
   this.alamat,
   this.foto,
   this.updatedAt,
   this.createdAt,
   this.id,
   this.rt,
   this.user});

 Data.fromJson(Map<String, dynamic> json) {
  idRt = json['id_rt'];
  idUsers = json['id_users'];
  nama = json['nama'];
  nik = json['nik'];
  noTelp = json['no_telp'];
  alamat = json['alamat'];
  foto = json['foto'];
  updatedAt = json['updated_at'];
  createdAt = json['created_at'];
  id = json['id'];
  rt = json['rt'] != null ? new Rt.fromJson(json['rt']) : null;
  user = json['user'] != null ? new UserDetail.fromJson(json['user']) : null; 
 }

 Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id_rt'] = this.idRt;
  data['id_users'] = this.idUsers;
  data['nama'] = this.nama;
  data['nik'] = this.nik;
  data['no_telp'] = this.noTelp;
  data['alamat'] = this.alamat;
  data['foto'] = this.foto;
  data['updated_at'] = this.updatedAt;
  data['created_at'] = this.createdAt;
  data['id'] = this.id;
  if (this.rt != null) {
   data['rt'] = this.rt!.toJson();
  }
  if (this.user != null) { 
      data['user'] = this.user!.toJson();
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