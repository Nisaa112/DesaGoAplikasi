import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/laporan_posyandu_model.dart'; // Import Model Posyandu

class DetailLaporanPosyanduPage extends StatelessWidget {
  final LaporanPosyanduModel posyandu; // Data dari API

  const DetailLaporanPosyanduPage({super.key, required this.posyandu});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Data Laporan (Jika ada)
    String deskripsi = 'Belum ada deskripsi kegiatan.';
    int balita = 0;
    int bumil = 0;
    int lansia = 0;

    if (posyandu.laporans != null && posyandu.laporans!.isNotEmpty) {
      final laporan = posyandu.laporans![0];
      deskripsi = laporan.deskripsiKegiatan ?? '-';
      balita = laporan.jmlBalita ?? 0;
      bumil = laporan.jmlIbuHamil ?? 0;
      lansia = laporan.jmlLansia ?? 0;
    }
    int total = balita + bumil + lansia;

    // 2. Format Tanggal
    String formattedDate = posyandu.tanggal ?? '-';
    try {
      formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(posyandu.tanggal!));
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          posyandu.judulPosyandu ?? 'Detail Laporan',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Laporan Kegiatan : ${posyandu.judulPosyandu}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildInfoRow(Icons.calendar_today_outlined, formattedDate),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.access_time, '08:00 - 12:00'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on_outlined, posyandu.lokasi ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person_outline, 'PJ: ${posyandu.penanggungJawab ?? '-'}'),
              
              const SizedBox(height: 32),

              // Bagian ini tadinya List Petugas, saya ubah jadi Statistik Pasien
              // Tapi TAMPILANNYA TETAP SAMA (Dua Kolom)
              const Text('Statistik Pasien', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildStatistikList(balita, bumil, lansia, total),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle(Icons.info_outline, 'Rincian Kegiatan'),
              const SizedBox(height: 12),
              // List Bullet Point (Sama seperti UI asli)
              _buildTemuanItem('Pemeriksaan kesehatan rutin'),
              _buildTemuanItem('Pemberian makanan tambahan (PMT)'),
              _buildTemuanItem('Penyuluhan kesehatan ibu & anak'),
              _buildTemuanItem('Total partisipan mencapai $total orang'),
              
              const SizedBox(height: 32),

              _buildSectionTitle(Icons.edit_note_outlined, 'Deskripsi & Hasil'),
              const SizedBox(height: 12),
              Text(
                deskripsi,
                style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 15),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),

              _buildExportButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text, 
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  // Widget ini dimodifikasi isinya, tapi struktur layoutnya SAMA PERSIS dengan _buildPetugasList
  Widget _buildStatistikList(int balita, int bumil, int lansia, int total) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletedText('Balita: $balita Anak'),
              _buildBulletedText('Ibu Hamil: $bumil Orang'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletedText('Lansia: $lansia Orang'),
              _buildBulletedText('Total: $total Orang', isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletedText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: isBold ? const Color(0xFF4A4E8A) : Colors.black54),
          const SizedBox(width: 8),
          Text(
            text, 
            style: TextStyle(
              fontSize: 15, 
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF4A4E8A) : Colors.black87
            )
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 24),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTemuanItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(Icons.circle, size: 6, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC94D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Export Data',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}