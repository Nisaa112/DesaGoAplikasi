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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                child: Divider(color: Color(0xFFF0F0F0), height: 1),
              ),
              _buildScheduleCard(context),
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
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              displayUserName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),
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

  Widget _buildScheduleCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KegiatanPage())
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF7A73C2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                bottom: -40,
                child: Image.asset(
                  'assets/icon_jam.png',
                  height: 130,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jadwal Kegiatan', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const Text('Hari ini', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 16),
                  _buildScheduleItem('Pos Ronda', 'Pukul 21.00, Lokasi di Pos Ronda'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                    child: Divider(color: Colors.white24),
                  ),
                  _buildScheduleItem('Posyandu', 'Pukul 10.00, Lokasi di Puskesmas Citra'),
                ],
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
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
          'Riwayat Kegiatan:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        _buildHistoryItem('Posyandu', 'Pukul 10.00, Lokasi di Puskesmas Sehat', 'Selesai Pukul 12.00'),
        const SizedBox(height: 12),
        _buildHistoryItem('Posyandu', 'Pukul 10.00, Lokasi di Puskesmas Sehat', 'Selesai Pukul 12.00'),
        const SizedBox(height: 12),
        _buildHistoryItem('Posyandu', 'Pukul 10.00, Lokasi di Puskesmas Sehat', 'Selesai Pukul 12.00'),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
              Text(status, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const Divider(color: Colors.grey),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ],
      ),
    );
  }
}