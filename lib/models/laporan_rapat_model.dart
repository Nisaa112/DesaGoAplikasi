class LaporanRapatModel {
  int? id;
  String? judulRapat;
  String? lokasi;
  String? tujuan;
  String? tanggalDibuat; // created_at
  List<HasilRapat>? laporans;

  LaporanRapatModel({
    this.id,
    this.judulRapat,
    this.lokasi,
    this.tujuan,
    this.tanggalDibuat,
    this.laporans,
  });

  factory LaporanRapatModel.fromJson(Map<String, dynamic> json) {
    return LaporanRapatModel(
      id: json['id'],
      judulRapat: json['judul_rapat'],
      lokasi: json['lokasi'],
      tujuan: json['tujuan'],
      tanggalDibuat: json['created_at'], // Mengambil timestamp pembuatan
      laporans: json['laporans'] != null
          ? (json['laporans'] as List).map((i) => HasilRapat.fromJson(i)).toList()
          : [],
    );
  }
}

class HasilRapat {
  int? id;
  String? hasilKeputusan;
  int? jumlahHadir;

  HasilRapat({this.id, this.hasilKeputusan, this.jumlahHadir});

  factory HasilRapat.fromJson(Map<String, dynamic> json) {
    return HasilRapat(
      id: json['id'],
      hasilKeputusan: json['hasil_keputusan'],
      jumlahHadir: json['jumlah_hadir'],
    );
  }
}