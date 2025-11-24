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

  final List<PemasukanItem> dummyPemasukan =  [
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
    return formatCurrency.format(amount).replaceAll(',00', ',00');
  }
  
  String _formatDate(DateTime date) {
    final dayName = DateFormat('EEEE', 'id').format(date); 
    final formattedDate = DateFormat('d MMMM y', 'id').format(date); 

    final hari = DateFormat('EEEE', 'id_ID').format(date);
    final tglBlnThn = DateFormat('d MMMM yyyy', 'id_ID').format(date); 
    
    final hariSingkat = hari.substring(0, 1).toUpperCase() + hari.substring(1); 
    final tglSaja = DateFormat('d MMMM yyyy', 'id_ID').format(date); 
    
    final namaHari = DateFormat('EEEE', 'id_ID').format(date);
    final tanggalBulanTahun = DateFormat('d MMMM yyyy', 'id_ID').format(date);
    return '${namaHari.substring(0, 1).toUpperCase()}${namaHari.substring(1)}, ${DateFormat('d MMMM yyyy', 'id_ID').format(date)}';
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1, indent: 16, endIndent: 16);
      },
    );
  }
}