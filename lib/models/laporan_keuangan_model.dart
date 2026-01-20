class LaporanKeuanganResponse {
  bool? status;
  SummaryKeuangan? summary;
  List<TransaksiData>? data;

  LaporanKeuanganResponse({this.status, this.summary, this.data});

  factory LaporanKeuanganResponse.fromJson(Map<String, dynamic> json) {
    return LaporanKeuanganResponse(
      status: json['status'],
      summary: json['summary'] != null ? SummaryKeuangan.fromJson(json['summary']) : null,
      data: json['data'] != null
          ? (json['data'] as List).map((i) => TransaksiData.fromJson(i)).toList()
          : [],
    );
  }
}

class SummaryKeuangan {
  num? totalPemasukan; // num bisa menghandle int dan double
  num? totalPengeluaran;
  num? saldoPeriode;

  SummaryKeuangan({this.totalPemasukan, this.totalPengeluaran, this.saldoPeriode});

  factory SummaryKeuangan.fromJson(Map<String, dynamic> json) {
    return SummaryKeuangan(
      totalPemasukan: json['total_pemasukan'] ?? 0,
      totalPengeluaran: json['total_pengeluaran'] ?? 0,
      saldoPeriode: json['saldo_periode'] ?? 0,
    );
  }
}

class TransaksiData {
  int? id;
  String? kode;
  String? tanggal;
  String? jenis; // 'masuk' atau 'keluar'
  num? jumlah;
  String? keterangan;
  String? sumberAktivitas; // 'agenda', 'posyandu', dll

  TransaksiData({
    this.id,
    this.kode,
    this.tanggal,
    this.jenis,
    this.jumlah,
    this.keterangan,
    this.sumberAktivitas,
  });

  factory TransaksiData.fromJson(Map<String, dynamic> json) {
    return TransaksiData(
      id: json['id'],
      kode: json['kode'],
      tanggal: json['tanggal'],
      jenis: json['jenis'],
      jumlah: json['jumlah'],
      keterangan: json['keterangan'],
      sumberAktivitas: json['sumber_aktivitas'],
    );
  }
}