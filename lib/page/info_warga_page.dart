import 'package:flutter/material.dart';

class InfoWargaPage extends StatelessWidget {
  const InfoWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> wargaList = [
      {'nama': 'Annisa Aulia', 'alamat': 'Gg. Harapan 2, Jl. Arciko'},
      {'nama': 'Shaqilla Salsabila', 'alamat': 'Gg. Harapan 2, Jl. Arciko'},
      {'nama': 'Shalwa Ainnur', 'alamat': 'Gg. Harapan 2, Jl. Arciko'},
      {'nama': 'Sania Eka Wardah', 'alamat': 'Gg. Harapan 2, Jl. Arciko'},
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