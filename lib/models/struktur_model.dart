import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/models/jabatan_model.dart' as JabatanModel;

class StrukturModel {
  bool? success;
  String? message;
  List<Data>? data;

  StrukturModel({this.success, this.message, this.data});

  StrukturModel.fromJson(Map<String, dynamic> json) {
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
  int? idRw;
  int? idRt;
  int? idJabatan;
  String? nama;
  String? nik;
  String? alamat;
  String? noTelp;
  String? foto;
  String? createdAt;
  String? updatedAt;
  RwModel.Data? rw;
  RtModel.Data? rt;
  JabatanModel.Data? jabatan; 

  Data(
    {this.id,
    this.idRw,
    this.idRt,
    this.idJabatan,
    this.nama,
    this.nik,
    this.alamat,
    this.noTelp,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.rw,
    this.rt,
    this.jabatan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRw = json['id_rw'];
    idRt = json['id_rt'];
    idJabatan = json['id_jabatan'];
    nama = json['nama'];
    nik = json['nik'];
    alamat = json['alamat'];
    noTelp = json['no_telp']?.toString(); 
    foto = json['foto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    
    rw = json['rw'] != null ? RwModel.Data.fromJson(json['rw']) : null;
    rt = json['rt'] != null ? RtModel.Data.fromJson(json['rt']) : null;
    jabatan = json['jabatan'] != null ? JabatanModel.Data.fromJson(json['jabatan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_rw'] = this.idRw;
    data['id_rt'] = this.idRt;
    data['id_jabatan'] = this.idJabatan;
    data['nama'] = this.nama;
    data['nik'] = this.nik;
    data['alamat'] = this.alamat;
    data['no_telp'] = this.noTelp;
    data['foto'] = this.foto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    
    if (this.rw != null) {
      data['rw'] = this.rw!.toJson();
    }
    if (this.rt != null) {
      data['rt'] = this.rt!.toJson();
    }
    if (this.jabatan != null) {
      data['jabatan'] = this.jabatan!.toJson();
    }
    return data;
  }
}