class LaporanAgendaModel {
  int? id;
  String? namaAgenda;
  String? tanggal;
  String? lokasi;
  List<HasilAgenda>? laporans;

  LaporanAgendaModel({this.id, this.namaAgenda, this.tanggal, this.lokasi, this.laporans});

  factory LaporanAgendaModel.fromJson(Map<String, dynamic> json) {
    return LaporanAgendaModel(
      id: json['id'],
      namaAgenda: json['nama_agenda'],
      tanggal: json['tanggal'],
      lokasi: json['lokasi'],
      laporans: json['laporans'] != null
          ? (json['laporans'] as List).map((i) => HasilAgenda.fromJson(i)).toList()
          : [],
    );
  }
}

class HasilAgenda {
  int? id;
  String? deskripsiHasil;
  int? jumlahHadir;

  HasilAgenda({this.id, this.deskripsiHasil, this.jumlahHadir});

  factory HasilAgenda.fromJson(Map<String, dynamic> json) {
    return HasilAgenda(
      id: json['id'],
      deskripsiHasil: json['deskripsi_hasil'], // Sesuai migrasi
      jumlahHadir: json['jumlah_hadir'],
    );
  }
}