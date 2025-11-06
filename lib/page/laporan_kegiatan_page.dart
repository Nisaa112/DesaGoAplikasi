// [PERUBAHAN 1] Import halaman detail yang baru
import 'package:desa_go_aplikasi/page/detail_laporan_kegiatan_page.dart';
import 'package:flutter/material.dart';

class LaporanKegiatanPage extends StatelessWidget {
  const LaporanKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk daftar laporan
    final List<String> laporanList = [
      'Pembangunan Pos Ronda',
      'Acara 17 Agustus 2025',
      'Pengajian Bersama',
      'Kesehatan Ibu & Anak',
      'Ronda Malam',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text(
          'Laporan Kegiatan',
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            itemCount: laporanList.length,
            itemBuilder: (context, index) {
              final laporanTitle = laporanList[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(
                  laporanTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // [PERUBAHAN 2] Tambahkan aksi navigasi di sini
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Kirim judul laporan ke halaman detail
                      builder: (context) => DetailLaporanKegiatanPage(reportTitle: laporanTitle),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1, indent: 16, endIndent: 16);
            },
          ),
        ),
      ),
    );
  }
}