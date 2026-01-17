import 'package:desa_go_aplikasi/page/detail_kegiatan_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Ronda', 'Posyandu', 'Agenda', 'Rapat'];
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // Memicu pemuatan data dari Database Lokal + Sync API untuk semua kategori
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RondaViewModel>().loadRondaData();
        context.read<PosyanduViewmodel>().fetchPosyandu();
        context.read<AgendaViewmodel>().fetchAgenda();
        context.read<RapatViewmodel>().fetchRapat();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  // Fungsi untuk menyatukan berbagai model data ke satu format Map untuk UI
  List<Map<String, dynamic>> _mapAllDataToKegiatanList(
    RondaViewModel rondaVM,
    PosyanduViewmodel posyanduVM,
    AgendaViewmodel agendaVM,
    RapatViewmodel rapatVM,
  ) {
    List<Map<String, dynamic>> list = [];

    // Helper untuk menentukan status berdasarkan tanggal
    Map<String, dynamic> determineStatus(String dateString, {String timeStart = '', String timeEnd = ''}) {
      try {
        DateTime date = DateTime.parse(dateString.split('T').first);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        String formattedWaktu = (timeStart.isNotEmpty && timeEnd.isNotEmpty) ? '$timeStart - $timeEnd' : '08:00 - Selesai';

        if (date.isBefore(today)) {
          return {'status': 'Selesai', 'waktu': formattedWaktu};
        } else if (date.isAtSameMomentAs(today)) {
          return {'status': 'Berlangsung', 'waktu': formattedWaktu};
        } else {
          return {'status': 'Akan Datang', 'waktu': formattedWaktu};
        }
      } catch (e) {
        return {'status': 'N/A', 'waktu': 'N/A'};
      }
    }

    // 1. Mapping RONDA (Disesuaikan dengan model RondaData baru)
    for (var r in rondaVM.listRonda) {
      // Mengambil jam dari detail pertama jika ada
      String jamMulai = r.detailRondas?.isNotEmpty == true ? r.detailRondas!.first.jamMulai?.substring(0, 5) ?? '22:00' : '22:00';
      String jamSelesai = r.detailRondas?.isNotEmpty == true ? r.detailRondas!.first.jamSelesai?.substring(0, 5) ?? '04:00' : '04:00';
      var info = determineStatus(r.tanggal ?? '', timeStart: jamMulai, timeEnd: jamSelesai);

      list.add({
        'tipe': 'Ronda',
        'nama': 'Ronda Malam',
        'tanggal': r.tanggal?.split('T').first ?? 'N/A',
        'waktu': info['waktu'],
        'status': info['status'],
        'lokasi': r.lokasi ?? 'Pos Kamling',
        'original_data': r, // Menyimpan objek asli untuk detail page
      });
    }

    // 2. Mapping POSYANDU
    for (var p in posyanduVM.posyanduList) {
      var info = determineStatus(p.tanggal ?? '');
      list.add({
        'tipe': 'Posyandu',
        'nama': p.judulPosyandu ?? 'Kegiatan Posyandu',
        'tanggal': p.tanggal?.split('T').first ?? 'N/A',
        'waktu': '08:00 - 11:00',
        'status': info['status'],
        'lokasi': p.lokasi ?? 'Balai Desa',
        'original_data': p,
      });
    }

    // 3. Mapping AGENDA
    for (var a in agendaVM.agendaList) {
      var info = determineStatus(a.tanggal ?? '');
      list.add({
        'tipe': 'Agenda',
        'nama': a.namaAgenda ?? 'Agenda Desa',
        'tanggal': a.tanggal?.split('T').first ?? 'N/A',
        'waktu': '09:00 - Selesai',
        'status': info['status'],
        'lokasi': a.lokasi ?? 'Kantor Desa',
        'original_data': a,
      });
    }

    // 4. Mapping RAPAT
    for (var rp in rapatVM.rapatList) {
      // Rapat biasanya pakai createdAt jika tidak ada field tanggal khusus
      var info = determineStatus(rp.createdAt ?? '');
      list.add({
        'tipe': 'Rapat',
        'nama': rp.judulRapat ?? 'Rapat Warga',
        'tanggal': rp.createdAt?.split('T').first ?? 'N/A',
        'waktu': '19:30 - Selesai',
        'status': info['status'],
        'lokasi': rp.lokasi ?? 'Balai Pertemuan',
        'original_data': rp,
      });
    }

    // Urutkan berdasarkan tanggal terbaru
    list.sort((a, b) => (b['tanggal'] ?? '').compareTo(a['tanggal'] ?? ''));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Consumer4<RondaViewModel, PosyanduViewmodel, AgendaViewmodel, RapatViewmodel>(
      builder: (context, rondaVM, posyanduVM, agendaVM, rapatVM, child) {
        // Gabungkan semua data
        final allData = _mapAllDataToKegiatanList(rondaVM, posyanduVM, agendaVM, rapatVM);
        
        // Filter berdasarkan chip yang dipilih
        final filteredKegiatan = allData.where((k) => k['tipe'] == _filters[_selectedFilterIndex]).toList();
        
        // Status loading gabungan
        final isLoading = rondaVM.isLoading || posyanduVM.isLoading || agendaVM.isLoading || rapatVM.isLoading;

        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Jadwal Kegiatan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Trigger sinkronisasi ulang semua data dari API
                      await Future.wait([
                        rondaVM.synchronizeRonda(),
                        posyanduVM.fetchPosyandu(),
                        agendaVM.fetchAgenda(),
                        rapatVM.fetchRapat(),
                      ]);
                    },
                    child: _buildListContent(isLoading, filteredKegiatan),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListContent(bool isLoading, List<Map<String, dynamic>> items) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return ListView( // Gunakan ListView agar RefreshIndicator tetap bekerja saat kosong
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Text(
              'Tidak ada ${_filters[_selectedFilterIndex]} ditemukan.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildKegiatanCard(items[index]),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            bool isSelected = _selectedFilterIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKegiatanCard(Map<String, dynamic> kegiatan) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Berlangsung': return const Color(0xFF4CAF50);
        case 'Akan Datang': return const Color(0xFF7A73C2);
        case 'Selesai': return const Color(0xFF2C2C2C);
        default: return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailKegiatanPage(kegiatan: kegiatan)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    kegiatan['nama']!,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(kegiatan['status']!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    kegiatan['status']!,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(kegiatan['tanggal']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(kegiatan['waktu']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    kegiatan['lokasi']!,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
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