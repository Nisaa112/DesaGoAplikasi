import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:desa_go_aplikasi/page/notifikasi_page.dart';
import 'package:desa_go_aplikasi/page/pemasukan_page.dart';
import 'package:desa_go_aplikasi/page/pengeluaran_page.dart';
import 'package:desa_go_aplikasi/page/profil_page.dart';
import 'package:desa_go_aplikasi/viewmodel/transaksi_kas_viewmodel.dart';
import 'package:desa_go_aplikasi/widgets/wave_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:intl/intl.dart';

class BendaharaHomePage extends StatefulWidget {
  const BendaharaHomePage({super.key});

  @override
  State<BendaharaHomePage> createState() => _BendaharaHomePageState();
}

class _AdminHomePageState {} // Abaikan ini, kita lanjut ke state yang benar

class _BendaharaHomePageState extends State<BendaharaHomePage> {

  @override
  void initState() {
    super.initState();
    // Memuat data transaksi saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransaksiViewModel>(context, listen: false).loadTransaksi();
    });
  }

  // Fungsi helper format mata uang
  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final trxVM = context.watch<TransaksiViewModel>();

    // --- LOGIKA HITUNG DATA KEUANGAN ---
    double totalMasuk = 0;
    double totalKeluar = 0;

    for (var t in trxVM.listTransaksi) {
      if (t.jenis?.toLowerCase() == 'masuk') {
        totalMasuk += (t.jumlah ?? 0).toDouble();
      } else {
        totalKeluar += (t.jumlah ?? 0).toDouble();
      }
    }

    double totalDana = totalMasuk - totalKeluar;

    // --- LOGIKA GRAFIK MINGGUAN (7 HARI TERAKHIR) ---
    List<double> weeklyFactors = _getWeeklyStats(trxVM.listTransaksi);

    return Material(
      color: Colors.white,
      child: RefreshIndicator(
        color: const Color(0xFFFFC212),
        onRefresh: () => trxVM.synchronizeTransaksi(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, authVM.userName),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox.shrink(), 
                ),
                _buildTotalDanaCard(context, formatCurrency(totalDana), weeklyFactors), 
                const SizedBox(height: 24),
                _buildFinanceCards(context, formatCurrency(totalMasuk), formatCurrency(totalKeluar)),
                const SizedBox(height: 24),
                _buildHistoryList(trxVM.listTransaksi), 

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Menghitung statistik 7 hari terakhir untuk grafik batang kecil
  List<double> _getWeeklyStats(List<dynamic> transactions) {
    List<double> factors = List.filled(10, 0.1); // Default 10 bar kecil
    DateTime now = DateTime.now();

    for (int i = 0; i < 10; i++) {
      DateTime targetDate = now.subtract(Duration(days: i));
      double dailyTotal = 0;

      for (var t in transactions) {
        if (t.tanggal != null) {
          DateTime tDate = DateTime.parse(t.tanggal!);
          if (tDate.year == targetDate.year && tDate.month == targetDate.month && tDate.day == targetDate.day) {
            dailyTotal += (t.jumlah ?? 0).toDouble();
          }
        }
      }
      // Normalisasi tinggi bar (max 1.0)
      factors[9 - i] = (dailyTotal / 1000000).clamp(0.2, 1.0);
    }
    return factors;
  }

  Widget _buildHeader(BuildContext context, String? userName) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF4A4E8A),
            child: Icon(Icons.person_outline, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello,', style: TextStyle(color: Colors.black87, fontSize: 16)),
            Text(userName ?? 'Pengguna', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Text('Sebagai Bendahara', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, size: 30, color: Colors.grey),
      ],
    );
  }

  Widget _buildTotalDanaCard(BuildContext context, String total, List<double> factors) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KeuanganPage())),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        decoration: BoxDecoration(
          color: const Color(0xFF7A73C2), 
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF7A73C2).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Dana', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 4),
                FittedBox(child: Text(total, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800))),
                const SizedBox(height: 12),
                Container(
                  height: 40,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: factors.map((f) => _buildGraphBar(f, const Color(0xFFE5C02A))).toList(),
                  ),
                ),
              ],
            ),
            const Positioned(top: 0, right: 0, child: Icon(Icons.arrow_forward, color: Colors.white54, size: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphBar(double heightFactor, Color color) {
    return Container(
      width: 5,
      height: 40 * heightFactor,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildFinanceCards(BuildContext context, String masuk, String keluar) {
    return Row(
      children: [
        Expanded(child: _buildFinanceCard(title: 'Pemasukan', amount: masuk, icon: Icons.arrow_downward, bgColor: const Color(0xFFFFF6E5), waveColor: const Color(0xFFFFC212), borderColor: const Color(0xFFFFC212), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PemasukanPage())))),
        const SizedBox(width: 16),
        Expanded(child: _buildFinanceCard(title: 'Pengeluaran', amount: keluar, icon: Icons.arrow_upward, bgColor: const Color(0xFFE9E8F9), waveColor: const Color(0xFF46467A), borderColor: const Color(0xFF46467A), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PengeluaranPage())))),
      ],
    );
  }

  Widget _buildFinanceCard({required String title, required String amount, required IconData icon, required Color bgColor, required Color waveColor, required Color borderColor, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(23), border: Border.all(color: borderColor, width: 1.5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.5),
            child: Stack(
              children: [
                Positioned.fill(child: Container(color: bgColor)),
                ClipPath(clipper: WaveClipper(isIncome: title == 'Pemasukan'), child: Container(color: waveColor)),
                Positioned(top: 1, left: 1, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: waveColor, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20))),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 16, top: 16, bottom: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 4),
                      FittedBox(child: Text(amount, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> transactions) {
    // Ambil 5 transaksi terbaru saja
    final displayList = transactions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Transaksi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        if (displayList.isEmpty) const Center(child: Text("Belum ada transaksi", style: TextStyle(color: Colors.grey))),
        ...displayList.map((item) => Column(
              children: [
                _buildHistoryItem(
                  item.keterangan ?? 'Transaksi', 
                  '${item.jenis == 'masuk' ? '+' : '-'} Rp${NumberFormat('#,###').format(item.jumlah)}', 
                  item.tanggal ?? '-'
                ),
                const SizedBox(height: 12),
              ],
            )).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String amount, String date) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(amount, style: TextStyle(color: amount.contains('+') ? Colors.green : Colors.red, fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }
}