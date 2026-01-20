import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// Mengimpor model dan viewmodel
import 'package:desa_go_aplikasi/models/transaksi_model.dart' as transaksi_model;
import 'package:desa_go_aplikasi/viewmodel/transaksi_kas_viewmodel.dart';

class BendaharaKeuanganPage extends StatefulWidget {
  const BendaharaKeuanganPage({super.key});

  @override
  State<BendaharaKeuanganPage> createState() => _BendaharaKeuanganPageState();
}

class _BendaharaKeuanganPageState extends State<BendaharaKeuanganPage> {
  final Color pengeluaranColor = const Color(0xFF4A4E8A);
  final Color pemasukanColor = const Color(0xFFFFC94D);

  int _selectedMonth = 0; // 0 = Semua Bulan

  final List<String> _namaBulan = [
    'Semua', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransaksiViewModel>(context, listen: false).loadTransaksi();
    });
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
        .format(amount);
  }

  // Menampilkan Modal pemilih bulan dengan desain grid 3 kolom yang simpel
  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  "Pilih Periode Laporan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _namaBulan.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedMonth == index;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() => _selectedMonth = index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4A4E8A)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4A4E8A)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          _namaBulan[index],
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Colors.black87,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


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
      body: Consumer<TransaksiViewModel>(
        builder: (context, trxVM, child) {
          final now = DateTime.now();
          
          final filteredList = trxVM.listTransaksi.where((t) {
            if (t.tanggal == null) return false;
            DateTime tDate = DateTime.parse(t.tanggal!);
            bool isSameYear = tDate.year == now.year;
            bool isSelectedMonth = _selectedMonth == 0 ? true : tDate.month == _selectedMonth;
            return isSameYear && isSelectedMonth;
          }).toList();

          double totalMasuk = 0;
          double totalKeluar = 0;

          for (var t in filteredList) {
            if (t.jenis?.toLowerCase() == 'masuk') {
              totalMasuk += (t.jumlah ?? 0).toDouble();
            } else {
              totalKeluar += (t.jumlah ?? 0).toDouble();
            }
          }

          return Container(
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
                  _buildHeaderSection(totalMasuk - totalKeluar),
                  const SizedBox(height: 24),
                  _buildChartSection(trxVM.listTransaksi),
                  const SizedBox(height: 24),
                  _buildSummarySection(totalMasuk, totalKeluar),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Total Dana Tersedia', style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          formatCurrency(total),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildChartSection(List<transaksi_model.Data> transactions) {
    DateTime now = DateTime.now();
    double highestValue = 0;
    
    // Tentukan jumlah batang (12 untuk setahun, 4 untuk mingguan dalam sebulan)
    int barCount = _selectedMonth == 0 ? 12 : 4;

    List<BarChartGroupData> barGroups = List.generate(barCount, (index) {
      double monthlyIn = 0;
      double monthlyOut = 0;

      for (var t in transactions) {
        if (t.tanggal != null) {
          DateTime tDate = DateTime.parse(t.tanggal!);
          if (tDate.year == now.year) {
            if (_selectedMonth == 0) {
              // Tampilan Per Tahun (Jan - Des)
              if (tDate.month == index + 1) {
                if (t.jenis?.toLowerCase() == 'masuk') monthlyIn += (t.jumlah ?? 0).toDouble();
                else monthlyOut += (t.jumlah ?? 0).toDouble();
              }
            } else {
              // Tampilan Per Bulan (Dikelompokkan per Minggu)
              if (tDate.month == _selectedMonth) {
                int weekIndex = ((tDate.day - 1) / 7).floor().clamp(0, 3);
                if (weekIndex == index) {
                  if (t.jenis?.toLowerCase() == 'masuk') monthlyIn += (t.jumlah ?? 0).toDouble();
                  else monthlyOut += (t.jumlah ?? 0).toDouble();
                }
              }
            }
          }
        }
      }

      highestValue = max(highestValue, max(monthlyIn, monthlyOut));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monthlyOut, 
            color: pengeluaranColor, 
            width: _selectedMonth == 0 ? 6 : 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: monthlyIn, 
            color: pemasukanColor, 
            width: _selectedMonth == 0 ? 6 : 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
        ],
      );
    });

    double dynamicMaxY = highestValue == 0 ? 100000 : highestValue * 1.3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Statistik Arus Kas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => _showMonthPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list, // Menggunakan icon filter agar sama persis contoh
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _namaBulan[_selectedMonth], // Menampilkan bulan yang dipilih
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: dynamicMaxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFF4A4E8A).withOpacity(0.9),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                    formatCurrency(rod.toY),
                    const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String labelText = '';
                      if (_selectedMonth == 0) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
                        if (value >= 0 && value < months.length) {
                          labelText = months[value.toInt()];
                        }
                      } else {
                        labelText = 'M${value.toInt() + 1}';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          labelText,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: dynamicMaxY / 4 > 0 ? dynamicMaxY / 4 : 25000,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.05),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildChartLegend(),
      ],
    );
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
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSummarySection(double masuk, double keluar) {
    return Column(
      children: [
        _buildSummaryCard('Total Pemasukan', formatCurrency(masuk), pemasukanColor),
        const SizedBox(height: 12),
        _buildSummaryCard('Total Pengeluaran', formatCurrency(keluar), pengeluaranColor),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 18, color: accentColor),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}