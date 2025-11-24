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
      'status': 'Di Proses',
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

  // --- Widget Bottom Navigasi (Bottom Bar) ---
  Widget _buildBottomNavBar() {
    // Warna Utama
    const Color primaryColor = Color(0xFF4A4E8A);
    // Warna Ikon Tidak Aktif
    const Color inactiveIconColor = Colors.white;
    // Warna Ikon Aktif (Asumsi berdasarkan warna ungu di badge profile)
    const Color activeIconColor = Color(0xFF9370DB); 

    return Container(
      height: 70, // Sesuaikan tinggi sesuai kebutuhan
      decoration: const BoxDecoration(
        color: Color(0xFF333333), // Warna latar belakang hitam/abu-abu gelap
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home, color: inactiveIconColor, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.people, color: inactiveIconColor, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.group_work, color: inactiveIconColor, size: 28), onPressed: () {}), // Ikon untuk kegiatan/info
          IconButton(icon: const Icon(Icons.calendar_today, color: inactiveIconColor, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.credit_card, color: inactiveIconColor, size: 28), onPressed: () {}),
          
          // Ikon Aktif (Pengaduan/Profile) - Menggunakan Container/Widget untuk latar belakang ungu
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor, // Latar belakang ungu
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
          ),
        ],
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
          'Pengaduan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Bagian Body (Daftar Pengaduan)
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            margin: const EdgeInsets.only(top: 20.0), // Jarak dari App Bar
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
                // Dropdown Filter "Milik Saya"
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: 'Milik Saya',
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                        elevation: 16,
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

                // Daftar Pengaduan
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
          
          // Tombol Tambah Pengaduan (ditempatkan di tengah-bawah)
          Positioned(
            bottom: 80, // Jarak di atas Bottom Nav Bar
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Aksi untuk menambah pengaduan
                  print('Tambah Pengaduan ditekan');
                },
                icon: const Icon(Icons.add, color: Colors.black87),
                label: const Text(
                  'Tambah Pengaduan',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC212), // Warna Kuning/Oranye
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigasi (Sama dengan gambar)
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}