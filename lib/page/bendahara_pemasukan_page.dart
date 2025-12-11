import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PemasukanItem {
  final String deskripsi;
  final double jumlah;
  final DateTime tanggal;

  PemasukanItem({required this.deskripsi, required this.jumlah, required this.tanggal});
}

class BendaharaPemasukanPage extends StatelessWidget {
  BendaharaPemasukanPage({super.key});

  // Warna Konstanta
  static const Color primaryColor = Color(0xFF4A4E8A);
  static const Color buttonColor = Color(0xFFFFC212);

  final List<PemasukanItem> dummyPemasukan = [
    PemasukanItem(deskripsi: 'Dana Iuran Warga', jumlah: 300000.00, tanggal: DateTime(2025, 7, 23)),
    PemasukanItem(deskripsi: 'Dana Iuran Warga', jumlah: 300000.00, tanggal: DateTime(2025, 7, 23)),
    PemasukanItem(deskripsi: 'Dana Iuran Warga', jumlah: 300000.00, tanggal: DateTime(2025, 7, 23)),
    PemasukanItem(deskripsi: 'Dana Iuran Warga', jumlah: 300000.00, tanggal: DateTime(2025, 7, 23)),
    PemasukanItem(deskripsi: 'Dana Iuran Warga', jumlah: 300000.00, tanggal: DateTime(2025, 7, 23)),
    PemasukanItem(deskripsi: 'Donasi Kebersihan', jumlah: 150000.00, tanggal: DateTime(2025, 7, 24)),
    PemasukanItem(deskripsi: 'Sewa Balai Warga', jumlah: 500000.00, tanggal: DateTime(2025, 7, 25)),
  ];

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    // Menggunakan replaceAll untuk memastikan format sesuai contoh Rp1.234.567,00
    return formatCurrency.format(amount).replaceAll(',00', '.00'); 
  }

  String _formatDateLite(DateTime date) {
    // Digunakan untuk menampilkan format Hari, d Bulan T
    final namaHari = DateFormat('EEEE', 'id_ID').format(date);
    final tgl = DateFormat('d MMMM yyyy', 'id_ID').format(date);
    
    return '${namaHari.substring(0, 1).toUpperCase()}${namaHari.substring(1)}, ${tgl}';
  }

  // MARK: - Pop-up Form Pemasukan
  void _showAddPemasukanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(25),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField('dd/mm/yyyy', primaryColor),
                const SizedBox(height: 16),

                const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField('Cth: Dana Iuran Warga', primaryColor),
                const SizedBox(height: 16),
                
                const Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField('Cth: 200000', primaryColor, isNumeric: true),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Aksi tambah pemasukan
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tambah',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.add, color: Colors.black87),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String hint, Color focusColor, {bool isNumeric = false}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Pemasukan',
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
          child: _buildPemasukanList(),
        ),
      ),
      
      // MARK: - Floating Action Button (FAB) untuk Tambah Pemasukan
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () => _showAddPemasukanDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: 4,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              'Tambah Pemasukan',
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

  Widget _buildPemasukanList() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8.0, bottom: 80.0), // Tambah padding bawah agar FAB tidak menutupi item terakhir
      itemCount: dummyPemasukan.length,
      itemBuilder: (context, index) {
        final item = dummyPemasukan[index];
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero, 
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.deskripsi,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  // Ubah formatCurrency agar sesuai output yang benar
                  _formatCurrency(item.jumlah),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDateLite(item.tanggal).split(', ')[1].replaceAll(' 2025', ''), // Menampilkan tanggal saja tanpa tahun
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Detail Pemasukan: ${item.deskripsi}')),
              );
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1, indent: 16, endIndent: 16);
      },
    );
  }
}