import 'package:desa_go_aplikasi/page/status_pembayaran_kas_page.dart';
import 'package:flutter/material.dart';

class BendaharaPembayaranKasPage extends StatelessWidget {
  const BendaharaPembayaranKasPage({super.key});

  // Warna yang sesuai dengan base desain
  static const Color primaryColor = Color(0xFF4A4E8A);
  static const Color buttonColor = Color(0xFFFFC212);
  static const Color listItemColor = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk daftar kas
    final List<String> kasList = [
      'Iuran Acara 17 Agustus',
      'Iuran Acara Rajaban',
    ];

    return Scaffold(
      backgroundColor: primaryColor, // Background AppBar
      appBar: AppBar(
        title: const Text(
          'Pembayaran Kas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
              // List Item Kas
              ...kasList.map((kasName) => _buildKasItem(
                    context,
                    kasName,
                    () {
                      // Navigasi ke halaman Status Pembayaran Kas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StatusPembayaranKasPage(kasTitle: kasName)),
                      );
                    },
                  )).toList(),
              // Padding bawah agar FAB tidak menutupi item
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
      
      // MARK: - Floating Action Button (FAB) untuk Tambah Kas
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () => _showAddKasNameDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: 0, 
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(Icons.add, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              'Tambah Kas',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Item List Kas
  Widget _buildKasItem(
      BuildContext context, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            // Menggunakan warna yang mirip dengan _buildNavigationButton (grey.shade200)
            color: listItemColor, 
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Pop-up Form Tambah Nama Kas (Saat Tombol "Tambah Kas" diklik)
  void _showAddKasNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(25),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Nama Kas',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nama Kas',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Saldo Awal (Rp)',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cth: 500000',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Aksi kirim nama kas baru
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kirim',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send, color: Colors.black87, size: 18),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}