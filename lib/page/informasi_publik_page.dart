import 'package:desa_go_aplikasi/page/info_warga_page.dart';
import 'package:desa_go_aplikasi/page/struktur_page.dart';
import 'package:flutter/material.dart';

class InformasiPublikPage extends StatelessWidget {
  const InformasiPublikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        // Halaman utama tidak perlu tombol kembali
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: const Text(
          'Informasi Publik',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildNavigationButton(
                context: context,
                label: 'Data Warga',
                onTap: () {
                  // Navigasi ke halaman InfoWargaPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoWargaPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildNavigationButton(
                context: context,
                label: 'Struktur Keanggotaan',
                onTap: () {
                  // Navigasi ke halaman StrukturPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StrukturPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat tombol navigasi
  Widget _buildNavigationButton({required BuildContext context, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}