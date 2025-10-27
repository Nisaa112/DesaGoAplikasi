import 'package:flutter/material.dart';

class StrukturPage extends StatelessWidget {
  const StrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk daftar anggota
    final List<Map<String, String>> membersList = [
      {'nama': 'Sania Eka Wardah', 'jabatan': 'Ketua RW'},
      {'nama': 'Shaqilla Salsabila', 'jabatan': 'Ketua RT'},
      {'nama': 'Shalwa Ainnur Hafidzin', 'jabatan': 'Sekretaris 1'},
      {'nama': 'Annisa Aulia Firdaus', 'jabatan': 'Sekretaris 2'},
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
            // Aksi ini bisa disesuaikan.
            // Mungkin lebih baik kembali ke tab home daripada pop.
            // Untuk sekarang, kita gunakan pop jika memungkinkan.
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
        // ClipRRect memastikan list yang di-scroll terpotong oleh sudut membulat
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
                  // Aksi ketika item di-tap
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