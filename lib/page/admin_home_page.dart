import 'package:desa_go_aplikasi/page/informasi_publik_page.dart';
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
import 'package:desa_go_aplikasi/page/pengaduan_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final String _kegiatanAktif = '12 Kegiatan';
  final String _pengaduanMasuk = '09 Pengaduan';
  final String _totalDana = 'Rp450.000';
  final String _totalWarga = '250 Warga';
  
  final List<Map<String, String>> _aktivitasTerbaru = [
    {'type': 'transaction', 'title': 'Dana Iuran Warga', 'amount': '+Rp200.000,00', 'status': '9/12'},
    {'type': 'activity', 'title': 'Posyandu', 'time': 'Pukul 10.00, Lokasi di Puskesmas Sehat', 'status': 'Selesai Pukul 12.00'},
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
                child: Divider(color: Color(0xFFF0F0F0), height: 1),
              ),
              _buildAdminCardsRow1(context), 
              const SizedBox(height: 16),
              _buildAdminCardsRow2(context),
              const SizedBox(height: 24),
              _buildHistoryList(), 

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Header
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
              'Sebagai Admin RW',
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

  // MARK: - Baris 1: Kegiatan Aktif & Pengaduan Masuk
  Widget _buildAdminCardsRow1(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context: context,
            title: 'Kegiatan Aktif',
            subtitle: _kegiatanAktif,
            bgColor: const Color(0xFF7A73C2),
            isPrimary: true,
            icon: Icons.arrow_forward_ios,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KegiatanPage())
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            context: context,
            title: 'Pengaduan Masuk',
            subtitle: _pengaduanMasuk,
            bgColor: const Color(0xFF7A73C2),
            isPrimary: true,
            icon: Icons.arrow_forward_ios,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PengaduanPage())
              );
            },
          ),
        ),
      ],
    );
  }

  // MARK: - Baris 2: Total Dana & Total Warga
  Widget _buildAdminCardsRow2(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Total Dana',
            amount: _totalDana, 
            icon: Icons.wallet_travel,
            bgColor: const Color(0xFFFFF6E5),
            waveColor: const Color(0xFFFFC212),
            borderColor: const Color(0xFFFFC212),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KeuanganPage())
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Total Warga',
            amount: _totalWarga,
            icon: Icons.groups,
            bgColor: const Color(0xFFE9E8F9),
            waveColor: const Color(0xFF46467A),
            borderColor: const Color(0xFF46467A),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InformasiPublikPage()) 
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color bgColor,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconBgColor,
    required bool isPrimary, 
  }) {
    if (isPrimary) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white70,
                      decorationThickness: 1.5
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 4,
                left: 112,
                child: Icon(icon, color: Colors.white, size: 15),
              ),
              const Positioned(
                right: -20,
                bottom: -20,
                child: SizedBox.shrink(),
              )
            ],
          ),
        ),
      );
    } 
    else {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }


  Widget _buildStatCard({
    required BuildContext context,
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
                  clipper: WaveClipper(isIncome: title == 'Total Dana'),
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
                    crossAxisAlignment: CrossAxisAlignment.end, // Teks rata kanan
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

  // MARK: - Aktivitas Terbaru (Menggantikan Riwayat Transaksi/Kegiatan)
  Widget _buildHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        ..._aktivitasTerbaru.map((item) {
          if (item['type'] == 'transaction') {
            return Column(
              children: [
                _buildTransactionItem(
                  title: item['title']!,
                  amount: item['amount']!,
                  status: item['status']!,
                ),
                const SizedBox(height: 12),
              ],
            );
          } else if (item['type'] == 'activity') {
            return Column(
              children: [
                _buildActivityItem(
                  title: item['title']!,
                  time: item['time']!,
                  status: item['status']!,
                ),
                const SizedBox(height: 12),
              ],
            );
          }
          return const SizedBox.shrink();
        }).toList(),
      ],
    );
  }

  Widget _buildTransactionItem({required String title, required String amount, required String status}) {
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
          Row(
            children: [
              const Icon(Icons.credit_card, color: Color(0xFF7A73C2), size: 28),
              const SizedBox(width: 12),
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
            ],
          ),
          Text(
            status,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({required String title, required String time, required String status}) {
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
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink, size: 28), // Ikon love/heart
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
                  ),
                ],
              ),
              Text(
                status,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)
              ),
            ],
          ),
          const Divider(color: Colors.grey, height: 16), // Divider putih untuk pemisah
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14)
          ),
        ],
      ),
    );
  }
}