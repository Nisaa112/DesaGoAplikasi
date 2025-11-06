import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import package chart

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  // Warna untuk chart
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
              _buildSummarySection(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk bagian "Total Dana"
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

  // Widget untuk bagian "Overview" dan Chart
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
          height: 200, // Tinggi untuk chart
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 250, // Nilai Y tertinggi pada chart (dalam 'k')
              barTouchData: BarTouchData(enabled: false), // Menonaktifkan interaksi sentuh
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Sembunyikan label bawah
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Sembunyikan label kanan
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Sembunyikan label atas
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
              borderData: FlBorderData(show: false), // Sembunyikan border chart
              gridData: FlGridData(show: false), // Sembunyikan grid
              barGroups: _getBarGroups(), // Data untuk bar
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildChartLegend(), // Legend di bawah chart
      ],
    );
  }

  // Data dummy untuk group bar chart
  List<BarChartGroupData> _getBarGroups() {
    // Data (dalam ribuan, misal 220 = 220k)
    final List<double> pengeluaranData = [220, 200, 120, 230, 90, 200];
    final List<double> pemasukanData = [85, 175, 170, 160, 180, 170];
    
    return List.generate(pengeluaranData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          // Bar Pengeluaran
          BarChartRodData(
            toY: pengeluaranData[index],
            color: pengeluaranColor,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          // Bar Pemasukan
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

  // Widget untuk legend chart
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

  // Widget untuk bagian summary Pemasukan & Pengeluaran
  Widget _buildSummarySection() {
    return Column(
      children: [
        _buildSummaryCard('Pemasukan:', 'Rp350.000,00'),
        const SizedBox(height: 12),
        _buildSummaryCard('Pengeluaran:', 'Rp100.000,00'),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}