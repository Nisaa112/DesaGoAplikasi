import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/laporan_agenda_model.dart'; // Menggunakan Model Laporan yang benar

class DetailLaporanAgendaPage extends StatelessWidget {
  final LaporanAgendaModel agenda; // Menggunakan LaporanAgendaModel

  const DetailLaporanAgendaPage({super.key, required this.agenda});

  @override
  Widget build(BuildContext context) {
    // 1. Logika mengambil data dari Relasi Laporan
    String hasilKegiatan = 'Hasil kegiatan belum dilaporkan.';
    int jumlahHadir = 0;

    // Cek apakah ada data laporan di dalam agenda ini
    if (agenda.laporans != null && agenda.laporans!.isNotEmpty) {
      hasilKegiatan = agenda.laporans![0].deskripsiHasil ?? '-';
      jumlahHadir = agenda.laporans![0].jumlahHadir ?? 0;
    }

    // 2. Format Tanggal Indonesia
    String formattedDate = agenda.tanggal ?? '-';
    try {
      formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.parse(agenda.tanggal!));
    } catch (_) {}

    // 3. Format Mata Uang (Dummy 0 karena di model laporan belum ada anggaran)
    final String formattedAnggaran = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(0); 

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          agenda.namaAgenda ?? 'Detail Laporan',
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
                'Laporan Kegiatan : ${agenda.namaAgenda}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildInfoRow(Icons.calendar_today_outlined, formattedDate),
              const SizedBox(height: 12),
              // Data Jam default karena di model laporan tidak ada jam
              _buildInfoRow(Icons.access_time, '08:00 - Selesai'), 
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on_outlined, agenda.lokasi ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person_outline, 'Partisipan: $jumlahHadir Orang'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.monetization_on_outlined, 'Anggaran: $formattedAnggaran'),
              const SizedBox(height: 32),

              // Bagian ini menampilkan detail dari Model Laporan (Hasil Nyata)
              _buildSectionTitle(Icons.assignment_turned_in_outlined, 'Hasil & Kesimpulan'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  hasilKegiatan,
                  style: TextStyle(
                    // Ubah warna text jadi hitam jika ada isi, abu jika default
                    color: agenda.laporans != null && agenda.laporans!.isNotEmpty 
                        ? Colors.black87 
                        : Colors.grey,
                    height: 1.5,
                    fontSize: 15,
                  ),
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
        Icon(icon, color: const Color(0xFF4A4E8A), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4A4E8A), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Logika export di sini
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC94D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: const Text(
          'Export Data Laporan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}