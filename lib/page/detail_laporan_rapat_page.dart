import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/laporan_rapat_model.dart'; // Import Model yang benar

class DetailLaporanRapatPage extends StatelessWidget {
  final LaporanRapatModel rapat; // Terima data dari halaman sebelumnya

  const DetailLaporanRapatPage({super.key, required this.rapat});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Data Hasil Laporan (Jika ada)
    String hasilKeputusan = 'Belum ada notulensi rapat.';
    int jumlahHadir = 0;

    if (rapat.laporans != null && rapat.laporans!.isNotEmpty) {
      hasilKeputusan = rapat.laporans![0].hasilKeputusan ?? '-';
      jumlahHadir = rapat.laporans![0].jumlahHadir ?? 0;
    }

    // 2. Format Tanggal
    String formattedDate = rapat.tanggalDibuat ?? '-';
    try {
      formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(rapat.tanggalDibuat!));
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          rapat.judulRapat ?? 'Detail Rapat',
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
                'Laporan Kegiatan : ${rapat.judulRapat}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildInfoRow(Icons.calendar_today_outlined, formattedDate),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on_outlined, rapat.lokasi ?? 'Lokasi tidak ada'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.groups_2_outlined, 'Jumlah Hadir: $jumlahHadir Orang'),
              const SizedBox(height: 32),

              // Bagian Tujuan Rapat
              _buildSectionTitle(Icons.flag_outlined, 'Tujuan Rapat'),
              const SizedBox(height: 12),
              Text(
                rapat.tujuan ?? 'Tidak ada tujuan khusus.',
                style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 15),
              ),
              const SizedBox(height: 32),
              
              // Bagian Hasil / Notulensi
              _buildSectionTitle(Icons.assignment_turned_in_outlined, 'Hasil Keputusan & Notulensi'),
              const SizedBox(height: 12),
              
              // Menampilkan hasil dalam Container agar rapi (sesuai style UI referensi)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     // Jika teks panjang, kita split jadi paragraf atau list item sederhana
                     // Di sini saya tampilkan sebagai teks biasa agar fleksibel
                     Text(
                        hasilKeputusan,
                        style: TextStyle(
                          color: rapat.laporans != null && rapat.laporans!.isNotEmpty 
                              ? Colors.black87 
                              : Colors.grey,
                          height: 1.5,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                  ],
                ),
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
  
  // Widget Title Section (Sama persis)
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 24),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget Button Export (Sama persis)
  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Logika Export PDF bisa ditambahkan nanti
        },
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