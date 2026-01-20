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

  // --- LOGIKA MAPPING DATA KE UI LIST ---
  List<Map<String, dynamic>> _mapAllDataToKegiatanList(BuildContext context) {
    List<Map<String, dynamic>> list = [];
    final rondaVM = context.watch<RondaViewModel>();
    final posyanduVM = context.watch<PosyanduViewmodel>();
    final agendaVM = context.watch<AgendaViewmodel>();
    final rapatVM = context.watch<RapatViewmodel>();

    Map<String, dynamic> determineStatus(String? dateString, String? timeString) {
      if (dateString == null) return {'status': 'N/A', 'waktu': 'N/A'};
      try {
        DateTime now = DateTime.now();
        DateTime activityDate = DateTime.parse(dateString.split('T').first);
        DateTime today = DateTime(now.year, now.month, now.day);

        String displayTime = (timeString != null && timeString.length >= 5) 
            ? timeString.substring(0, 5) 
            : "08:00";

        if (activityDate.isBefore(today)) return {'status': 'Selesai', 'waktu': displayTime};
        if (activityDate.isAfter(today)) return {'status': 'Akan Datang', 'waktu': displayTime};

        if (timeString != null && timeString.isNotEmpty) {
          List<String> parts = timeString.split(':');
          int startHour = int.parse(parts[0]);
          int startMinute = int.parse(parts[1]);
          DateTime startDateTime = DateTime(now.year, now.month, now.day, startHour, startMinute);

          if (now.isBefore(startDateTime)) return {'status': 'Akan Datang', 'waktu': displayTime};
          return {'status': 'Berlangsung', 'waktu': displayTime};
        }
        return {'status': 'Berlangsung', 'waktu': displayTime};
      } catch (e) {
        return {'status': 'N/A', 'waktu': 'N/A'};
      }
    }

    for (var r in rondaVM.listRonda) {
      String? jam = (r.detailRondas != null && r.detailRondas!.isNotEmpty) ? r.detailRondas!.first.jamMulai : "22:00";
      var info = determineStatus(r.tanggal, jam);
      list.add({'tipe': 'Ronda', 'nama': 'Ronda Malam', 'tanggal': r.tanggal?.split('T').first ?? 'N/A', 'waktu': "${info['waktu']} - Selesai", 'status': info['status'], 'lokasi': r.lokasi ?? 'Pos Ronda', 'original_data': r});
    }
    for (var p in posyanduVM.posyanduList) {
      var info = determineStatus(p.tanggal, p.jamMulai);
      list.add({'tipe': 'Posyandu', 'nama': p.judulPosyandu ?? 'Posyandu', 'tanggal': p.tanggal?.split('T').first ?? 'N/A', 'waktu': "${info['waktu']} - Selesai", 'status': info['status'], 'lokasi': p.lokasi ?? 'Balai Desa', 'original_data': p});
    }
    for (var a in agendaVM.agendaList) {
      var info = determineStatus(a.tanggal, a.jamMulai);
      list.add({'tipe': 'Agenda', 'nama': a.namaAgenda ?? 'Agenda Desa', 'tanggal': a.tanggal?.split('T').first ?? 'N/A', 'waktu': "${info['waktu']} - Selesai", 'status': info['status'], 'lokasi': a.lokasi ?? 'Balai Desa', 'original_data': a});
    }
    for (var rp in rapatVM.rapatList) {
      var info = determineStatus(rp.tanggal, rp.jamMulai);
      list.add({'tipe': 'Rapat', 'nama': rp.judulRapat ?? 'Rapat Desa', 'tanggal': rp.tanggal?.split('T').first ?? 'N/A', 'waktu': "${info['waktu']} - Selesai", 'status': info['status'], 'lokasi': rp.lokasi ?? 'Kantor Desa', 'original_data': rp});
    }
    list.sort((a, b) => (b['tanggal'] ?? '').compareTo(a['tanggal'] ?? ''));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Consumer4<RondaViewModel, PosyanduViewmodel, AgendaViewmodel, RapatViewmodel>(
      builder: (context, rondaVM, posyanduVM, agendaVM, rapatVM, child) {
        final allData = _mapAllDataToKegiatanList(context);
        final filteredKegiatan = allData.where((k) => k['tipe'] == _filters[_selectedFilterIndex]).toList();
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
          // TOMBOL TAMBAH DIHAPUS (READ-ONLY)
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
                    color: const Color(0xFFFFC212),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      await Future.wait([
                        context.read<RondaViewModel>().synchronizeRonda(),
                        context.read<PosyanduViewmodel>().synchronizePosyandu(),
                        context.read<AgendaViewmodel>().synchronizeAgenda(),
                        context.read<RapatViewmodel>().fetchRapat(),
                      ]);
                    },
                    child: (isLoading && filteredKegiatan.isEmpty)
                        ? const Center(child: CircularProgressIndicator())
                        : filteredKegiatan.isEmpty
                            ? ListView(children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                                Center(child: Text('Tidak ada ${_filters[_selectedFilterIndex]} yang ditemukan.', style: TextStyle(color: Colors.grey.shade600))),
                              ])
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                                itemCount: filteredKegiatan.length,
                                itemBuilder: (context, index) => _buildKegiatanCard(filteredKegiatan[index]),
                              ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold),
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
      // ON TAP TETAP ADA UNTUK MELIHAT DETAIL
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => DetailKegiatanPage(kegiatan: kegiatan))
      ),
      // ON LONG PRESS DIHAPUS (READ-ONLY)
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100, 
          borderRadius: BorderRadius.circular(20), 
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
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(kegiatan['status']!), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    kegiatan['status']!, 
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 10),
                Text(kegiatan['tanggal']!, style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 10),
                Text(kegiatan['waktu']!, style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    kegiatan['lokasi']!, 
                    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
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