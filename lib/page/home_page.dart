import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:desa_go_aplikasi/page/notifikasi_page.dart';
import 'package:desa_go_aplikasi/page/pemasukan_page.dart';
import 'package:desa_go_aplikasi/page/pengeluaran_page.dart';
import 'package:desa_go_aplikasi/page/profil_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/transaksi_kas_viewmodel.dart';
import 'package:desa_go_aplikasi/widgets/wave_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });
  }

  Future<void> _refreshAllData() async {
    context.read<TransaksiViewModel>().loadTransaksi();
    context.read<RondaViewModel>().loadRondaData();
    context.read<PosyanduViewmodel>().fetchPosyandu();
    context.read<AgendaViewmodel>().fetchAgenda();
    context.read<RapatViewmodel>().fetchRapat();
  }

  // --- LOGIKA STATUS OTOMATIS BERDASARKAN WAKTU ---
  String _determineStatus(String? dateStr, String? timeStr) {
    if (dateStr == null) return 'N/A';
    try {
      DateTime now = DateTime.now();
      DateTime activityDate = DateTime.parse(dateStr.split('T').first);
      DateTime today = DateTime(now.year, now.month, now.day);

      if (activityDate.isBefore(today)) return 'Selesai';
      if (activityDate.isAfter(today)) return 'Mendatang';

      if (timeStr != null && timeStr.isNotEmpty) {
        int startHour = int.parse(timeStr.split(':').first);
        int startMinute = int.parse(timeStr.split(':')[1]);
        DateTime activityTime = DateTime(now.year, now.month, now.day, startHour, startMinute);
        
        if (now.isBefore(activityTime)) return 'Mendatang';
        return 'Berlangsung';
      }
      return 'Berlangsung';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final trxVM = context.watch<TransaksiViewModel>();
    final rondaVM = context.watch<RondaViewModel>();
    final posyanduVM = context.watch<PosyanduViewmodel>();
    final agendaVM = context.watch<AgendaViewmodel>();
    final rapatVM = context.watch<RapatViewmodel>();

    // --- PROSES DATA KEGIATAN ---
    List<Map<String, String>> todaySchedule = [];
    List<Map<String, String>> finishedHistory = [];

    void process(String? date, String? time, String title, String lokasi) {
      if (date == null) return;
      String status = _determineStatus(date, time);
      String formattedDate = date.split('T').first;
      String subtitle = "Pukul ${time ?? '08:00'}, Lokasi di $lokasi";

      if (status == 'Selesai') {
        finishedHistory.add({'title': title, 'subtitle': subtitle, 'status': 'Selesai ($formattedDate)'});
      } else {
        DateTime activityDate = DateTime.parse(formattedDate);
        DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        if (activityDate.isAtSameMomentAs(today) || activityDate.isAfter(today)) {
          todaySchedule.add({'title': title, 'subtitle': subtitle});
        }
      }
    }

    for (var r in rondaVM.listRonda) process(r.tanggal, "21:00", "Pos Ronda", r.lokasi ?? "-");
    for (var p in posyanduVM.posyanduList) process(p.tanggal, p.jamMulai, p.judulPosyandu ?? "Posyandu", p.lokasi ?? "-");
    for (var a in agendaVM.agendaList) process(a.tanggal, a.jamMulai, a.namaAgenda ?? "Agenda", a.lokasi ?? "-");
    for (var rp in rapatVM.rapatList) process(rp.createdAt, rp.jamMulai, rp.judulRapat ?? "Rapat", rp.lokasi ?? "-");

    finishedHistory = finishedHistory.reversed.toList();

    double totalMasuk = 0;
    double totalKeluar = 0;
    for (var t in trxVM.listTransaksi) {
      if (t.jenis?.toLowerCase() == 'masuk') totalMasuk += (t.jumlah ?? 0);
      else totalKeluar += (t.jumlah ?? 0);
    }

    return Material(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _refreshAllData,
        color: const Color(0xFFFFC212),
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
                _buildScheduleCard(context, todaySchedule),
                const SizedBox(height: 24),
                _buildFinanceCards(context, totalMasuk, totalKeluar),
                const SizedBox(height: 24),
                _buildHistoryList(finishedHistory),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
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
            const Text('Sebagai Warga', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, size: 30, color: Colors.grey),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context, List<Map<String, String>> items) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KegiatanPage())),
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Color(0xFF7A73C2)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                bottom: -40,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset('assets/icon_jam.png', height: 130),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jadwal Kegiatan', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const Text('Mendatang & Hari ini', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 16),
                  
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: items.isEmpty 
                    ? const Align(
                        alignment: Alignment.centerLeft, // Dipindah ke kiri
                        child: Text("Tidak ada jadwal terdekat", style: TextStyle(color: Colors.white60, fontStyle: FontStyle.italic)),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Pastikan konten rata kiri
                          children: items.map((item) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildScheduleItem(item['title']!, item['subtitle']!),
                                if (item != items.last)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Divider(color: Colors.white24, height: 1),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                  ),
                ],
              ),
              const Positioned(top: 0, right: 0, child: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)),
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

  Widget _buildFinanceCards(BuildContext context, double masuk, double keluar) {
    return Row(
      children: [
        Expanded(child: _buildFinanceCard(title: 'Pemasukan', amount: 'Rp${NumberFormat('#,###').format(masuk)}', icon: Icons.arrow_downward, bgColor: const Color(0xFFFFF6E5), waveColor: const Color(0xFFFFC212), borderColor: const Color(0xFFFFC212), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  PemasukanPage())))),
        const SizedBox(width: 16),
        Expanded(child: _buildFinanceCard(title: 'Pengeluaran', amount: 'Rp${NumberFormat('#,###').format(keluar)}', icon: Icons.arrow_upward, bgColor: const Color(0xFFE9E8F9), waveColor: const Color(0xFF46467A), borderColor: const Color(0xFF46467A), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  PengeluaranPage())))),
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
                      FittedBox(child: Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))),
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

  Widget _buildHistoryList(List<Map<String, String>> riwayat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Kegiatan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        if (riwayat.isEmpty)
          const Align(
            alignment: Alignment.centerLeft, // Dipindah ke kiri
            child: Text("Belum ada riwayat kegiatan selesai", style: TextStyle(color: Colors.grey, fontSize: 13)),
          )
        else
          ...riwayat.take(5).map((item) => Column(
                children: [
                  _buildHistoryItem(item['title']!, item['subtitle']!, item['status']!),
                  const SizedBox(height: 12),
                ],
              )).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String status) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
              Text(status, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
            ],
          ),
          const Divider(color: Colors.grey),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
  }
}