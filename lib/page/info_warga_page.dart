import 'package:desa_go_aplikasi/page/identitas_warga_page.dart';
import 'package:flutter/material.dart';

class InfoWargaPage extends StatelessWidget {
  const InfoWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data ini sekarang akan digunakan untuk dikirim ke halaman detail
    final List<Map<String, String>> wargaList = [
      {'nama': 'Annisa Aulia Firdaus', 'alamat': 'Gg. Bidan Tati Jambudipa Rt04/Rw03 Warungkondang, Cianjur, 43261', 'nik': '32898366529008', 'telp': '08123455678'},
      {'nama': 'Shaqilla Salsabila', 'alamat': 'Gg. Harapan 2, Jl. Arciko', 'nik': '3201234567890123', 'telp': '081222222222'},
      {'nama': 'Shalwa Ainnur', 'alamat': 'Gg. Harapan 2, Jl. Arciko', 'nik': '3201234567890456', 'telp': '081333333333'},
      {'nama': 'Sania Eka Wardah', 'alamat': 'Gg. Harapan 2, Jl. Arciko', 'nik': '3201234567890789', 'telp': '081444444444'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text(
          'Warga Desa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
             if (Navigator.canPop(context)) {
               Navigator.pop(context);
             }
          },
        ),
      ),
      body: Container(
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
            itemCount: wargaList.length,
            itemBuilder: (context, index) {
              final warga = wargaList[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                title: Text(
                  warga['nama']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                subtitle: Text(
                  warga['alamat']!,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IdentitasWargaPage(warga: warga),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1, indent: 8, endIndent: 8);
            },
          ),
        ),
      ),
    );
  }
}