class LaporanPosyanduModel {
  int? id;
  String? judulPosyandu;
  String? tanggal;
  String? lokasi;
  // Penanggung jawab (Relasi Warga)
  String? penanggungJawab; 
  List<HasilPosyandu>? laporans;

  LaporanPosyanduModel({
    this.id,
    this.judulPosyandu,
    this.tanggal,
    this.lokasi,
    this.penanggungJawab,
    this.laporans,
  });

  factory LaporanPosyanduModel.fromJson(Map<String, dynamic> json) {
    return LaporanPosyanduModel(
      id: json['id'],
      judulPosyandu: json['judul_posyandu'],
      tanggal: json['tanggal'],
      lokasi: json['lokasi'],
      // Ambil nama dari relasi warga (jika di-load di controller)
      penanggungJawab: json['warga'] != null ? json['warga']['nama'] : '-',
      laporans: json['laporans'] != null
          ? (json['laporans'] as List).map((i) => HasilPosyandu.fromJson(i)).toList()
          : [],
    );
  }
}

class HasilPosyandu {
  int? id;
  String? deskripsiKegiatan;
  int? jmlBalita;
  int? jmlIbuHamil;
  int? jmlLansia;

  HasilPosyandu({
    this.id,
    this.deskripsiKegiatan,
    this.jmlBalita,
    this.jmlIbuHamil,
    this.jmlLansia,
  });

  factory HasilPosyandu.fromJson(Map<String, dynamic> json) {
    return HasilPosyandu(
      id: json['id'],
      deskripsiKegiatan: json['deskripsi_kegiatan'],
      jmlBalita: json['jumlah_balita'] ?? 0,
      jmlIbuHamil: json['jumlah_ibu_hamil'] ?? 0,
      jmlLansia: json['jumlah_lansia'] ?? 0,
    );
  }
}