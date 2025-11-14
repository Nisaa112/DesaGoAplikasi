class UserModel {
 String? message;
 List<UserDetail>? data; 

 UserModel({this.message, this.data});

 UserModel.fromJson(Map<String, dynamic> json) {
  message = json['message'];
  if (json['data'] != null) {
   data = <UserDetail>[];
   json['data'].forEach((v) {
    data!.add(new UserDetail.fromJson(v));
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

class UserDetail { 
 int? id;
 String? name;
 String? serialNumber;
 String? email;
 String? emailVerifiedAt; 
 String? role;
 String? createdAt;
 String? updatedAt;
 String? deletedAt; 

 UserDetail(
   {this.id,
   this.name,
   this.serialNumber,
   this.email,
   this.emailVerifiedAt,
   this.role,
   this.createdAt,
   this.updatedAt,
   this.deletedAt});

 UserDetail.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  serialNumber = json['serial_number'];
  email = json['email'];
  emailVerifiedAt = json['email_verified_at']?.toString();
  role = json['role'];
  createdAt = json['created_at'];
  updatedAt = json['updated_at'];
  deletedAt = json['deleted_at']?.toString();
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