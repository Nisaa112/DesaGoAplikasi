class PengaduanModel {
  String? message;
  List<Data>? data;

  PengaduanModel({this.message, this.data});

  PengaduanModel.fromJson(Map<String, dynamic> json) {
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? recipient;
  String? kategori;
  String? judul;
  String? pesan;
  String? status;
  Null? assignedTo;
  bool? isPublic;
  int? priority;
  Null? response;
  Null? respondedAt;
  String? ipAddress;
  String? userAgent;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  User? user;
  Null? assignee;

  Data(
      {this.id,
      this.userId,
      this.recipient,
      this.kategori,
      this.judul,
      this.pesan,
      this.status,
      this.assignedTo,
      this.isPublic,
      this.priority,
      this.response,
      this.respondedAt,
      this.ipAddress,
      this.userAgent,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user,
      this.assignee});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    recipient = json['recipient'];
    kategori = json['kategori'];
    judul = json['judul'];
    pesan = json['pesan'];
    status = json['status'];
    assignedTo = json['assigned_to'];
    isPublic = json['is_public'];
    priority = json['priority'];
    response = json['response'];
    respondedAt = json['responded_at'];
    ipAddress = json['ip_address'];
    userAgent = json['user_agent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    assignee = json['assignee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['recipient'] = this.recipient;
    data['kategori'] = this.kategori;
    data['judul'] = this.judul;
    data['pesan'] = this.pesan;
    data['status'] = this.status;
    data['assigned_to'] = this.assignedTo;
    data['is_public'] = this.isPublic;
    data['priority'] = this.priority;
    data['response'] = this.response;
    data['responded_at'] = this.respondedAt;
    data['ip_address'] = this.ipAddress;
    data['user_agent'] = this.userAgent;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['assignee'] = this.assignee;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? serialNumber;
  String? email;
  Null? emailVerifiedAt;
  String? role;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  User(
      {this.id,
      this.name,
      this.serialNumber,
      this.email,
      this.emailVerifiedAt,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serialNumber = json['serial_number'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['serial_number'] = this.serialNumber;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}