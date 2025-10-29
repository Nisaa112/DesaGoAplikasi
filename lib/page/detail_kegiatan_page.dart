import 'package:flutter/material.dart';

class DetailKegiatanPage extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const DetailKegiatanPage({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> getStatusInfo(String status) {
      switch (status) {
        case 'Berlangsung':
          return {'color': const Color(0xFF4CAF50), 'text': 'Berlangsung'};
        case 'Akan Datang':
          return {'color': const Color(0xFF7A73C2), 'text': 'Akan Datang'};
        case 'Selesai':
          return {'color': const Color(0xFF2C2C2C), 'text': 'Selesai'};
        default:
          return {'color': Colors.grey, 'text': 'N/A'};
      }
    }
    
    var statusInfo = getStatusInfo(kegiatan['status']!);

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: Text(
          kegiatan['nama']!, // Judul AppBar dinamis
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      kegiatan['title'] ?? 'Posyandu Balita Melati 5',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusInfo['color'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusInfo['text'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bagian Info Waktu
              _buildInfoRow(Icons.calendar_today_outlined, kegiatan['tanggal']!),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.access_time, kegiatan['waktu']!),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.timelapse_outlined, kegiatan['durasi'] ?? 'Durasi 2 Jam'),
              const SizedBox(height: 32),

              // Bagian Informasi Tambahan
              const Text('Informasi tambahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildRichTextInfo('Lokasi', kegiatan['lokasi'] ?? 'Balai RT 05/RW 06'),
              const SizedBox(height: 8),
              _buildRichTextInfo('Penanggung jawab', kegiatan['pj'] ?? 'Shaqilla salsabila'),
              const SizedBox(height: 8),
              _buildRichTextInfo('Kegiatan', kegiatan['detail_kegiatan'] ?? 'penimbangan berat badan dan pengukuran tinggi, Pemberian vitamin A dan Imunisasi, Penyuluhan gizi seimbang untuk balita'),
              const SizedBox(height: 32),
              
              // Bagian Deskripsi Tambahan
              const Text('Deskripsi Tambahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                kegiatan['deskripsi'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                style: TextStyle(color: Colors.grey.shade700, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk baris ikon dan teks
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
      ],
    );
  }
  
  Widget _buildRichTextInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.4),
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}