import 'package:desa_go_aplikasi/page/informasi_publik_page.dart';
import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:desa_go_aplikasi/page/notifikasi_page.dart';
import 'package:desa_go_aplikasi/page/profil_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/pengaduan_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/transaksi_kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:desa_go_aplikasi/widgets/wave_clipper.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/page/pengaduan_page.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  @override
  void initState() {
    super.initState();
    // Memuat seluruh data saat aplikasi dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });
  }

  void _refreshAllData() {
    context.read<WargaViewModel>().loadWarga();
    context.read<PengaduanViewModel>().fetchPengaduan();
    context.read<TransaksiViewModel>().loadTransaksi();
    context.read<RondaViewModel>().loadRondaData();
    context.read<PosyanduViewmodel>().fetchPosyandu();
    context.read<AgendaViewmodel>().fetchAgenda();
    context.read<RapatViewmodel>().fetchRapat();
  }

  // Fungsi Helper untuk cek tanggal hari ini
  bool _isToday(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return false;
    try {
      DateTime date = DateTime.parse(dateStr.split('T').first);
      DateTime now = DateTime.now();
      return date.year == now.year && date.month == now.month && date.day == now.day;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sinkronisasi data dari ViewModel
    final authVM = context.watch<AuthViewModel>();
    final wargaVM = context.watch<WargaViewModel>();
    final pengaduanVM = context.watch<PengaduanViewModel>();
    final trxVM = context.watch<TransaksiViewModel>();
    final rondaVM = context.watch<RondaViewModel>();
    final posyanduVM = context.watch<PosyanduViewmodel>();
    final agendaVM = context.watch<AgendaViewmodel>();
    final rapatVM = context.watch<RapatViewmodel>();

    final int? adminRwId = authVM.idRw;

    int totalWargaCount = wargaVM.listWarga.where((w) => w.rt?.idRw == adminRwId).length;

    int totalPengaduanCount = pengaduanVM.pengaduanList.length;

    int kegiatanAktifCount = 0;
    kegiatanAktifCount += rondaVM.listRonda.length;
    kegiatanAktifCount += posyanduVM.posyanduList.where((p) => p.status?.toLowerCase() != 'selesai').length;
    kegiatanAktifCount += agendaVM.agendaList.where((a) => a.status?.toLowerCase() != 'selesai').length;
    kegiatanAktifCount += rapatVM.rapatList.where((r) => r.status?.toLowerCase() != 'selesai').length;

    double saldoTotal = 0;
    for (var t in trxVM.listTransaksi) {
      if (t.jenis?.toLowerCase() == 'masuk') saldoTotal += (t.jumlah ?? 0);
      else saldoTotal -= (t.jumlah ?? 0);
    }

    List<Map<String, dynamic>> masterAktivitas = [];

    for (var t in trxVM.listTransaksi) {
      if (_isToday(t.tanggal)) {
        masterAktivitas.add({
          'type': 'transaction',
          'title': t.keterangan ?? 'Transaksi Kas',
          'amount': '${t.jenis == 'masuk' ? '+' : '-'} Rp${NumberFormat('#,###').format(t.jumlah ?? 0)}',
          'status': 'Tercatat',
          'raw_date': t.createdAt ?? t.tanggal,
          'icon': Icons.credit_card,
          'iconColor': const Color(0xFF7A73C2),
        });
      }
    }

    // Filter Kegiatan (Ronda, Posyandu, Agenda, Rapat) Hari Ini
    void addActivityIfToday(String? date, String title, String time, IconData icon, Color color) {
      if (_isToday(date)) {
        masterAktivitas.add({
          'type': 'activity',
          'title': title,
          'time': time,
          'status': 'Hari Ini',
          'raw_date': date,
          'icon': icon,
          'iconColor': color,
        });
      }
    }

    for (var r in rondaVM.listRonda) {
      addActivityIfToday(r.tanggal, 'Ronda Malam', 'Lokasi: ${r.lokasi}', Icons.nightlight_round, Colors.orange);
    }
    for (var p in posyanduVM.posyanduList) {
      addActivityIfToday(p.tanggal, p.judulPosyandu ?? 'Posyandu', 'Pukul ${p.jamMulai ?? "08.00"}', Icons.child_care, Colors.pinkAccent);
    }
    for (var a in agendaVM.agendaList) {
      addActivityIfToday(a.tanggal, a.namaAgenda ?? 'Agenda Desa', 'Lokasi: ${a.lokasi}', Icons.event_note, Colors.blue);
    }
    for (var rp in rapatVM.rapatList) {
      addActivityIfToday(rp.createdAt, rp.judulRapat ?? 'Rapat Desa', 'Lokasi: ${rp.lokasi}', Icons.groups, Colors.teal);
    }

    // Sort by Date
    masterAktivitas.sort((a, b) => (b['raw_date'] ?? '').compareTo(a['raw_date'] ?? ''));

    return Material(
      color: Colors.white,
      child: RefreshIndicator(
        color: const Color(0xFF7A73C2),        // warna utama
        backgroundColor: Colors.white,         // konsisten background
        strokeWidth: 2.5,
        onRefresh: () async {
          _refreshAllData();
          await Future.delayed(const Duration(milliseconds: 600));
        },
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
                  child: Divider(color: Color(0xFFF0F0F0), height: 1),
                ),
                _buildAdminCardsRow1(context, '$kegiatanAktifCount Kegiatan', '$totalPengaduanCount Pengaduan'), 
                const SizedBox(height: 16),
                _buildAdminCardsRow2(context, 'Rp${NumberFormat('#,###').format(saldoTotal)}', '$totalWargaCount Warga'),
                const SizedBox(height: 24),
                _buildHistoryList(masterAktivitas),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );

  }

  // MARK: - Header
  Widget _buildHeader(BuildContext context, String? userName) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
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
            const Text('Hello,', style: TextStyle(color: Colors.black87, fontSize: 16)),
            Text(userName ?? 'Pengguna', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Text('Sebagai Admin RW', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage()));
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications_none, size: 30, color: Colors.grey),
              Container(
                margin: const EdgeInsets.only(top: 2, right: 2),
                width: 15, height: 15,
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminCardsRow1(BuildContext context, String kegiatan, String pengaduan) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context: context,
            title: 'Kegiatan Aktif',
            subtitle: kegiatan,
            bgColor: const Color(0xFF7A73C2),
            isPrimary: true,
            icon: Icons.arrow_forward_ios,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const KegiatanPage()));
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            context: context,
            title: 'Pengaduan Masuk',
            subtitle: pengaduan,
            bgColor: const Color(0xFF7A73C2),
            isPrimary: true,
            icon: Icons.arrow_forward_ios,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PengaduanPage()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminCardsRow2(BuildContext context, String dana, String warga) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Total Dana',
            amount: dana, 
            icon: Icons.wallet_travel,
            bgColor: const Color(0xFFFFF6E5),
            waveColor: const Color(0xFFFFC212),
            borderColor: const Color(0xFFFFC212),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const KeuanganPage()));
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Total Warga',
            amount: warga,
            icon: Icons.groups,
            bgColor: const Color(0xFFE9E8F9),
            waveColor: const Color(0xFF46467A),
            borderColor: const Color(0xFF46467A),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InformasiPublikPage()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required BuildContext context, required String title, required String subtitle, required Color bgColor, required IconData icon, required VoidCallback onTap, required bool isPrimary}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 120, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(24)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.white70)),
              ],
            ),
            Positioned(top: 4, left: 112, child: Icon(icon, color: Colors.white, size: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required BuildContext context, required String title, required String amount, required IconData icon, required Color bgColor, required Color waveColor, required Color borderColor, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(23),
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
                ClipPath(clipper: WaveClipper(isIncome: title == 'Total Dana'), child: Container(color: waveColor)),
                Positioned(
                  top: 1, left: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: waveColor, shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 16, top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          amount,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildHistoryList(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aktivitas Hari Ini:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87)),
        const SizedBox(height: 12),
        if (items.isEmpty) 
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Tidak ada aktivitas hari ini.", style: TextStyle(color: Colors.grey)))),
        ...items.map((item) {
          if (item['type'] == 'transaction') {
            return _buildTransactionItem(title: item['title'], amount: item['amount'], status: item['status'], icon: item['icon'], iconColor: item['iconColor']);
          } else {
            return _buildActivityItem(title: item['title'], time: item['time'], status: item['status'], icon: item['icon'], iconColor: item['iconColor']);
          }
        }).toList(),
      ],
    );
  }

  Widget _buildTransactionItem({required String title, required String amount, required String status, required IconData icon, required Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(amount, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            ]),
          ]),
          Text(status, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActivityItem({required String title, required String time, required String status, required IconData icon, required Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
              ]),
              Text(status, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const Divider(color: Colors.grey, height: 16),
          Text(time, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ],
      ),
    );
  }
}