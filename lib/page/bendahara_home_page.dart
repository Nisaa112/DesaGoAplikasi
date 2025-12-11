import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:desa_go_aplikasi/page/notifikasi_page.dart';
import 'package:desa_go_aplikasi/page/pemasukan_page.dart';
import 'package:desa_go_aplikasi/page/pengeluaran_page.dart';
import 'package:desa_go_aplikasi/page/profil_page.dart';
import 'package:desa_go_aplikasi/widgets/wave_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';

class BendaharaHomePage extends StatefulWidget {
  const BendaharaHomePage({super.key});

  @override
  State<BendaharaHomePage> createState() => _BendaharaHomePageState();
}

class _BendaharaHomePageState extends State<BendaharaHomePage> {
  final String _totalDana = 'Rp250.000,00';
  final String _pemasukan = 'Rp350.000';
  final String _pengeluaran = 'Rp100.000';
  
  final List<Map<String, String>> _riwayatTransaksi = [
    {'title': 'Dana Iuran Warga', 'amount': 'Rp300.000,00', 'date': 'Senin, 23 Juli 2025'},
    {'title': 'Dana Iuran Warga', 'amount': 'Rp300.000,00', 'date': 'Senin, 23 Juli 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) {
                  return _buildHeader(context, authViewModel.userName);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox.shrink(), 
              ),
              _buildTotalDanaCard(context), 
              const SizedBox(height: 24),
              _buildFinanceCards(context),
              const SizedBox(height: 24),
              _buildHistoryList(), 

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? userName) {
    final String displayUserName = userName ?? 'Pengguna';

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
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
            const Text(
              'Hello,',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            Text(
              displayUserName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),
            ),
            const Text(
              'Sebagai Bendahara',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotifikasiPage()),
            );
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications_none, size: 30, color: Colors.grey),
              Container(
                margin: const EdgeInsets.only(top: 2, right: 2),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Center(
                  child: Text('1',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalDanaCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KeuanganPage())
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        decoration: BoxDecoration(
          color: const Color(0xFF7A73C2), 
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7A73C2).withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Dana', 
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.normal)
                ),
                const SizedBox(height: 4),
                Text(
                  _totalDana, 
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)
                ),
                const SizedBox(height: 12),
                
                Container(
                  height: 40,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildGraphBar(0.5, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.8, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.3, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.6, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.2, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.7, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.9, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.4, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.7, const Color(0xFFE5C02A)),
                      _buildGraphBar(0.5, const Color(0xFFE5C02A)),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.arrow_forward, color: Colors.white54, size: 24),
            ),
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
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  
  Widget _buildFinanceCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFinanceCard(
            title: 'Pemasukan',
            amount: 'Rp350.000',
            icon: Icons.arrow_downward,
            bgColor: const Color(0xFFFFF6E5),
            waveColor: const Color(0xFFFFC212),
            borderColor: const Color(0xFFFFC212),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PemasukanPage())
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: 'Pengeluaran',
            amount: 'Rp100.000',
            icon: Icons.arrow_upward,
            bgColor: const Color(0xFFE9E8F9),
            waveColor: const Color(0xFF46467A),
            borderColor: const Color(0xFF46467A),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PengeluaranPage())
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color bgColor,
    required Color waveColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(23),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.5),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: bgColor),
                ),

                ClipPath(
                  clipper: WaveClipper(isIncome: title == 'Pemasukan'),
                  child: Container(color: waveColor),
                ),

                Positioned(
                  top: 1,
                  left: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: waveColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ]
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 16, top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(amount, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black87)),
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

  Widget _buildHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Transaksi:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        ..._riwayatTransaksi.map((item) => Column(
              children: [
                _buildHistoryItem(item['title']!, item['amount']!, item['date']!),
                const SizedBox(height: 12),
              ],
            )).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String amount, String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
              ),
              const SizedBox(height: 4),
              Text(
                amount, 
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14)
              ),
            ],
          ),
          Text(
            date, 
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)
          ),
        ],
      ),
    );
  }
}