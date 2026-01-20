class LaporanRondaModel {
  int? id;
  String? tanggal;
  String? lokasi;
  String? detail;
  List<DetailPetugas>? petugas;
  List<LaporanInsiden>? insiden;

  LaporanRondaModel({
    this.id,
    this.tanggal,
    this.lokasi,
    this.detail,
    this.petugas,
    this.insiden,
  });

  factory LaporanRondaModel.fromJson(Map<String, dynamic> json) {
    return LaporanRondaModel(
      id: json['id'],
      tanggal: json['tanggal'],
      lokasi: json['lokasi'],
      detail: json['detail'],
      // Relasi ke detail_ronda (Petugas)
      petugas: json['details'] != null
          ? (json['details'] as List).map((i) => DetailPetugas.fromJson(i)).toList()
          : [],
      // Relasi ke laporan_insiden (Kejadian)
      insiden: json['laporans'] != null
          ? (json['laporans'] as List).map((i) => LaporanInsiden.fromJson(i)).toList()
          : [],
    );
  }
}

class DetailPetugas {
  int? id;
  String? namaWarga;
  int? hadir; // 1 = Hadir, 0 = Tidak

  DetailPetugas({this.id, this.namaWarga, this.hadir});

  factory DetailPetugas.fromJson(Map<String, dynamic> json) {
    return DetailPetugas(
      id: json['id'],
      namaWarga: json['warga'] != null ? json['warga']['nama'] : 'Warga Hapus',
      hadir: json['hadir'] ?? 0,
    );
  }
}

class LaporanInsiden {
  int? id;
  String? judul;
  String? deskripsi;

  LaporanInsiden({this.id, this.judul, this.deskripsi});

  factory LaporanInsiden.fromJson(Map<String, dynamic> json) {
    return LaporanInsiden(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'], // di migrasi namanya deskripsi
    );
  }
}