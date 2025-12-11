import 'package:flutter/material.dart';

class StatusPembayaranKasPage extends StatelessWidget {
  final String kasTitle;
  const StatusPembayaranKasPage({super.key, required this.kasTitle});

  @override
  Widget build(BuildContext context) {
    // Data dummy
    const double totalPemasukan = 1450000;
    const double totalPengeluaran = 950000; // 270k + 80k + 600k
    final double sisaSaldo = totalPemasukan - totalPengeluaran;

    // Warna
    const Color primaryColor = Color(0xFF4A4E8A);
    const Color chartIncomeColor = Color(0xFFFFC212);
    const Color chartExpenseColor = Colors.black;
    const Color buttonColor = Color(0xFFFFC212);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Pembayaran Kas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            _buildSummaryCard(context, sisaSaldo, totalPemasukan,
                totalPengeluaran, chartIncomeColor, chartExpenseColor),
            const SizedBox(height: 20),
            _buildRiwayatTransaksi(),
          ],
        ),
      ),
      // --- IMPLEMENTASI TOMBOL TAMBAH KAS YANG MEMUNCULKAN POP-UP ---
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey.shade100,
        child: ElevatedButton(
          onPressed: () => _showAddCashDialog(context, primaryColor, buttonColor),
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
      ),
      // --- AKHIR IMPLEMENTASI TOMBOL TAMBAH KAS ---
    );
  }

  // MARK: - Summary Card
  Widget _buildSummaryCard(
      BuildContext context,
      double sisaSaldo,
      double totalPemasukan,
      double totalPengeluaran,
      Color incomeColor,
      Color expenseColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart
          SizedBox(
            height: 120,
            child: Row(
              children: [
                _buildPieChart(totalPemasukan, totalPengeluaran, incomeColor, expenseColor),
                const SizedBox(width: 20),
                // Legend
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('Pemasukan', incomeColor),
                    _buildLegendItem('Pengeluaran', expenseColor),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Judul Kas
          Center(
            child: Text(
              kasTitle,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey),
          // Sisa Saldo
          const Text(
            'Sisa saldo kas akhir',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp${sisaSaldo.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF4A4E8A)),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey),
          // Total Pemasukan
          Text(
            'Total Pemasukan : Rp. ${totalPemasukan.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildPieChart(double income, double expense, Color incomeColor, Color expenseColor) {
    final total = income + expense;
    // Hindari pembagian dengan nol jika total 0
    final incomeRatio = total > 0 ? income / total : 0.5; 
    final expenseRatio = total > 0 ? expense / total : 0.5;

    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: PieChartPainter(
          incomeRatio: incomeRatio,
          expenseRatio: expenseRatio, // Passing expenseRatio for better drawing logic
          incomeColor: incomeColor,
          expenseColor: expenseColor,
        ),
      ),
    );
  }

  // MARK: - Riwayat Transaksi
  Widget _buildRiwayatTransaksi() {
    // Data dummy
    final List<Map<String, dynamic>> transactions = [
      {'title': 'Annisa', 'amount': 1450000.0, 'isIncome': true, 'icon': Icons.add_circle},
      {'title': 'Pembelian hadiah lomba', 'amount': 270000.0, 'isIncome': false, 'icon': Icons.remove_circle},
      {'title': 'Pembelian dekorasi', 'amount': 80000.0, 'isIncome': false, 'icon': Icons.remove_circle},
      {'title': 'Sewa Sound System', 'amount': 600000.0, 'isIncome': false, 'icon': Icons.remove_circle},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Transaksi',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          ...transactions.map((t) => _buildTransactionItem(
              title: t['title'] as String,
              amount: t['amount'] as double,
              isIncome: t['isIncome'] as bool,
              icon: t['icon'] as IconData,
            )).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      {required String title,
      required double amount,
      required bool isIncome,
      required IconData icon}) {
    final Color iconColor = isIncome ? const Color(0xFFFFC212) : const Color(0xFF4A4E8A);
    final String amountString =
        'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            Text(
              amountString,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - Pop-up Form Tambah Kas
  void _showAddCashDialog(
      BuildContext context, Color primaryColor, Color buttonColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(25),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Tanggal
                const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField('dd/mm/yyyy'),
                const SizedBox(height: 16),

                // Keterangan
                const Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField('Cth: Pembelian Hadiah Lomba'),
                const SizedBox(height: 16),

                // Jenis Transaksi
                const Text('Jenis Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildDropdownField(primaryColor),
                const SizedBox(height: 16),

                // Jumlah
                const Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField('Cth: 200000'),
                const SizedBox(height: 20),

                // Tombol Tambah
                ElevatedButton(
                  onPressed: () {
                    // Aksi tambah kas
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

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
          borderSide: const BorderSide(color: Color(0xFF4A4E8A), width: 2),
        ),
      ),
      keyboardType: hint.contains('200000')
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  Widget _buildDropdownField(Color focusColor) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
      value: 'Kas Masuk',
      items: ['Kas Masuk', 'Kas Keluar']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Handle perubahan
      },
    );
  }
}

// Custom Painter untuk Pie Chart Sederhana (Digunakan di StatusPembayaranKasPage)
class PieChartPainter extends CustomPainter {
  final double incomeRatio;
  final double expenseRatio;
  final Color incomeColor;
  final Color expenseColor;

  PieChartPainter({
    required this.incomeRatio,
    required this.expenseRatio,
    required this.incomeColor,
    required this.expenseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const double startAngle = -3.14159265359 / 2; // Mulai dari atas

    // Pengeluaran (Hitam)
    final Paint expensePaint = Paint()..color = expenseColor;
    double expenseSweep = 2 * 3.14159265359 * expenseRatio; 
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, expenseSweep, true, expensePaint);

    // Pemasukan (Kuning)
    final Paint incomePaint = Paint()..color = incomeColor;
    double incomeSweep = 2 * 3.14159265359 * incomeRatio; 
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle + expenseSweep, incomeSweep, true, incomePaint);


    // Lingkaran tengah putih (untuk membuat bentuk Donut/Ring)
    final Paint whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.7, whitePaint); 
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PieChartPainter) {
      return oldDelegate.incomeRatio != incomeRatio || oldDelegate.expenseRatio != expenseRatio;
    }
    return true;
  }
}