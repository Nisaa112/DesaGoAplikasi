import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  final List<Map<String, dynamic>> _dummyNotifikasiList = const [
    {
      'judul': 'Sebentar lagi jadwal Ronda!',
      'deskripsi': 'Pukul 22.00 mulai jadwal ronda, lokasi nya di Pos Ronda',
      'waktu': '2j',
      'ikon': Icons.home_filled, // Ikon untuk Ronda (Asumsi Ikon Rumah/Keamanan)
      'ikon_warna': Color(0xFFFFC212), // Kuning
    },
    {
      'judul': 'Siap-siap ikut Posyandu ya...',
      'deskripsi': 'Pukul 10.00 hari ini akan dilaksanakan posyandu, lokasi nya di Puskesmas Citra',
      'waktu': '9j',
      'ikon': Icons.favorite, // Ikon untuk Posyandu (Kesehatan)
      'ikon_warna': Color(0xFFE57373), // Merah Muda
    },
    {
      'judul': 'Mau ada agenda baru nih',
      'deskripsi': 'Tgl 17 Agustus akan dilaksanakan Acara 17 Agustus di sekitar lapangan',
      'waktu': '12j',
      'ikon': Icons.calendar_today, // Ikon untuk Agenda/Acara
      'ikon_warna': Color(0xFF9370DB), // Ungu Muda
    },
    {
      'judul': 'Sebentar lagi Rapat!!',
      'deskripsi': 'Hari ini pukul 15.00 para pejabat dan perwakilan warga akan melaksanakan rapat di balai desa',
      'waktu': '2 hr',
      'ikon': Icons.meeting_room, // Ikon untuk Rapat (Asumsi Ikon Rapat/Gedung)
      'ikon_warna': Color(0xFF4A4E8A), // Ungu Gelap
    },
    {
      'judul': 'Warga baru saja melakukan pengaduan, cek yuk?',
      'deskripsi': 'Warga baru saja melakukan pengaduan publik mengenai Fasilitas',
      'waktu': '2 hr',
      'ikon': Icons.announcement, // Ikon untuk Pengaduan
      'ikon_warna': Color(0xFF333333), // Hitam/Abu-abu gelap
    },
  ];

  // --- Widget Helper untuk Ikon Notifikasi (Sesuai Gambar) ---
  Widget _buildNotifIcon({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // Latar belakang lebih transparan
        borderRadius: BorderRadius.circular(10), // Sudut membulat
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            itemCount: _dummyNotifikasiList.length,
            itemBuilder: (context, index) {
              final notif = _dummyNotifikasiList[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                leading: _buildNotifIcon(
                  icon: notif['ikon'],
                  color: notif['ikon_warna'],
                ),
                title: Text(
                  notif['judul'],
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                subtitle: Text(
                  notif['deskripsi'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  notif['waktu'],
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                onTap: () {
                  // Aksi ketika notifikasi diklik
                  print('Notifikasi diklik: ${notif['judul']}');
                },
              );
            },
            separatorBuilder: (context, index) {
              // Garis pemisah di antara item, tetapi tidak di paling bawah.
              return const Divider(height: 1, indent: 16, endIndent: 16);
            },
          ),
        ),
      ),
    );
  }
}