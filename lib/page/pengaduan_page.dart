import 'package:desa_go_aplikasi/page/pengaduan_form_page.dart';
import 'package:flutter/material.dart';

class PengaduanPage extends StatelessWidget {
  const PengaduanPage({super.key});

  final List<Map<String, String>> _dummyPengaduanList = const [
    {
      'judul': 'Jalan Rusak',
      'deskripsi': 'Lokasi jalan blok 5b Rusak',
      'status': 'Pending',
    },
    {
      'judul': 'Administrasi surat',
      'deskripsi': 'Pengajuan administrasi surat untuk...',
      'status': 'Diproses',
    },
    {
      'judul': 'Maling',
      'deskripsi': 'PERHATIAN!! terdapat maling diseki...',
      'status': 'Selesai',
    },
  ];

  Widget _buildStatusBadge(String status) {
    Color color;
    if (status == 'Pending') {
      color = const Color(0xFFFFC212); // Kuning/Oranye
    } else if (status == 'Di Proses') {
      color = const Color(0xFF5CB85C); // Hijau
    } else if (status == 'Selesai') {
      color = const Color(0xFF333333); // Hitam/Abu-abu gelap
    } else {
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Sudut lebih membulat
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Widget Helper untuk Item Pengaduan ---
  Widget _buildPengaduanItem(Map<String, String> pengaduan) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            pengaduan['judul']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            pengaduan['deskripsi']!,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          trailing: _buildStatusBadge(pengaduan['status']!),
          onTap: () {
            // Aksi ketika item pengaduan diklik (misalnya, menuju halaman detail)
            print('Detail Pengaduan: ${pengaduan['judul']}');
          },
        ),
        // Garis pemisah di bawah ListTile
        const Divider(height: 1, color: Colors.grey, thickness: 0.5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: const Text(
          'Pengaduan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: 'Milik Saya',
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                        elevation: 1,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        underline: Container(), // Hapus garis bawah
                        items: <String>['Milik Saya', 'Semua Pengaduan']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Logika ketika filter diubah
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // Hapus padding default
                    itemCount: _dummyPengaduanList.length,
                    itemBuilder: (context, index) {
                      return _buildPengaduanItem(_dummyPengaduanList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormPengaduanPage()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.black87),
                label: const Text(
                  'Tambah Pengaduan',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC212),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}