import 'package:flutter/material.dart';

class DetailLaporanPosyanduPage extends StatelessWidget {
  final String reportTitle;

  const DetailLaporanPosyanduPage({super.key, required this.reportTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          reportTitle,
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
                'Laporan Kegiatan : $reportTitle',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildInfoRow(Icons.calendar_today_outlined, 'Sabtu, 18 Okt 2025'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.access_time, '22:00 - 04:00'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person_outline, 'Koordinator Tim Ronda RT 01'),
              const SizedBox(height: 32),

              const Text('Petugas Ronda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildPetugasList(),
              const SizedBox(height: 32),
              
              _buildSectionTitle(Icons.info_outline, 'Temuan & Kejadian'),
              const SizedBox(height: 12),
              _buildTemuanItem('Situasi Aman Dan Kondusif'),
              _buildTemuanItem('Lampu jalan di jalan Melati mati, sudah dilaporkan'),
              _buildTemuanItem('Beberapa warga masih terjaga dan diberikan imbauan keamaan'),
              _buildTemuanItem('Tidak ada kejadian mencurigakan'),
              const SizedBox(height: 32),

              _buildSectionTitle(Icons.edit_note_outlined, 'Deskripsi & Hasil'),
              const SizedBox(height: 12),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 15),
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
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
      ],
    );
  }
  
  Widget _buildPetugasList() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletedText('Pak Jaka'),
              _buildBulletedText('Pak Umin'),
              _buildBulletedText('Pak Jisung'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletedText('Pak Bangchan'),
              _buildBulletedText('Pak Yunho'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletedText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.black54),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 15)),
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