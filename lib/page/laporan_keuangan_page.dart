import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LaporanKeuanganPage extends StatelessWidget {
  const LaporanKeuanganPage({super.key});

  final Color rondaColor = const Color(0xFFFFC94D);
  final Color posyanduColor = const Color(0xFF4A4E8A);
  final Color acaraColor = Colors.grey;
  final Color fasilitasColor = const Color(0xFF2C2C2C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text('Laporan Keuangan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              height: 120,
              color: const Color(0xFF4A4E8A),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 32),
                  _buildPieChartSection(),
                  const SizedBox(height: 32),
                  _buildTransactionList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          // [PERUBAHAN 1] Perbesar ukuran container chart
          width: 220,
          height: 220,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(enabled: false),
              sectionsSpace: 5,
              centerSpaceRadius: 0,
              sections: [
                PieChartSectionData(
                  value: 40,
                  color: rondaColor,
                  // [PERUBAHAN 2] Perbesar radius pie
                  radius: 90, 
                  showTitle: false,
                  badgeWidget: const Text(
                    '40%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  badgePositionPercentageOffset: 1.2, // Sedikit lebih dekat agar pas
                ),
                PieChartSectionData(
                  value: 30,
                  color: posyanduColor,
                  radius: 90, // Perbesar radius pie
                  showTitle: false,
                  badgeWidget: const Text(
                    '30%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  badgePositionPercentageOffset: 1.2,
                ),
                PieChartSectionData(
                  value: 20,
                  color: acaraColor,
                  radius: 90, // Perbesar radius pie
                  showTitle: false,
                  badgeWidget: const Text(
                    '20%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  badgePositionPercentageOffset: 1.2,
                ),
                PieChartSectionData(
                  value: 10,
                  color: fasilitasColor,
                  radius: 90, // Perbesar radius pie
                  showTitle: false,
                  badgeWidget: const Text(
                    '10%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  badgePositionPercentageOffset: 1.2,
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem(rondaColor, 'Ronda'),
            const SizedBox(height: 8),
            _buildLegendItem(posyanduColor, 'Posyandu'),
            const SizedBox(height: 8),
            _buildLegendItem(acaraColor, 'Acara'),
            const SizedBox(height: 8),
            _buildLegendItem(fasilitasColor, 'Fasilitas'),
          ],
        )
      ],
    );
  }
  
  // Sisa method tidak berubah
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildDropdown('2024'),
              const SizedBox(width: 16),
              _buildDropdown('Juli'),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Total Dana', style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('Rp250.000,00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC94D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Export Data', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Row(
      children: [
        Text(value, style: TextStyle(color: Colors.grey.shade700)),
        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transaksi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildDropdown('Semua'),
          ],
        ),
        const SizedBox(height: 16),
        _buildTransactionItem('Dana Iuran Warga', '+Rp200.000,00', '02/09', true),
        _buildTransactionItem('Dana Iuran Warga', '+Rp200.000,00', '03/09', true),
        _buildTransactionItem('Acara 17 Agustus an', '-Rp200.000,00', '03/09', false),
        _buildTransactionItem('Dana Iuran Warga', '+Rp200.000,00', '04/09', true),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, String date, bool isIncome) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Text(date, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.6
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}