// [PERUBAHAN 1] Import halaman detail pejabat
import 'package:desa_go_aplikasi/page/identitas_pejabat_page.dart';
import 'package:flutter/material.dart';

class StrukturPage extends StatelessWidget {
  const StrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERUBAHAN 2] Lengkapi data dummy agar memiliki semua field yang dibutuhkan
    final List<Map<String, String>> membersList = [
      {
        'nama': 'Sania Eka Wardah',
        'jabatan': 'Ketua RW',
        'nik': '32898366529008',
        'alamat': 'Gg. Bidan Tati Jambudipa Rt04/Rw03 Warungkondang, Cianjur, 43261',
        'telp': '08123455678'
      },
      {
        'nama': 'Shaqilla Salsabila',
        'jabatan': 'Ketua RT',
        'nik': '3201234567890123',
        'alamat': 'Alamat Shaqilla Salsabila',
        'telp': '081222222222'
      },
      {
        'nama': 'Shalwa Ainnur Hafidzin',
        'jabatan': 'Sekretaris 1',
        'nik': '3201234567890456',
        'alamat': 'Alamat Shalwa Ainnur Hafidzin',
        'telp': '081333333333'
      },
      {
        'nama': 'Annisa Aulia Firdaus',
        'jabatan': 'Sekretaris 2',
        'nik': '3201234567890789',
        'alamat': 'Alamat Annisa Aulia Firdaus',
        'telp': '081444444444'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text(
          'Struktur Keanggotaan',
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
            itemCount: membersList.length,
            itemBuilder: (context, index) {
              final member = membersList[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade300,
                ),
                title: Text(
                  member['nama']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
                ),
                subtitle: Text(
                  member['jabatan']!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // [PERUBAHAN 3] Tambahkan aksi navigasi di sini
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Kirim data 'member' dari item yang di-tap ke halaman detail
                      builder: (context) => IdentitasPejabatPage(member: member),
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