import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 

// MARK: - Tambahkan import untuk halaman Pemasukan dan Pengeluaran
// Ganti path ini dengan path file Anda yang sebenarnya
import 'bendahara_pemasukan_page.dart'; // Asumsi nama file: bendahara_pemasukan_page.dart
import 'bendahara_pengeluaran_page.dart'; // Asumsi nama file: bendahara_pengeluaran_page.dart
// Catatan: Saya menggunakan nama kelas BendaharaPemasukanPage dan PengeluaranPage sesuai kode yang Anda berikan.


class BendaharaKeuanganPage extends StatelessWidget {
  const BendaharaKeuanganPage({super.key});

  final Color pengeluaranColor = const Color(0xFF4A4E8A);
  final Color pemasukanColor = const Color(0xFFFFC94D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: const Text(
          'Keuangan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildChartSection(),
              const SizedBox(height: 24),
              // Mengirim context ke summary section
              _buildSummarySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Total Dana',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          'Rp250.000,00',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: const [
                Text('Bulan', style: TextStyle(color: Colors.grey)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200, 
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 250,
              barTouchData: BarTouchData(enabled: false), 
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), 
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), 
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), 
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      String text;
                      if (value == 0) text = '0k';
                      else if (value == 50) text = '50k';
                      else if (value == 100) text = '100k';
                      else if (value == 150) text = '150k';
                      else if (value == 200) text = '200k';
                      else if (value == 250) text = '250k';
                      else return Container();
                      return Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false), 
              gridData: FlGridData(show: false), 
              barGroups: _getBarGroups(), 
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildChartLegend(), 
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final List<double> pengeluaranData = [85, 175, 170, 160, 180, 170];
    final List<double> pemasukanData = [220, 200, 120, 230, 90, 200];
    
    return List.generate(pengeluaranData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: pengeluaranData[index],
            color: pengeluaranColor,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: pemasukanData[index],
            color: pemasukanColor,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(pengeluaranColor, 'Pengeluaran'),
        const SizedBox(width: 24),
        _buildLegendItem(pemasukanColor, 'Pemasukan'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // MODIFIKASI: Menerima BuildContext untuk Navigasi
  Widget _buildSummarySection(BuildContext context) {
    return Column(
      children: [
        // Kartu Pemasukan
        _buildSummaryCard(
          context: context, // Kirim context
          title: 'Pemasukan:', 
          amount: 'Rp350.000,00',
          destinationPage: BendaharaPemasukanPage(), 
        ),
        const SizedBox(height: 12),
        // Kartu Pengeluaran
        _buildSummaryCard(
          context: context, // Kirim context
          title: 'Pengeluaran:', 
          amount: 'Rp100.000,00',
          destinationPage: PengeluaranPage(), // Halaman tujuan Pengeluaran
        ),
      ],
    );
  }

  // MODIFIKASI: Menerima BuildContext dan Widget tujuan
  Widget _buildSummaryCard({
    required BuildContext context, 
    required String title, 
    required String amount,
    required Widget destinationPage, // Menambahkan parameter untuk halaman tujuan
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
            const Icon(Icons.chevron_right, color: Colors.grey), // Tambah icon panah
          ],
        ),
      ),
    );
  }
}