class UserModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  UserDetail? user;

  UserModel({this.accessToken, this.tokenType, this.expiresIn, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? UserDetail.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserDetail {
  int? id;
  int? idRw; // <--- PASTIKAN ADA INI
  String? name;
  String? serialNumber;
  String? email;
  String? role;

  UserDetail({
    this.id,
    this.idRw, // <--- PASTIKAN ADA INI
    this.name,
    this.serialNumber,
    this.email,
    this.role,
  });

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // Ambil dari 'id_rw' (sesuai JSON Laravel kamu)
    idRw = json['id_rw']; 
    name = json['name'];
    serialNumber = json['serial_number'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_rw': idRw,
      'name': name,
      'serial_number': serialNumber,
      'email': email,
      'role': role,
    };
  }
}