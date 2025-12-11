import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PemasukanItem {
  final String deskripsi;
  final double jumlah;
  final DateTime tanggal;

  PemasukanItem({required this.deskripsi, required this.jumlah, required this.tanggal});
}

class PemasukanPage extends StatelessWidget {
  PemasukanPage({super.key});

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
    return formatCurrency.format(amount).replaceAll(',00', '.00');
  }

  String _formatDateLite(DateTime date) {
    final namaHari = DateFormat('EEEE', 'id_ID').format(date);
    final tgl = DateFormat('d MMMM yyyy', 'id_ID').format(date);
    return '${namaHari.substring(0, 1).toUpperCase()}${namaHari.substring(1)}, ${tgl}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
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
        width: double.infinity,
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
    );
  }

  Widget _buildPemasukanList() {
    return ListView.separated(
      // ✅ UBAH DISINI: Saya set padding keseluruhan ListView.
      // - top: 40 (Jarak jauh dari atas box putih)
      // - left: 24 (Jarak dari pinggir kiri layar)
      // - right: 24 (Jarak dari pinggir kanan layar)
      // - bottom: 30 (Jarak aman di bawah agar scroll tidak kepotong)
      padding: const EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0, bottom: 30.0),
      
      itemCount: dummyPemasukan.length,
      itemBuilder: (context, index) {
        final item = dummyPemasukan[index];

        return ListTile(
          // ✅ SAYA HAPUS baris 'contentPadding: EdgeInsets.zero' 
          // yang ada di kode lama kamu. Baris itu yang bikin teks nempel ke pinggir.
          
          // Mengatur sedikit kerapatan dalam item agar tidak terlalu lebar
          visualDensity: VisualDensity.compact, 
          
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.deskripsi,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87, 
                  fontSize: 16
                ),
              ),
              const SizedBox(height: 6), // Menambah jarak antara Judul dan Harga
              Text(
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
                _formatDateLite(item.tanggal).replaceAll(' 2025', ''),
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
        );
      },
      separatorBuilder: (context, index) {
        // Mengatur garis pemisah agar lurus dengan layout
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0), // Jarak antar item diperluas
          child: Divider(height: 1),
        );
      },
    );
  }
}